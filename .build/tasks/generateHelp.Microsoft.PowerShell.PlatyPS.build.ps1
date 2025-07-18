param
(
    [Parameter()]
    [System.IO.DirectoryInfo]
    $ProjectPath = (property ProjectPath $BuildRoot),

    [Parameter()]
    [System.String]
    $ProjectName = (property ProjectName ''),

    [Parameter()]
    [System.String]
    $SourcePath = (property SourcePath ''),

    [Parameter()]
    [System.String]
    $HelpSourceFolder = (property HelpSourceFolder 'docs'),

    [Parameter()]
    [System.String]
    $OutputDirectory = (property OutputDirectory 'output'),

    [Parameter()]
    [System.String]
    $BuiltModuleSubdirectory = (property BuiltModuleSubdirectory ''),

    [Parameter()]
    [System.Management.Automation.SwitchParameter]
    $VersionedOutputDirectory = (property VersionedOutputDirectory $true),

    [Parameter()]
    [System.String]
    $HelpOutputFolder = (property HelpOutputFolder 'help'),

    [Parameter()]
    [cultureInfo]
    $HelpCultureInfo = 'en-US',

    [Parameter()]
    [System.Management.Automation.SwitchParameter]
    $CopyHelpMamlToBuiltModuleBase = (property CopyHelpMamlToBuiltModuleBase $true),

    # Build Configuration object
    [Parameter()]
    [System.Collections.Hashtable]
    $BuildInfo = (property BuildInfo @{ })
)

function Get-GenerateHelpPSVariables
{
    param ()

    $script:PesterOutputFolder = Get-SamplerAbsolutePath -Path $PesterOutputFolder -RelativeTo $OutputDirectory

    "`tPester Output Folder       = '$PesterOutputFolder"

    $script:HelpSourceFolder = Get-SamplerAbsolutePath -Path $HelpSourceFolder -RelativeTo $ProjectPath
    "`tHelp Source Folder         = '$HelpSourceFolder'"

    $script:HelpOutputFolder =  Get-SamplerAbsolutePath -Path $HelpOutputFolder -RelativeTo $OutputDirectory
    "`tHelp output Folder         = '$HelpOutputFolder'"

    if ($ModuleVersion)
    {
        $script:HelpOutputVersionFolder = Get-SamplerAbsolutePath -Path $ModuleVersion -RelativeTo $HelpOutputFolder
    }

    "`tHelp output Version Folder = '$HelpOutputVersionFolder'"

    $script:HelpOutputCultureFolder = Get-SamplerAbsolutePath -Path $HelpCultureInfo -RelativeTo $HelpOutputVersionFolder
    "`tHelp output Culture path   = '$HelpOutputCultureFolder'"

    $script:DocOutputFolder = Get-SamplerAbsolutePath -Path 'docs' -RelativeTo $OutputDirectory
    "`tDocs output folder path    = '$DocOutputFolder'"
}

# Synopsis: Produces markdown help files from the built module.
task Generate_help_from_built_module {
    . Set-SamplerTaskVariable

    Get-GenerateHelpPSVariables

    $generateHelpCommands = @"
    `$env:PSModulePath = '$Env:PSModulePath'
    `$targetModule = Import-Module -Name '$ProjectName' -ErrorAction Stop -Passthru

    `$helpDestination = Join-Path '$HelpSourceFolder' -ChildPath '$HelpCultureInfo'

    if (!(Test-Path -Path `$helpDestination)) {
        New-Item -Path `$helpDestination -ItemType Directory -Force -ErrorAction Ignore | Out-Null
    }

    `$docOutputFolder = Join-Path '$DocOutputFolder' -ChildPath '$ProjectName'

    `$commandsArray = @()
    foreach (`$publicFunction in `$targetModule.ExportedFunctions.Keys) {
        `$command = Get-Command -Name `$publicFunction -Module `$targetModule

        `$newMarkdownCommandHelpParams = @{
            CommandInfo  = `$command
            OutputFolder = '$DocOutputFolder'
            HelpVersion  = `$targetModule.Version
            Locale       = '$HelpCultureInfo'
            Encoding     = 'utf8'
            Force        = `$true
        }
        `$Output = New-MarkdownCommandHelp @newMarkdownCommandHelpParams

        `$helpCommand = Import-MarkdownCommandHelp -Path `$Output -ErrorAction Ignore

        # Add the command to the array
        `$commandsArray += `$helpCommand

        `$alias = Get-Alias -Definition `$command.Name -ErrorAction Ignore

        if (`$alias) {
            `$helpCommand.Aliases = @(`$alias.Name)
        } else {
            `$helpCommand.Aliases = @()
        }

        `$helpCommand | Export-MarkdownCommandHelp -OutputFolder '$DocOutputFolder' -Force

        Copy-Item -Path `$Output -Destination `$helpDestination -Force
    }

    `$newMarkdownModuleFileParams = @{
        CommandHelp  = `$commandsArray
        OutputFolder = '$DocOutputFolder'
        Force        = `$true
    }
    `$markdownFile = New-MarkdownModuleFile @newMarkdownModuleFileParams

    if (`$markdownFile) {
        Copy-Item -Path `$markdownFile -Destination `$helpDestination -Force
    }

"@
    Write-Build -Color DarkGray -Text "$generateHelpCommands"
    $sb = [ScriptBlock]::create($generateHelpCommands)

    $pwshPath = (Get-Process -Id $PID).Path
    &$pwshPath -Command $sb -ExecutionPolicy 'ByPass'
}
