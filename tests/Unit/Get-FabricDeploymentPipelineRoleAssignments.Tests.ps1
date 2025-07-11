#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}
param(
    $ModuleName = "FabricTools",
    $expectedParams = @(
        "DeploymentPipelineId"
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

Describe "Get-FabricDeploymentPipelineRoleAssignments" -Tag "UnitTests" {

    BeforeDiscovery {
        $command = Get-Command -Name Get-FabricDeploymentPipelineRoleAssignments
        $expected = $expectedParams
    }

    Context "Parameter validation" {
        BeforeAll {
            $command = Get-Command -Name Get-FabricDeploymentPipelineRoleAssignments
            $expected = $expectedParams
        }

        It "Has parameter: <_>" -ForEach $expected {
            $command | Should -HaveParameter $PSItem
        }

        It "Should have exactly the number of expected parameters $($expected.Count)" {
            $hasParams = $command.Parameters.Values.Name
            Compare-Object -ReferenceObject $expected -DifferenceObject $hasParams | Should -BeNullOrEmpty
        }
    }
}
