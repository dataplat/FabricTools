#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Remove-FabricWarehouse'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Remove-FabricWarehouse" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Remove-FabricWarehouse
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'WarehouseId'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'When removing warehouse successfully (200)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return $null
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockWarehouseId = [guid]::NewGuid()

            Remove-FabricWarehouse -WorkspaceId $mockWorkspaceId -WarehouseId $mockWarehouseId -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/warehouses/*" -and
                $Method -eq 'Delete'
            }
        }

        It 'Should complete without error' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockWarehouseId = [guid]::NewGuid()

            { Remove-FabricWarehouse -WorkspaceId $mockWorkspaceId -WarehouseId $mockWarehouseId -Confirm:$false } | Should -Not -Throw
        }
    }

    Context 'When an unexpected status code is returned' -Skip {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 404
                }
                return [pscustomobject]@{
                    message = 'Not Found'
                    errorCode = 'WarehouseNotFound'
                }
            }
        }

        It 'Should write an error message for unexpected status codes' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockWarehouseId = [guid]::NewGuid()

            Remove-FabricWarehouse -WorkspaceId $mockWorkspaceId -WarehouseId $mockWarehouseId -Confirm:$false

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
            $mockWarehouseId = [guid]::NewGuid()

            { Remove-FabricWarehouse -WorkspaceId $mockWorkspaceId -WarehouseId $mockWarehouseId -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }
}
