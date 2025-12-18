#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'New-FabricSparkCustomPool'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "New-FabricSparkCustomPool" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name New-FabricSparkCustomPool
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'SparkCustomPoolName'; Mandatory = $true }
            @{ Name = 'NodeFamily'; Mandatory = $true }
            @{ Name = 'NodeSize'; Mandatory = $true }
            @{ Name = 'AutoScaleEnabled'; Mandatory = $true }
            @{ Name = 'AutoScaleMinNodeCount'; Mandatory = $true }
            @{ Name = 'AutoScaleMaxNodeCount'; Mandatory = $true }
            @{ Name = 'DynamicExecutorAllocationEnabled'; Mandatory = $true }
            @{ Name = 'DynamicExecutorAllocationMinExecutors'; Mandatory = $true }
            @{ Name = 'DynamicExecutorAllocationMaxExecutors'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'When creating Spark custom pool successfully (201)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 201
                }
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    name = 'NewPool'
                    nodeFamily = 'MemoryOptimized'
                    nodeSize = 'Small'
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()

            New-FabricSparkCustomPool -WorkspaceId $mockWorkspaceId -SparkCustomPoolName 'NewPool' -NodeFamily 'MemoryOptimized' -NodeSize 'Small' -AutoScaleEnabled $true -AutoScaleMinNodeCount 1 -AutoScaleMaxNodeCount 10 -DynamicExecutorAllocationEnabled $true -DynamicExecutorAllocationMinExecutors 1 -DynamicExecutorAllocationMaxExecutors 5 -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/spark/pools*" -and
                $Method -eq 'Post'
            }
        }

        It 'Should return the created pool' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = New-FabricSparkCustomPool -WorkspaceId $mockWorkspaceId -SparkCustomPoolName 'NewPool' -NodeFamily 'MemoryOptimized' -NodeSize 'Small' -AutoScaleEnabled $true -AutoScaleMinNodeCount 1 -AutoScaleMaxNodeCount 10 -DynamicExecutorAllocationEnabled $true -DynamicExecutorAllocationMinExecutors 1 -DynamicExecutorAllocationMaxExecutors 5 -Confirm:$false

            $result.name | Should -Be 'NewPool'
        }
    }

    Context 'When an unexpected status code is returned' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 400
                }
                return [pscustomobject]@{
                    message = 'Bad Request'
                    errorCode = 'InvalidRequest'
                }
            }
        }

        It 'Should write an error message for unexpected status codes' {
            $mockWorkspaceId = [guid]::NewGuid()

            New-FabricSparkCustomPool -WorkspaceId $mockWorkspaceId -SparkCustomPoolName 'NewPool' -NodeFamily 'MemoryOptimized' -NodeSize 'Small' -AutoScaleEnabled $true -AutoScaleMinNodeCount 1 -AutoScaleMaxNodeCount 10 -DynamicExecutorAllocationEnabled $true -DynamicExecutorAllocationMinExecutors 1 -DynamicExecutorAllocationMaxExecutors 5 -Confirm:$false

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }

    Context 'When an exception is thrown' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw 'API connection failed'
            }
        }

        It 'Should handle exceptions gracefully' {
            $mockWorkspaceId = [guid]::NewGuid()

            { New-FabricSparkCustomPool -WorkspaceId $mockWorkspaceId -SparkCustomPoolName 'NewPool' -NodeFamily 'MemoryOptimized' -NodeSize 'Small' -AutoScaleEnabled $true -AutoScaleMinNodeCount 1 -AutoScaleMaxNodeCount 10 -DynamicExecutorAllocationEnabled $true -DynamicExecutorAllocationMinExecutors 1 -DynamicExecutorAllocationMaxExecutors 5 -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to create SparkCustomPool*"
            }
        }
    }
}
