#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'New-FabricLakehouse'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "New-FabricLakehouse" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name New-FabricLakehouse
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'LakehouseName'; Mandatory = $true }
            @{ Name = 'LakehouseDescription'; Mandatory = $false }
            @{ Name = 'LakehouseEnableSchemas'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'When creating lakehouse successfully with immediate completion (201)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 201
                }
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    displayName = 'TestLakehouse'
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()

            New-FabricLakehouse -WorkspaceId $mockWorkspaceId -LakehouseName 'TestLakehouse' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/lakehouses" -and
                $Method -eq 'Post'
            }
        }

        It 'Should return the created lakehouse' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = New-FabricLakehouse -WorkspaceId $mockWorkspaceId -LakehouseName 'TestLakehouse' -Confirm:$false

            $result.displayName | Should -Be 'TestLakehouse'
        }
    }

    Context 'When creating lakehouse with long-running operation (202)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 202
                    $script:responseHeader = @{
                        'x-ms-operation-id' = [guid]::NewGuid().ToString()
                    }
                }
                return $null
            }
            Mock -CommandName Get-FabricLongRunningOperation -MockWith {
                return [pscustomobject]@{
                    status = 'Succeeded'
                }
            }
            Mock -CommandName Get-FabricLongRunningOperationResult -MockWith {
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    displayName = 'TestLakehouse'
                }
            }
        }

        It 'Should call Get-FabricLongRunningOperation' {
            $mockWorkspaceId = [guid]::NewGuid()

            New-FabricLakehouse -WorkspaceId $mockWorkspaceId -LakehouseName 'TestLakehouse' -Confirm:$false

            Should -Invoke -CommandName Get-FabricLongRunningOperation -Times 1
        }

        It 'Should call Get-FabricLongRunningOperationResult when operation succeeds' {
            $mockWorkspaceId = [guid]::NewGuid()

            New-FabricLakehouse -WorkspaceId $mockWorkspaceId -LakehouseName 'TestLakehouse' -Confirm:$false

            Should -Invoke -CommandName Get-FabricLongRunningOperationResult -Times 1
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

            { New-FabricLakehouse -WorkspaceId $mockWorkspaceId -LakehouseName 'TestLakehouse' -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to create lakehouse*"
            }
        }
    }
}
