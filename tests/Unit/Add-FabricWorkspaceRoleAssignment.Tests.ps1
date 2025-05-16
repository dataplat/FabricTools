#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}
param(
    $ModuleName = "FabricTools",
    $PSDefaultParameterValues = ($TestConfig = Get-TestConfig).Defaults
)

Describe "Add-FabricWorkspaceRoleAssignment" -Tag "UnitTests" {

    BeforeDiscovery {
        $expected = $TestConfig.CommonParameters
        $expected += @(
            "WorkspaceId"
            "PrincipalId"
            "PrincipalType"
            "WorkspaceRole"
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
    }
    BeforeAll {
        $command = Get-Command -Name Add-FabricWorkspaceRoleAssignment
               $expected = $TestConfig.CommonParameters
        $expected += @(
            "WorkspaceId"
            "PrincipalId"
            "PrincipalType"
            "WorkspaceRole"
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
    }
    Context "Parameter validation" {

        It "Has parameter: <_>" -ForEach $expected {
            $command | Should -HaveParameter $PSItem
        }

        It "Should have exactly the number of expected parameters ($($expected.Count))" {
            $hasparms = $command.Parameters.Values.Name
            Compare-Object -ReferenceObject $expected -DifferenceObject $hasparms | Should -BeNullOrEmpty
        }
    }
}
