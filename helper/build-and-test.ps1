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


$tests = Invoke-Pester .\tests\ -Tag UnitTests -PassThru
$tests.Tests | where Result -eq 'Failed' | Measure-Object | Select-Object -ExpandProperty Count
$tests.Tests | where Result -eq 'Failed' | ft -Property ExpandedName, ErrorRecord
$tests.Tests | where Result -eq 'Failed' | ft -Property Path, Result, ErrorRecord -AutoSize

$e = $tests.Tests | where Result -eq 'Failed' | Select-Object -Last 1
$e.ErrorRecord


## Integration Tests
Connect-FabricAccount -Debug
$tests = Invoke-Pester .\tests\Integration -PassThru
$tests.Tests | where Result -eq 'Failed' | ft -Property Path, Result, ErrorRecord -AutoSize



Invoke-Pester .\tests\Integration\Notebook* -PassThru
