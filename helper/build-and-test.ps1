$PSVersionTable

Import-module PSScriptAnalyzer

Find-Module Microsoft.PowerShell.PSResourceGet
.\build.ps1 -ResolveDependency -Tasks noop -UsePSResourceGet


######### BUILD #########

./build.ps1 -ResolveDependency -Tasks noop

Remove-Module -Name FabricTools -ErrorAction SilentlyContinue
./build.ps1 -Tasks build
Import-Module .\output\module\FabricTools\0.0.1\FabricTools.psd1
Get-Module Fab*

# Invoke-ScriptAnalyzer -Path .\src\Public\**

## Unit Tests
#$tests = Invoke-Pester .\tests\ -Tag UnitTests -PassThru
$tests = Invoke-Pester .\tests\Unit\ -PassThru
$tests.Tests | where Result -eq 'Failed' | Measure-Object | Select-Object -ExpandProperty Count
$tests.Tests | where Result -eq 'Failed' | ft -Property ExpandedName, ErrorRecord
$tests.Tests | where Result -eq 'Failed' | ft -Property Path, Result, ErrorRecord -AutoSize

$e = $tests.Tests | where Result -eq 'Failed' | Select-Object -Last 1
$e.ErrorRecord

## QA
$tests = Invoke-Pester .\tests\QA -PassThru
$tests.Tests | where Result -eq 'Failed' | ft -Property ExpandedName, ErrorRecord


## Integration Tests
Connect-FabricAccount -Debug
$tests = Invoke-Pester .\tests\Integration -PassThru
$tests.Tests | where Result -eq 'Failed' | ft -Property Path, Result, ErrorRecord -AutoSize



Invoke-Pester .\tests\Integration\Notebook* -PassThru


Get-FabricDataset
Get-FabricDataset -DatasetName 'sampledwh'
Get-FabricDataset -GroupId '653b4281-c1d1-4307-a8c9-cc18c0b0b8ff'

Get-FabricDataset -DatasetName 'sampledwh' | Get-FabricDatasetRefreshHistory
Get-FabricDatasetRefreshHistory -DatasetId e1483950-dce9-414c-be60-8d4e66c37e2e

Get-FabricWorkspace -WorkspaceId '653b4281-c1d1-4307-a8c9-cc18c0b0b8ff'
