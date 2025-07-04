$PSVersionTable

Import-module PSScriptAnalyzer

Find-Module Microsoft.PowerShell.PSResourceGet
.\build.ps1 -ResolveDependency -Tasks noop -UsePSResourceGet


######### BUILD #########

./build.ps1 -ResolveDependency -Tasks noop

Remove-Module -Name FabricTools -ErrorAction SilentlyContinue
./build.ps1 -Tasks build
ipmo .\output\module\FabricTools\0.0.1\FabricTools.psd1
Get-Module Fab*

Invoke-ScriptAnalyzer -Path .\source\Public\**


$tests = Invoke-Pester .\tests\ -PassThru
$tests.Tests | where Result -eq 'Failed' | Measure-Object | Select-Object -ExpandProperty Count
$tests.Tests | where Result -eq 'Failed' | ft -Property ExpandedName, ErrorRecord
$tests.Tests | where Result -eq 'Failed' | ft -Property Name, Result, ErrorRecord -AutoSize

$e = $tests.Tests | where Result -eq 'Failed' | Select-Object -First 1
$e.ErrorRecord
