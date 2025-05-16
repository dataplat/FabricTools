#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}
param(
    $ModuleName = "FabricTools",
    $expectedParams = @(
        "WorkspaceId"
                "MirroredDatabaseId"
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

Describe "Remove-FabricMirroredDatabase" -Tag "UnitTests" {

    BeforeDiscovery {
        $command = Get-Command -Name Remove-FabricMirroredDatabase
        $expected = $expectedParams
    }

    Context "Parameter validation" {
        BeforeAll {
            $command = Get-Command -Name Remove-FabricMirroredDatabase
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
}

