#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}
param(
    $ModuleName = "FabricTools",
    $PSDefaultParameterValues = ($TestConfig = Get-TestConfig).Defaults
)

Describe "Update-FabricSparkCustomPool" -Tag "UnitTests" {
    Context "Parameter validation" {
        BeforeAll {
            $command = Get-Command Update-FabricSparkCustomPool
            $expected = $TestConfig.CommonParameters
            $expected += @(
                "WorkspaceId"
                "SparkCustomPoolId"
                "InstancePoolName"
                "NodeFamily"
                "NodeSize"
                "AutoScaleEnabled"
                "AutoScaleMinNodeCount"
                "AutoScaleMaxNodeCount"
                "DynamicExecutorAllocationEnabled"
                "DynamicExecutorAllocationMinExecutors"
                "DynamicExecutorAllocationMaxExecutors"
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

