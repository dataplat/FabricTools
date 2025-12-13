#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'New-FabricWarehouse'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "New-FabricWarehouse" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name New-FabricWarehouse
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
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

    Context 'When creating warehouse successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    displayName = 'TestWarehouse'
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()

            New-FabricWarehouse -WorkspaceId $mockWorkspaceId -WarehouseName 'TestWarehouse' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/warehouses" -and
                $Method -eq 'Post'
            }
        }

        It 'Should return the created warehouse' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = New-FabricWarehouse -WorkspaceId $mockWorkspaceId -WarehouseName 'TestWarehouse' -Confirm:$false

            $result.displayName | Should -Be 'TestWarehouse'
        }

        It 'Should write a success message' {
            $mockWorkspaceId = [guid]::NewGuid()

            New-FabricWarehouse -WorkspaceId $mockWorkspaceId -WarehouseName 'TestWarehouse' -Confirm:$false

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Info' -and $Message -like "*created successfully*"
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

            { New-FabricWarehouse -WorkspaceId $mockWorkspaceId -WarehouseName 'TestWarehouse' -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to create Warehouse*"
            }
        }
    }
}
