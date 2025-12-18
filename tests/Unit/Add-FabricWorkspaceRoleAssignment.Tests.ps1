#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Add-FabricWorkspaceRoleAssignment'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Add-FabricWorkspaceRoleAssignment" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Add-FabricWorkspaceRoleAssignment
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'PrincipalId'; Mandatory = $true }
            @{ Name = 'PrincipalType'; Mandatory = $true }
            @{ Name = 'WorkspaceRole'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When assigning role successfully (201)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 201
                }
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    principal = @{
                        id = [guid]::NewGuid()
                        type = 'User'
                    }
                    role = 'Admin'
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockPrincipalId = [guid]::NewGuid()

            Add-FabricWorkspaceRoleAssignment -WorkspaceId $mockWorkspaceId -PrincipalId $mockPrincipalId -PrincipalType 'User' -WorkspaceRole 'Admin'

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/roleAssignments" -and
                $Method -eq 'Post'
            }
        }

        It 'Should return the role assignment' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockPrincipalId = [guid]::NewGuid()

            $result = Add-FabricWorkspaceRoleAssignment -WorkspaceId $mockWorkspaceId -PrincipalId $mockPrincipalId -PrincipalType 'User' -WorkspaceRole 'Admin'

            $result.role | Should -Be 'Admin'
        }

        It 'Should write a success message' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockPrincipalId = [guid]::NewGuid()

            Add-FabricWorkspaceRoleAssignment -WorkspaceId $mockWorkspaceId -PrincipalId $mockPrincipalId -PrincipalType 'User' -WorkspaceRole 'Admin'

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Info' -and $Message -like "*successfully*"
            }
        }
    }

    Context 'When response is empty' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 201
                }
                return $null
            }
        }

        It 'Should write a warning and return null' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockPrincipalId = [guid]::NewGuid()

            $result = Add-FabricWorkspaceRoleAssignment -WorkspaceId $mockWorkspaceId -PrincipalId $mockPrincipalId -PrincipalType 'User' -WorkspaceRole 'Admin'

            $result | Should -BeNullOrEmpty
            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Warning' -and $Message -like "*No data returned*"
            }
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
            $mockPrincipalId = [guid]::NewGuid()

            Add-FabricWorkspaceRoleAssignment -WorkspaceId $mockWorkspaceId -PrincipalId $mockPrincipalId -PrincipalType 'User' -WorkspaceRole 'Admin'

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
            $mockPrincipalId = [guid]::NewGuid()

            { Add-FabricWorkspaceRoleAssignment -WorkspaceId $mockWorkspaceId -PrincipalId $mockPrincipalId -PrincipalType 'User' -WorkspaceRole 'Admin' } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to assign role*"
            }
        }
    }
}
