#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Update-FabricWarehouse'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Update-FabricWarehouse" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Update-FabricWarehouse
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'WarehouseId'; Mandatory = $true }
            @{ Name = 'WarehouseName'; Mandatory = $true }
            @{ Name = 'WarehouseDescription'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'When updating warehouse successfully (200)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    displayName = 'UpdatedWarehouse'
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockWarehouseId = [guid]::NewGuid()

            Update-FabricWarehouse -WorkspaceId $mockWorkspaceId -WarehouseId $mockWarehouseId -WarehouseName 'UpdatedWarehouse' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/warehouses/*" -and
                $Method -eq 'Patch'
            }
        }

        It 'Should return the updated warehouse' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockWarehouseId = [guid]::NewGuid()

            $result = Update-FabricWarehouse -WorkspaceId $mockWorkspaceId -WarehouseId $mockWarehouseId -WarehouseName 'UpdatedWarehouse' -Confirm:$false

            $result.displayName | Should -Be 'UpdatedWarehouse'
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
                throw "Bad Request"
            }
        }

        It 'Should write an error message for unexpected status codes' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockWarehouseId = [guid]::NewGuid()

            Update-FabricWarehouse -WorkspaceId $mockWorkspaceId -WarehouseId $mockWarehouseId -WarehouseName 'UpdatedWarehouse' -Confirm:$false

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            } -Times 1 -Exactly -Scope It
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

            { Update-FabricWarehouse -WorkspaceId $mockWorkspaceId -WarehouseId $mockWarehouseId -WarehouseName 'UpdatedWarehouse' -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }
}
