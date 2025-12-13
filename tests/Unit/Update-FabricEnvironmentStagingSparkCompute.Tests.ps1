#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Update-FabricEnvironmentStagingSparkCompute'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Update-FabricEnvironmentStagingSparkCompute
}

Describe "Update-FabricEnvironmentStagingSparkCompute" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'EnvironmentId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'InstancePoolName'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'InstancePoolType'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'DriverCores'; ExpectedParameterType = 'int'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'DriverMemory'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'ExecutorCores'; ExpectedParameterType = 'int'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'ExecutorMemory'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'DynamicExecutorAllocationEnabled'; ExpectedParameterType = 'bool'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'DynamicExecutorAllocationMinExecutors'; ExpectedParameterType = 'int'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'DynamicExecutorAllocationMaxExecutors'; ExpectedParameterType = 'int'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'RuntimeVersion'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'SparkProperties'; ExpectedParameterType = 'Object'; Mandatory = 'True' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Successful environment staging spark compute update" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return $null
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should update environment staging spark compute with valid parameters' {
            { Update-FabricEnvironmentStagingSparkCompute `
                -WorkspaceId (New-Guid) `
                -EnvironmentId (New-Guid) `
                -InstancePoolName 'TestPool' `
                -InstancePoolType 'Workspace' `
                -DriverCores 4 `
                -DriverMemory '16GB' `
                -ExecutorCores 8 `
                -ExecutorMemory '32GB' `
                -DynamicExecutorAllocationEnabled $true `
                -DynamicExecutorAllocationMinExecutors 2 `
                -DynamicExecutorAllocationMaxExecutors 10 `
                -RuntimeVersion '3.1' `
                -SparkProperties @{ 'spark.executor.memoryOverhead' = '4GB' } `
                -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 400
                }
                throw "API Error"
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should handle errors gracefully and write error message' {
            { Update-FabricEnvironmentStagingSparkCompute `
                -WorkspaceId (New-Guid) `
                -EnvironmentId (New-Guid) `
                -InstancePoolName 'TestPool' `
                -InstancePoolType 'Workspace' `
                -DriverCores 4 `
                -DriverMemory '16GB' `
                -ExecutorCores 8 `
                -ExecutorMemory '32GB' `
                -DynamicExecutorAllocationEnabled $true `
                -DynamicExecutorAllocationMinExecutors 2 `
                -DynamicExecutorAllocationMaxExecutors 10 `
                -RuntimeVersion '3.1' `
                -SparkProperties @{ 'spark.executor.memoryOverhead' = '4GB' } `
                -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            } -Times 1 -Exactly
        }
    }
}
