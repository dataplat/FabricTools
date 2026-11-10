function Get-CommandMaturity
{
    <#
    .SYNOPSIS
        Computes the maturity level of each public cmdlet.

    .DESCRIPTION
        Implements the Cmdlet Maturity Model described in docs/maturity-model.md.

        Levels 1 to 4 are computed from the source by static analysis (no built module is
        needed): comment-based help, coding conventions, unit tests and integration tests.
        Levels are cumulative, so a cmdlet reaches a level only when it meets the criteria
        of that level and of every level below it.

        The judgement calls that cannot be computed come from the maturity manifest
        (.build/Maturity.psd1):
        - Experimental: cmdlets forced to level 0, whatever they score.
        - ProductionReady: maintainer sign-off that lifts a level 4 cmdlet to level 5.
        - Exemptions: checks that do not apply to a given cmdlet; they count as passed.

        Each returned object lists every check with its result, so the output also tells a
        contributor what is missing to reach the next level.

    .PARAMETER PublicPath
        Path to the src/Public folder.

    .PARAMETER UnitTestPath
        Path to the folder that holds the unit tests (searched recursively for <Cmdlet>.Tests.ps1).

    .PARAMETER IntegrationTestPath
        Path to the folder that holds the integration tests (*.Tests.ps1).

    .PARAMETER ManifestPath
        Path to the maturity manifest. When the file does not exist, no overrides apply.

    .EXAMPLE
        $params = @{
            PublicPath          = './src/Public'
            UnitTestPath        = './tests/Unit'
            IntegrationTestPath = './tests/Integration'
            ManifestPath        = './.build/Maturity.psd1'
        }
        Get-CommandMaturity @params | Group-Object Level
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $PublicPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $UnitTestPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $IntegrationTestPath,

        [Parameter()]
        [System.String]
        $ManifestPath
    )

    $levelNames = @{
        0 = 'Experimental'
        1 = 'Prototype'
        2 = 'Standardized'
        3 = 'Unit Tested'
        4 = 'Integration Tested'
        5 = 'Production Ready'
    }

    # Verbs whose cmdlets change state and must therefore support -WhatIf/-Confirm.
    $stateChangingVerbs = @(
        'Add', 'Import', 'Initialize', 'New', 'Publish', 'Refresh', 'Remove', 'Resume',
        'Revoke', 'Set', 'Start', 'Stop', 'Suspend', 'Update', 'Write'
    )

    #region Manifest
    $manifest = @{ Experimental = @{}; ProductionReady = @{}; Exemptions = @{} }
    if ($ManifestPath -and (Test-Path -Path $ManifestPath))
    {
        $data = Import-PowerShellDataFile -Path $ManifestPath
        foreach ($key in @($manifest.Keys))
        {
            if ($data[$key]) { $manifest[$key] = $data[$key] }
        }
    }
    #endregion

    #region Helpers
    function Get-ParsedFile
    {
        param ([System.String] $Path)

        $tokens = $null
        $errors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref] $tokens, [ref] $errors)
        @{ Ast = $ast; Tokens = $tokens }
    }

    function Test-HandleResponse
    {
        # True when every Invoke-FabricRestMethod call in the function sets HandleResponse to $true,
        # either as -HandleResponse or through a splatted hashtable that sets it
        # (@{ HandleResponse = $true } or $params.HandleResponse = $true).
        param ($FunctionAst)

        $splatsWithHandleResponse = @{}
        $assignments = $FunctionAst.FindAll({ $args[0] -is [System.Management.Automation.Language.AssignmentStatementAst] }, $true)
        foreach ($assignment in $assignments)
        {
            $target = $assignment.Left
            if ($target -is [System.Management.Automation.Language.ConvertExpressionAst]) { $target = $target.Child }

            if ($target -is [System.Management.Automation.Language.VariableExpressionAst])
            {
                $hashtable = $assignment.Right.Find({ $args[0] -is [System.Management.Automation.Language.HashtableAst] }, $true)
                $setsIt = $hashtable -and ($hashtable.KeyValuePairs | Where-Object {
                        $_.Item1.Extent.Text.Trim("'", '"') -eq 'HandleResponse' -and $_.Item2.Extent.Text.Trim() -eq '$true'
                    })
                if ($setsIt) { $splatsWithHandleResponse[$target.VariablePath.UserPath] = $true }
            }
            elseif ($target -is [System.Management.Automation.Language.MemberExpressionAst] -and
                $target.Member.Extent.Text -eq 'HandleResponse' -and $assignment.Right.Extent.Text.Trim() -eq '$true' -and
                $target.Expression -is [System.Management.Automation.Language.VariableExpressionAst])
            {
                $splatsWithHandleResponse[$target.Expression.VariablePath.UserPath] = $true
            }
        }

        $calls = $FunctionAst.FindAll({
                $args[0] -is [System.Management.Automation.Language.CommandAst] -and
                $args[0].GetCommandName() -eq 'Invoke-FabricRestMethod'
            }, $true)

        foreach ($call in $calls)
        {
            $ok = $false
            foreach ($element in $call.CommandElements)
            {
                if ($element -is [System.Management.Automation.Language.CommandParameterAst] -and
                    $element.ParameterName -eq 'HandleResponse' -and
                    (-not $element.Argument -or $element.Argument.Extent.Text -eq '$true'))
                {
                    $ok = $true
                }
                elseif ($element -is [System.Management.Automation.Language.VariableExpressionAst] -and
                    $element.Splatted -and $splatsWithHandleResponse[$element.VariablePath.UserPath])
                {
                    $ok = $true
                }
            }
            if (-not $ok) { return $false }
        }
        $true
    }

    function Get-InvokedCommandName
    {
        # Names of every command invoked in a script (e.g. 'Get-FabricLakehouse', 'Mock').
        param ($Ast)

        $Ast.FindAll({ $args[0] -is [System.Management.Automation.Language.CommandAst] }, $true) |
            ForEach-Object { $_.GetCommandName() } |
            Where-Object { $_ }
    }
    #endregion

    #region Integration tests: which cmdlets are called by any of them
    $integrationCalls = @{}
    if (Test-Path -Path $IntegrationTestPath)
    {
        foreach ($file in Get-ChildItem -Path $IntegrationTestPath -Filter '*.Tests.ps1' -Recurse -File)
        {
            foreach ($name in Get-InvokedCommandName -Ast (Get-ParsedFile -Path $file.FullName).Ast)
            {
                $integrationCalls[$name] = $true
            }
        }
    }
    #endregion

    #region Unit tests: index by file name
    $unitTests = @{}
    if (Test-Path -Path $UnitTestPath)
    {
        foreach ($file in Get-ChildItem -Path $UnitTestPath -Filter '*.Tests.ps1' -Recurse -File)
        {
            $unitTests[$file.Name -replace '\.Tests\.ps1$', ''] = $file.FullName
        }
    }
    #endregion

    $root = (Resolve-Path -Path $PublicPath).Path.TrimEnd('\', '/')
    $results = [System.Collections.Generic.List[object]]::new()

    foreach ($file in Get-ChildItem -Path $root -Filter '*.ps1' -Recurse -File | Sort-Object -Property BaseName)
    {
        $parsed = Get-ParsedFile -Path $file.FullName
        $relative = $file.DirectoryName.Substring($root.Length).Trim('\', '/')
        $itemType = if ($relative) { ($relative -split '[\\/]')[0] } else { 'Core' }

        $functions = $parsed.Ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false) |
            Where-Object { $_.Parent.Parent -eq $parsed.Ast -or $_.Parent -eq $parsed.Ast.EndBlock }

        foreach ($function in $functions)
        {
            $name = $function.Name
            $help = $function.GetHelpContent()
            $paramBlock = $function.Body.ParamBlock
            $parameterNames = @()
            if ($paramBlock) { $parameterNames = @($paramBlock.Parameters | ForEach-Object { $_.Name.VariablePath.UserPath }) }

            $cmdletBinding = $paramBlock -and ($paramBlock.Attributes | Where-Object { $_.TypeName.Name -eq 'CmdletBinding' })
            $supportsShouldProcess = $paramBlock -and ($paramBlock.Attributes | Where-Object {
                    $_.TypeName.Name -eq 'CmdletBinding' -and ($_.NamedArguments | Where-Object { $_.ArgumentName -eq 'SupportsShouldProcess' })
                })

            $invoked = @(Get-InvokedCommandName -Ast $function)
            $functionTokens = $parsed.Tokens | Where-Object {
                $_.Extent.StartOffset -ge $function.Extent.StartOffset -and $_.Extent.EndOffset -le $function.Extent.EndOffset
            }

            $documentedParameters = @()
            if ($help) { $documentedParameters = @($help.Parameters.Keys) }
            $undocumented = @($parameterNames | Where-Object { $documentedParameters -notcontains $_.ToUpperInvariant() })

            $verb = ($name -split '-')[0]

            # Unit test: must mock something and actually run the cmdlet (not only inspect it with Get-Command).
            $unitTestPath = $unitTests[$name]
            $unitInvoked = @()
            if ($unitTestPath) { $unitInvoked = @(Get-InvokedCommandName -Ast (Get-ParsedFile -Path $unitTestPath).Ast) }

            $checks = [ordered]@{
                HasSynopsis               = [bool]($help -and $help.Synopsis -and $help.Synopsis.Trim())
                HasDescription            = [bool]($help -and $help.Description -and $help.Description.Trim())
                ParametersDocumented      = ($undocumented.Count -eq 0)
                HasExample                = [bool]($help -and $help.Examples.Count -gt 0)
                HasCmdletBinding          = [bool]$cmdletBinding
                UsesFabricRestMethod      = -not ($invoked | Where-Object { $_ -in 'Invoke-RestMethod', 'Invoke-WebRequest' })
                HandleResponse            = (Test-HandleResponse -FunctionAst $function)
                UsesWriteMessage          = -not ($invoked | Where-Object { $_ -in 'Write-Host', 'Write-Verbose' })
                NoBacktickContinuation    = -not ($functionTokens | Where-Object { $_.Kind -eq 'LineContinuation' })
                SupportsShouldProcess     = ($stateChangingVerbs -notcontains $verb) -or [bool]$supportsShouldProcess
                HasUnitTest               = [bool]$unitTestPath
                UnitTestExercisesCmdlet   = ($unitInvoked -contains 'Mock') -and ($unitInvoked -contains $name)
                HasIntegrationTest        = [bool]$integrationCalls[$name]
            }

            foreach ($exempt in @($manifest.Exemptions[$name]))
            {
                if ($exempt -and $checks.Contains($exempt)) { $checks[$exempt] = $true }
            }

            # Plain hashtable on purpose: an integer index on an ordered dictionary is positional.
            $requirements = @{
                1 = @('HasSynopsis')
                2 = @('HasDescription', 'ParametersDocumented', 'HasExample', 'HasCmdletBinding', 'UsesFabricRestMethod',
                    'HandleResponse', 'UsesWriteMessage', 'NoBacktickContinuation', 'SupportsShouldProcess')
                3 = @('HasUnitTest', 'UnitTestExercisesCmdlet')
                4 = @('HasIntegrationTest')
            }

            $computed = 0
            foreach ($level in 1..4)
            {
                if (@($requirements[$level] | Where-Object { -not $checks[$_] }).Count -gt 0) { break }
                $computed = $level
            }

            $level = $computed
            $note = $null
            if ($manifest.Experimental.Contains($name))
            {
                $level = 0
                $note = "Experimental: $($manifest.Experimental[$name])"
            }
            elseif ($manifest.ProductionReady.Contains($name))
            {
                if ($computed -eq 4)
                {
                    $level = 5
                    $note = "Production Ready: $($manifest.ProductionReady[$name])"
                }
                else
                {
                    $note = 'Listed as Production Ready in the manifest, but does not meet level 4.'
                }
            }

            # What is missing for the next level (empty at level 5 and for Experimental cmdlets).
            $missing = @()
            if ($manifest.Experimental.Contains($name))
            {
                $missing = @('Remove from Experimental in the manifest')
            }
            elseif ($computed -lt 4)
            {
                $missing = @($requirements[$computed + 1] | Where-Object { -not $checks[$_] })
            }
            elseif ($level -eq 4)
            {
                $missing = @('Maintainer sign-off (ProductionReady in the manifest)')
            }

            $results.Add([pscustomobject]@{
                Name           = $name
                ItemType       = $itemType
                Level          = $level
                LevelName      = $levelNames[$level]
                ComputedLevel  = $computed
                Checks         = $checks
                MissingForNext = $missing
                Note           = $note
                Path           = $file.FullName
            })
        }
    }

    # A function defined in more than one file: only one definition wins at import time.
    foreach ($group in $results | Group-Object -Property Name | Where-Object Count -gt 1)
    {
        $files = ($group.Group | ForEach-Object { Split-Path -Path $_.Path -Leaf }) -join ', '
        foreach ($item in $group.Group)
        {
            $duplicate = "Defined in more than one file ($files)."
            $item.Note = (@($item.Note, $duplicate) | Where-Object { $_ }) -join ' '
        }
    }

    $results
}
