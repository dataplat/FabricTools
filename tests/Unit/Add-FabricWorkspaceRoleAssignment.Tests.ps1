#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}
param(
    $ModuleName = "FabricTools",
    $PSDefaultParameterValues = ($TestConfig = Get-TestConfig).Defaults,
    $expectedParams = @(
        "WorkspaceId"
        "PrincipalId"
        "PrincipalType"
        "WorkspaceRole"
    )
)

Describe "Add-FabricWorkspaceRoleAssignment" -Tag "UnitTests" {

    BeforeDiscovery {
        $command = Get-Command -Name Add-FabricWorkspaceRoleAssignment
        $expected = $TestConfig.CommonParameters
        $expected += $expectedParams
    }

    Context "Parameter validation" {
        BeforeAll {
            $command = Get-Command -Name Add-FabricWorkspaceRoleAssignment
            $expected = $TestConfig.CommonParameters
            $expected += $expectedParams
        }

        It "Has parameter: <_>" -ForEach $expected {
            $command | Should -HaveParameter $PSItem
        }

        It "Should have exactly the number of expected parameters $($expected.Count)" {
            $hasparms = $command.Parameters.Values.Name
            #$hasparms.Count | Should -BeExactly $expected.Count
            Compare-Object -ReferenceObject $expected -DifferenceObject $hasparms | Should -BeNullOrEmpty
        }
    }
}
