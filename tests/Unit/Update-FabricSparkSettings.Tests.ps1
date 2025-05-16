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
    )
)

Describe "Update-FabricSparkSettings" -Tag "UnitTests" {
    Context "Parameter validation" {
        BeforeAll {
            $command = Get-Command Update-FabricSparkSettings
            $expected = $CommonParameters
            $expected += @(
                "WorkspaceId"
                "automaticLogEnabled"
                "notebookInteractiveRunEnabled"
                "customizeComputeEnabled"
                "defaultPoolName"
                "defaultPoolType"
                "starterPoolMaxNode"
                "starterPoolMaxExecutors"
                "EnvironmentName"
                "EnvironmentRuntimeVersion"
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

        It "Has parameter: <_>" -ForEach $expected {
            $command | Should -HaveParameter $PSItem
        }

        It "Should have exactly the number of expected parameters ($($expected.Count))" {
            $hasparms = $command.Parameters.Values.Name
            Compare-Object -ReferenceObject $expected -DifferenceObject $hasparms | Should -BeNullOrEmpty
        }
    }
}
