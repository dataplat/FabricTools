#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}
param(
    $ModuleName = "FabricTools",
    $CommonParameters = @(
        "Verbose"
        "Debug"
        "ErrorAction"
        "WarningAction"
        "InformationAction"
        "ErrorVariable"
        "WarningVariable"
        "InformationVariable"
        "OutVariable"
        "OutBuffer"
    ),
    $expectedParams = @(
        "WorkspaceId"
        "PrincipalId"
        "PrincipalType"
        "WorkspaceRole"
        "Jess'sMissingParam"
    )
)

Describe "Add-FabricWorkspaceRoleAssignment" -Tag "UnitTests" {

    BeforeDiscovery {
        $command = Get-Command -Name Add-FabricWorkspaceRoleAssignment
        $expected = $CommonParameters
        $expected += $expectedParams
    }

    Context "Parameter validation" {
        BeforeAll {
            $command = Get-Command -Name Add-FabricWorkspaceRoleAssignment
            $expected = $CommonParameters
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
