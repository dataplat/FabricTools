#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricWorkspaceRoleAssignment'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricWorkspaceRoleAssignment" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricWorkspaceRoleAssignment
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'WorkspaceRoleAssignmentId'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When getting all workspace role assignments successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    value = @(
                        [pscustomobject]@{ id = [guid]::NewGuid(); principal = @{ id = [guid]::NewGuid(); displayName = 'User1'; type = 'User'; userDetails = @{ userPrincipalName = 'user1@test.com' }; servicePrincipalDetails = $null }; role = 'Admin' }
                        [pscustomobject]@{ id = [guid]::NewGuid(); principal = @{ id = [guid]::NewGuid(); displayName = 'User2'; type = 'User'; userDetails = @{ userPrincipalName = 'user2@test.com' }; servicePrincipalDetails = $null }; role = 'Member' }
                    )
                    continuationToken = $null
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()

            Get-FabricWorkspaceRoleAssignment -WorkspaceId $mockWorkspaceId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/roleAssignments*"
            }
        }

        It 'Should return the list of role assignments' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = Get-FabricWorkspaceRoleAssignment -WorkspaceId $mockWorkspaceId

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 2
        }
    }

    Context 'When getting a specific role assignment by ID' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    value = @(
                        [pscustomobject]@{ id = [guid]::NewGuid(); principal = @{ id = [guid]::NewGuid(); displayName = 'User1'; type = 'User'; userDetails = @{ userPrincipalName = 'user1@test.com' }; servicePrincipalDetails = $null }; role = 'Admin' }
                        [pscustomobject]@{ id = [guid]::NewGuid(); principal = @{ id = [guid]::NewGuid(); displayName = 'User2'; type = 'User'; userDetails = @{ userPrincipalName = 'user2@test.com' }; servicePrincipalDetails = $null }; role = 'Member' }
                    )
                    continuationToken = $null
                }
            }
        }

        It 'Should filter by role assignment ID when specified' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockAssignmentId = [guid]::NewGuid().ToString()

            Get-FabricWorkspaceRoleAssignment -WorkspaceId $mockWorkspaceId -WorkspaceRoleAssignmentId $mockAssignmentId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1
        }
    }

    Context 'When no role assignments are found' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    value = @()
                    continuationToken = $null
                }
            }
        }

        It 'Should return empty when no assignments found' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = Get-FabricWorkspaceRoleAssignment -WorkspaceId $mockWorkspaceId

            $result | Should -BeNullOrEmpty
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

            { Get-FabricWorkspaceRoleAssignment -WorkspaceId $mockWorkspaceId } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to retrieve role assignments*"
            }
        }
    }
}
