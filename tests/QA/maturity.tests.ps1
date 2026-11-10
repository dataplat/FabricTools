BeforeAll {
    $projectPath = "$($PSScriptRoot)\..\.." | Convert-Path
    . (Join-Path -Path $projectPath -ChildPath '.build/helpers/Get-CommandMaturity.ps1')
    . (Join-Path -Path $projectPath -ChildPath '.build/helpers/ConvertTo-MaturityReport.ps1')

    $script:publicPath = Join-Path -Path $TestDrive -ChildPath 'src/Public'
    $script:unitPath = Join-Path -Path $TestDrive -ChildPath 'tests/Unit'
    $script:integrationPath = Join-Path -Path $TestDrive -ChildPath 'tests/Integration'
    $script:manifestPath = Join-Path -Path $TestDrive -ChildPath 'Maturity.psd1'

    function New-Fixture
    {
        param ([string] $Path, [string] $Content)
        $null = New-Item -Path (Split-Path -Path $Path -Parent) -ItemType Directory -Force
        Set-Content -Path $Path -Value $Content -Encoding UTF8
    }

    function New-FixtureCmdlet
    {
        # A cmdlet that meets level 2, with optional tweaks to break single checks.
        param (
            [string] $Name,
            [string] $Folder = 'Lakehouse',
            [string] $Binding = '[CmdletBinding()]',
            [string] $Call = '$apiParams = @{ Uri = "items"; Method = "Get"; HandleResponse = $true }
        Invoke-FabricRestMethod @apiParams'
        )
        $content = @"
function $Name {
    <#
    .SYNOPSIS
        Does a thing.
    .DESCRIPTION
        Does a thing in detail.
    .PARAMETER WorkspaceId
        The workspace.
    .EXAMPLE
        $Name -WorkspaceId 'x'
    #>
    $Binding
    param (
        [guid]`$WorkspaceId
    )
    $Call
}
"@
        New-Fixture -Path (Join-Path -Path $script:publicPath -ChildPath "$Folder/$Name.ps1") -Content $content
    }

    function New-FixtureUnitTest
    {
        param ([string] $Name, [string] $Body = "Mock Invoke-FabricRestMethod { }`n$Name -WorkspaceId (New-Guid)")
        New-Fixture -Path (Join-Path -Path $script:unitPath -ChildPath "$Name.Tests.ps1") -Content $Body
    }

    # Level 4: standardized, unit tested, integration tested
    New-FixtureCmdlet -Name 'Get-FabricLevelFour'
    New-FixtureUnitTest -Name 'Get-FabricLevelFour'

    # Level 3, listed as Production Ready although it is not integration tested
    New-FixtureCmdlet -Name 'Get-FabricLevelThree'
    New-FixtureUnitTest -Name 'Get-FabricLevelThree'

    # Level 1: not an advanced function
    New-FixtureCmdlet -Name 'Get-FabricNoBinding' -Binding ''
    New-FixtureUnitTest -Name 'Get-FabricNoBinding'

    # One splatted hashtable reused by two calls: passes HandleResponse
    New-FixtureCmdlet -Name 'Get-FabricReusedSplat' -Call @'
$apiParams = @{ Method = 'Get'; HandleResponse = $true }
    $apiParams.Uri = 'a'
    Invoke-FabricRestMethod @apiParams
    $apiParams.Uri = 'b'
    Invoke-FabricRestMethod @apiParams
'@

    # Second call without HandleResponse: fails it
    New-FixtureCmdlet -Name 'Get-FabricMissingHandleResponse' -Call @'
$apiParams = @{ Uri = 'a'; Method = 'Get'; HandleResponse = $true }
    Invoke-FabricRestMethod @apiParams
    Invoke-FabricRestMethod -Uri 'b' -Method Get
'@

    # Direct REST call, exempted in the manifest
    New-FixtureCmdlet -Name 'Invoke-FabricRawCall' -Call 'Invoke-RestMethod -Uri "https://example"'

    # State-changing verb without SupportsShouldProcess
    New-FixtureCmdlet -Name 'Remove-FabricThing'

    # Backtick continuation
    New-FixtureCmdlet -Name 'Get-FabricBacktick' -Call @'
Invoke-FabricRestMethod -Uri 'a' `
        -HandleResponse
'@

    # Unit test that only inspects the command
    New-FixtureCmdlet -Name 'Get-FabricShallowTest'
    New-FixtureUnitTest -Name 'Get-FabricShallowTest' -Body "`$command = Get-Command -Name Get-FabricShallowTest"

    # Experimental, although it would score level 3
    New-FixtureCmdlet -Name 'Get-FabricPreview'
    New-FixtureUnitTest -Name 'Get-FabricPreview'

    # The same function in two files
    New-FixtureCmdlet -Name 'Get-FabricDuplicate'
    New-Fixture -Path (Join-Path -Path $script:publicPath -ChildPath 'Lakehouse/Get-FabricOtherName.ps1') -Content (
        Get-Content -Path (Join-Path -Path $script:publicPath -ChildPath 'Lakehouse/Get-FabricDuplicate.ps1') -Raw)

    New-Fixture -Path (Join-Path -Path $script:integrationPath -ChildPath 'Scenario.Integration.Tests.ps1') -Content @'
Describe 'Scenario' { It 'works' { Get-FabricLevelFour -WorkspaceId (New-Guid) } }
'@

    New-Fixture -Path $script:manifestPath -Content @'
@{
    Experimental    = @{ 'Get-FabricPreview' = 'Preview API' }
    ProductionReady = @{ 'Get-FabricLevelFour' = 'Approved'; 'Get-FabricLevelThree' = 'Approved' }
    Exemptions      = @{ 'Invoke-FabricRawCall' = @('UsesFabricRestMethod') }
}
'@

    $maturityParams = @{
        PublicPath          = $script:publicPath
        UnitTestPath        = $script:unitPath
        IntegrationTestPath = $script:integrationPath
        ManifestPath        = $script:manifestPath
    }
    $script:results = @(Get-CommandMaturity @maturityParams)
    $script:byName = @{}
    foreach ($item in $script:results) { $script:byName[$item.Name] = $item }
}

Describe 'Get-CommandMaturity' -Tag 'Maturity' {
    It 'Lifts a level 4 cmdlet listed as ProductionReady to level 5' {
        $byName['Get-FabricLevelFour'].ComputedLevel | Should -Be 4
        $byName['Get-FabricLevelFour'].Level | Should -Be 5
        $byName['Get-FabricLevelFour'].LevelName | Should -Be 'Production Ready'
        $byName['Get-FabricLevelFour'].ItemType | Should -Be 'Lakehouse'
    }

    It 'Does not lift a cmdlet below level 4 and flags the unsupported claim' {
        $byName['Get-FabricLevelThree'].Level | Should -Be 3
        $byName['Get-FabricLevelThree'].MissingForNext | Should -Be @('HasIntegrationTest')
        $byName['Get-FabricLevelThree'].Note | Should -Match 'does not meet level 4'
    }

    It 'Stops at level 1 when a level 2 check fails, even with a unit test' {
        $byName['Get-FabricNoBinding'].Level | Should -Be 1
        $byName['Get-FabricNoBinding'].MissingForNext | Should -Be @('HasCmdletBinding')
    }

    It 'Accepts one splatted hashtable that sets HandleResponse and is reused by several calls' {
        $byName['Get-FabricReusedSplat'].Checks.HandleResponse | Should -BeTrue
    }

    It 'Fails HandleResponse when any call does not set it' {
        $byName['Get-FabricMissingHandleResponse'].Checks.HandleResponse | Should -BeFalse
    }

    It 'Treats an exempted check as passed' {
        $byName['Invoke-FabricRawCall'].Checks.UsesFabricRestMethod | Should -BeTrue
    }

    It 'Requires SupportsShouldProcess for state-changing verbs only' {
        $byName['Remove-FabricThing'].Checks.SupportsShouldProcess | Should -BeFalse
        $byName['Get-FabricLevelFour'].Checks.SupportsShouldProcess | Should -BeTrue
    }

    It 'Detects backtick line continuation' {
        $byName['Get-FabricBacktick'].Checks.NoBacktickContinuation | Should -BeFalse
        $byName['Get-FabricBacktick'].Checks.HandleResponse | Should -BeTrue
    }

    It 'Does not count a unit test that only inspects the command' {
        $byName['Get-FabricShallowTest'].Checks.HasUnitTest | Should -BeTrue
        $byName['Get-FabricShallowTest'].Checks.UnitTestExercisesCmdlet | Should -BeFalse
        $byName['Get-FabricShallowTest'].Level | Should -Be 2
    }

    It 'Forces an Experimental cmdlet to level 0' {
        $byName['Get-FabricPreview'].ComputedLevel | Should -Be 3
        $byName['Get-FabricPreview'].Level | Should -Be 0
        $byName['Get-FabricPreview'].Note | Should -Match 'Preview API'
    }

    It 'Flags a function defined in more than one file' {
        $duplicates = @($results | Where-Object Name -eq 'Get-FabricDuplicate')
        $duplicates.Count | Should -Be 2
        $duplicates | ForEach-Object { $_.Note | Should -Match 'more than one file' }
    }
}

Describe 'ConvertTo-MaturityReport' -Tag 'Maturity' {
    BeforeAll {
        $script:report = ($results | ConvertTo-MaturityReport) -join "`n"
    }

    It 'Summarises the number of cmdlets per level' {
        $report | Should -Match '\| 5 \| Production Ready \| 1 \|'
        $report | Should -Match "\*\*Total\*\* \| \*\*$($results.Count)\*\*"
    }

    It 'Lists each cmdlet under its item type with the checks it is missing' {
        $report | Should -Match '## Lakehouse'
        $report | Should -Match '\| Get-FabricNoBinding \| 1 Prototype \| `HasCmdletBinding` \|'
    }
}

Describe 'Maturity manifest' -Tag 'Maturity' {
    BeforeDiscovery {
        $projectPath = "$($PSScriptRoot)\..\.." | Convert-Path
        $manifest = Import-PowerShellDataFile -Path (Join-Path -Path $projectPath -ChildPath '.build/Maturity.psd1')
        $entryCases = foreach ($section in 'Experimental', 'ProductionReady', 'Exemptions')
        {
            foreach ($name in @($manifest[$section].Keys)) { @{ Section = $section; Name = $name } }
        }
    }

    BeforeAll {
        $projectPath = "$($PSScriptRoot)\..\.." | Convert-Path
        . (Join-Path -Path $projectPath -ChildPath '.build/helpers/Get-CommandItemTypeMap.ps1')
        $script:publicFunctions = Get-CommandItemTypeMap -PublicPath (Join-Path -Path $projectPath -ChildPath 'src/Public')
    }

    It '<Section> entry <Name> is a public function' -TestCases $entryCases {
        $publicFunctions.ContainsKey($Name) | Should -BeTrue -Because 'manifest entries must name a function in src/Public'
    }
}
