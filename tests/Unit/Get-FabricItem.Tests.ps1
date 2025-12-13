#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricItem'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricItem" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricItem
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'workspaceId'; Mandatory = $true }
            @{ Name = 'type'; Mandatory = $false }
            @{ Name = 'itemID'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When retrieving items successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return [pscustomobject]@{
                    value = @(
                        [pscustomobject]@{
                            id = [guid]::NewGuid()
                            displayName = 'TestItem1'
                            type = 'Lakehouse'
                        },
                        [pscustomobject]@{
                            id = [guid]::NewGuid()
                            displayName = 'TestItem2'
                            type = 'Notebook'
                        }
                    )
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()

            Get-FabricItem -workspaceId $mockWorkspaceId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/items*" -and
                $Method -eq 'Get'
            }
        }

        It 'Should return all items when no filter is provided' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = Get-FabricItem -workspaceId $mockWorkspaceId

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 2
        }
    }

    Context 'When filtering by type' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return [pscustomobject]@{
                    value = @(
                        [pscustomobject]@{
                            id = [guid]::NewGuid()
                            displayName = 'TestLakehouse'
                            type = 'Lakehouse'
                        }
                    )
                }
            }
        }

        It 'Should call API with type filter' {
            $mockWorkspaceId = [guid]::NewGuid()

            Get-FabricItem -workspaceId $mockWorkspaceId -type 'Lakehouse'

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*items?type=Lakehouse*"
            }
        }
    }

    Context 'When retrieving specific item by ID' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    displayName = 'TestItem'
                    type = 'Lakehouse'
                }
            }
        }

        It 'Should call API with item ID' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockItemId = [guid]::NewGuid()

            Get-FabricItem -workspaceId $mockWorkspaceId -itemID $mockItemId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/items/*"
            }
        }
    }
}
