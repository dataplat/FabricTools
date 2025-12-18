#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Update-FabricLakehouse'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Update-FabricLakehouse" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Update-FabricLakehouse
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'LakehouseId'; Mandatory = $true }
            @{ Name = 'LakehouseName'; Mandatory = $true }
            @{ Name = 'LakehouseDescription'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'When updating lakehouse successfully (200)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    displayName = 'UpdatedLakehouse'
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockLakehouseId = [guid]::NewGuid()

            Update-FabricLakehouse -WorkspaceId $mockWorkspaceId -LakehouseId $mockLakehouseId -LakehouseName 'UpdatedLakehouse' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/lakehouses/*" -and
                $Method -eq 'Patch'
            }
        }

        It 'Should return the updated lakehouse' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockLakehouseId = [guid]::NewGuid()

            $result = Update-FabricLakehouse -WorkspaceId $mockWorkspaceId -LakehouseId $mockLakehouseId -LakehouseName 'UpdatedLakehouse' -Confirm:$false

            $result.displayName | Should -Be 'UpdatedLakehouse'
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
            $mockLakehouseId = [guid]::NewGuid()

            Update-FabricLakehouse -WorkspaceId $mockWorkspaceId -LakehouseId $mockLakehouseId -LakehouseName 'UpdatedLakehouse' -Confirm:$false

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
            $mockLakehouseId = [guid]::NewGuid()

            { Update-FabricLakehouse -WorkspaceId $mockWorkspaceId -LakehouseId $mockLakehouseId -LakehouseName 'UpdatedLakehouse' -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to update lakehouse*"
            }
        }
    }
}
