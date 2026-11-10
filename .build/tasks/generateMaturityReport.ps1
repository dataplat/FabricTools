param
(
    [Parameter()]
    [System.IO.DirectoryInfo]
    $ProjectPath = (property ProjectPath $BuildRoot)
)

# Synopsis: Writes docs/MATURITY.md with the maturity level of every public cmdlet (see docs/maturity-model.md).
task generate_maturity_report {
    $maturityParams = @{
        PublicPath          = Join-Path -Path $ProjectPath -ChildPath 'src/Public'
        UnitTestPath        = Join-Path -Path $ProjectPath -ChildPath 'tests/Unit'
        IntegrationTestPath = Join-Path -Path $ProjectPath -ChildPath 'tests/Integration'
        ManifestPath        = Join-Path -Path $ProjectPath -ChildPath '.build/Maturity.psd1'
    }
    $results = @(Get-CommandMaturity @maturityParams)

    $reportPath = Join-Path -Path $ProjectPath -ChildPath 'docs/MATURITY.md'
    ConvertTo-MaturityReport -Result $results | Set-Content -Path $reportPath -Encoding UTF8

    Write-Build Green "MATURITY.md written to: $reportPath ($($results.Count) commands)"
    foreach ($group in $results | Group-Object -Property Level | Sort-Object -Property { [int] $_.Name })
    {
        Write-Build DarkGray ("`t{0} {1,-20} {2,4}" -f $group.Name, $group.Group[0].LevelName, $group.Count)
    }
}
