#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricWorkspace'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricWorkspace" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricWorkspace
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $false }
            @{ Name = 'WorkspaceName'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When retrieving workspaces successfully (200)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    value = @(
                        [pscustomobject]@{
                            Id = [guid]::NewGuid()
                            DisplayName = 'TestWorkspace1'
                            Description = 'Test Description 1'
                        },
                        [pscustomobject]@{
                            Id = [guid]::NewGuid()
                            DisplayName = 'TestWorkspace2'
                            Description = 'Test Description 2'
                        }
                    )
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            Get-FabricWorkspace

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces*" -and
                $Method -eq 'Get'
            }
        }

        It 'Should return all workspaces when no filter is provided' {
            $result = Get-FabricWorkspace

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 2
        }
    }

    Context 'When filtering by WorkspaceId' {
        BeforeAll {
            $script:mockWorkspaceId = [guid]::NewGuid()
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    value = @(
                        [pscustomobject]@{
                            Id = $script:mockWorkspaceId
                            DisplayName = 'TestWorkspace1'
                            Description = 'Test Description 1'
                        }
                    )
                }
            }
        }

        It 'Should return the filtered workspace' {
            $result = Get-FabricWorkspace -WorkspaceId $script:mockWorkspaceId

            $result | Should -Not -BeNullOrEmpty
        }
    }

    Context 'When both WorkspaceId and WorkspaceName are provided' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should write an error message' {
            $mockWorkspaceId = [guid]::NewGuid()

            Get-FabricWorkspace -WorkspaceId $mockWorkspaceId -WorkspaceName 'TestWorkspace'

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Both*"
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
            Get-FabricWorkspace

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
            { Get-FabricWorkspace } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }
}
