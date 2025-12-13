#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Update-FabricSparkCustomPool'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Update-FabricSparkCustomPool
}

Describe "Update-FabricSparkCustomPool" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'SparkCustomPoolId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'InstancePoolName'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'NodeFamily'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'NodeSize'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'AutoScaleEnabled'; ExpectedParameterType = 'bool'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'AutoScaleMinNodeCount'; ExpectedParameterType = 'int'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'AutoScaleMaxNodeCount'; ExpectedParameterType = 'int'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'DynamicExecutorAllocationEnabled'; ExpectedParameterType = 'bool'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'DynamicExecutorAllocationMinExecutors'; ExpectedParameterType = 'int'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'DynamicExecutorAllocationMaxExecutors'; ExpectedParameterType = 'int'; Mandatory = 'True' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Successful Spark Custom Pool update" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return $null
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should update Spark Custom Pool with valid parameters' {
            { Update-FabricSparkCustomPool -WorkspaceId (New-Guid) -SparkCustomPoolId (New-Guid) -InstancePoolName 'TestPool' -NodeFamily 'MemoryOptimized' -NodeSize 'Small' -AutoScaleEnabled $true -AutoScaleMinNodeCount 1 -AutoScaleMaxNodeCount 10 -DynamicExecutorAllocationEnabled $true -DynamicExecutorAllocationMinExecutors 1 -DynamicExecutorAllocationMaxExecutors 5 -Confirm:$false } | Should -Not -Throw

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

        It 'Should handle error when API call fails' {
            {
                Update-FabricSparkCustomPool -WorkspaceId (New-Guid) -SparkCustomPoolId (New-Guid) -InstancePoolName 'TestPool' -NodeFamily 'MemoryOptimized' -NodeSize 'Small' -AutoScaleEnabled $true -AutoScaleMinNodeCount 1 -AutoScaleMaxNodeCount 10 -DynamicExecutorAllocationEnabled $true -DynamicExecutorAllocationMinExecutors 1 -DynamicExecutorAllocationMaxExecutors 5 -Confirm:$false
            } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Error' } -Times 1 -Exactly -Scope It
        }
    }
}
