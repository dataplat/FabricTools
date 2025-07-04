#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

InModuleScope FabricTools {

param(
    $ModuleName = "FabricTools",
    $expectedParams = @(
        "Response"
        "Verbose"
        "Debug"
        "ErrorAction"
        "WarningAction"
        "InformationAction"
        "ProgressAction"
        "ErrorVariable"
        "WarningVariable"
        "InformationVariable"
        "OutVariable"
        "OutBuffer"
        "PipelineVariable"
    )
)

Describe "Get-FabricContinuationToken" -Tag "UnitTests" {

    BeforeDiscovery {
        ipmo ".\output\module\FabricTools\0.0.1\FabricTools.psd1"

        $command = Get-Command -Name Get-FabricContinuationToken
        $script:expected = $expectedParams
    }

    Context "Parameter validation" {
        BeforeAll {
            $command = Get-Command -Name Get-FabricContinuationToken
            $expected = $expectedParams
        }

        It "Has parameter: <_>" -ForEach $expected {
            $command | Should -HaveParameter $PSItem
        }

        It "Should have exactly the number of expected parameters $($expected.Count)" {
            $hasParams = $command.Parameters.Values.Name
            Compare-Object -ReferenceObject $script:expected -DifferenceObject $hasParams | Should -BeNullOrEmpty
        }
    }
}

}
