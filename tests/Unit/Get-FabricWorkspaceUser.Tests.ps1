#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricWorkspaceUser'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricWorkspaceUser" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricWorkspaceUser
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $false }
            @{ Name = 'Workspace'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'Parameter alias validation' {
        It 'Should have "Id" as an alias for WorkspaceId parameter' {
            $param = (Get-Command -Name 'Get-FabricWorkspaceUser').Parameters['WorkspaceId']
            $param.Aliases | Should -Contain 'Id'
        }
    }

    Context 'When getting workspace users successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Get-FabricWorkspace -MockWith {
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    displayName = 'TestWorkspace'
                }
            }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @{
                    value = @(
                        @{
                            emailAddress         = 'name@domain.com'
                            groupUserAccessRight = 'Admin'
                            displayName          = 'Fabric'
                            identifier           = 'name@domain.com'
                            principalType        = 'User'
                        }, @{
                            emailAddress         = 'viewer@domain.com'
                            groupUserAccessRight = 'Viewer'
                            displayName          = 'Fabric viewer'
                            identifier           = 'viewer@domain.com'
                            principalType        = 'User'
                        }
                    )
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()

            Get-FabricWorkspaceUser -WorkspaceId $mockWorkspaceId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*groups/*/users*"
            }
        }

        It 'Should return the list of users' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = Get-FabricWorkspaceUser -WorkspaceId $mockWorkspaceId

            $result | Should -Not -BeNullOrEmpty
        }
    }

    Context "Multiple Workspaces" {

        BeforeEach {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Get-FabricWorkspace -MockWith {
                return @(
                    @{
                        displayName = 'prod-workspace'
                        Id          = '11111111-1111-1111-1111-111111111111'
                    }, @{
                        displayName = "test-workspace"
                        Id          = '22222222-2222-2222-2222-222222222222'
                    }
                )
            }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @{
                    value = @(
                        @{
                            emailAddress         = 'name@domain.com'
                            groupUserAccessRight = 'Admin'
                            displayName          = 'Fabric'
                            identifier           = 'name@domain.com'
                            principalType        = 'User'
                        }, @{
                            emailAddress         = 'viewer@domain.com'
                            groupUserAccessRight = 'Viewer'
                            displayName          = 'Fabric viewer'
                            identifier           = 'viewer@domain.com'
                            principalType        = 'User'
                        }
                    )
                }
            }
        }

        It "Should return users for multiple workspaces passed to the Workspace parameter" {
            {Get-FabricWorkspaceUser -Workspace (Get-FabricWorkspace) }| Should -Not -BeNullOrEmpty
        }

        It "Should return users for multiple workspaces passed to the Workspace parameter from the pipeline" {
            { Get-FabricWorkspace | Get-FabricWorkspaceUser
            } | Should -Not -BeNullOrEmpty
        }

        It "Should include workspace name and ID on users returned for multiple workspaces" {
            $result = @(Get-FabricWorkspace | Get-FabricWorkspaceUser)
            $prodUsers = @($result | Where-Object WorkspaceName -EQ 'prod-workspace')
            $testUsers = @($result | Where-Object WorkspaceName -EQ 'test-workspace')

            $result.Count | Should -Be 4
            $prodUsers.Count | Should -Be 2
            $prodUsers[0].WorkspaceId | Should -Be '11111111-1111-1111-1111-111111111111'
            $prodUsers[1].WorkspaceId | Should -Be '11111111-1111-1111-1111-111111111111'
            $testUsers.Count | Should -Be 2
            $testUsers[0].WorkspaceId | Should -Be '22222222-2222-2222-2222-222222222222'
            $testUsers[1].WorkspaceId | Should -Be '22222222-2222-2222-2222-222222222222'
            $result[0].emailAddress | Should -Be 'name@domain.com'
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

            { Get-FabricWorkspaceUser -WorkspaceId $mockWorkspaceId } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }
}
