#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}
param(
    $ModuleName = "FabricTools",
    $expectedParams = @(
        "WorkspaceId"
                "WorkspaceName"
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

Describe "Get-FabricWorkspace" -Tag "UnitTests" {

    BeforeDiscovery {
        $command = Get-Command -Name Get-FabricWorkspace
        $expected = $expectedParams
    }

    Context "Parameter validation" {
        BeforeAll {
            $command = Get-Command -Name Get-FabricWorkspace
            $expected = $expectedParams
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

    Context "WorkspaceName parameter validation" {
        It "Throws error when WorkspaceName does not match ValidatePattern" {
            # Assuming the ValidatePattern allows only alphanumeric, underscore, space and hyphen
            { Get-FabricWorkspace -WorkspaceName "InvalidName!" } | Should -Throw
            { Get-FabricWorkspace -WorkspaceName "Another@Invalid" } | Should -Throw
        }

        It "Does not throw when WorkspaceName matches ValidatePattern" {
            { Get-FabricWorkspace -WorkspaceName "Valid_Name-123" } | Should -Not -Throw
            { Get-FabricWorkspace -WorkspaceName "Another Valid Name" } | Should -Not -Throw
        }
    }
}
