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

            $command = Get-Command -Name Get-FabricContinuationToken
            $script:fabricTokenParams = $expectedParams
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
                Compare-Object -ReferenceObject $script:fabricTokenParams -DifferenceObject $hasParams | Should -BeNullOrEmpty
            }
        }
    }
}
