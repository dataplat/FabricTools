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

    Context "Alias validation" {
        $testCases = @('Get-FabWorkspaceUsers', 'Get-FabricWorkspaceUsers')

        It "Should have the alias <_>" -TestCases $TestCases {
            $Alias = Get-Alias -Name $_ -ErrorAction SilentlyContinue
            $Alias | Should -Not -BeNullOrEmpty
            $Alias.ResolvedCommand.Name | Should -Be  'Get-FabricWorkspaceUser'
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
                        Id          = [guid]::NewGuid().Guid.ToString()
                    }, @{
                        displayName = "test-workspace"
                        Id          = [guid]::NewGuid().Guid.ToString()
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
