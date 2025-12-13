#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'New-FabricEnvironment'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "New-FabricEnvironment" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name New-FabricEnvironment
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'EnvironmentName'; Mandatory = $true }
            @{ Name = 'EnvironmentDescription'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'When creating environment successfully with immediate completion (201)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 201
                }
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    displayName = 'TestEnvironment'
                    description = 'Test Description'
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()

            New-FabricEnvironment -WorkspaceId $mockWorkspaceId -EnvironmentName 'TestEnvironment' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/environments" -and
                $Method -eq 'Post'
            }
        }

        It 'Should return the created environment' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = New-FabricEnvironment -WorkspaceId $mockWorkspaceId -EnvironmentName 'TestEnvironment' -Confirm:$false

            $result.displayName | Should -Be 'TestEnvironment'
        }
    }

    Context 'When creating environment with long-running operation (202)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 202
                    $script:responseHeader = @{
                        'x-ms-operation-id' = [guid]::NewGuid().ToString()
                        'Location' = 'https://api.fabric.microsoft.com/v1/operations/12345'
                        'Retry-After' = '30'
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
                    displayName = 'TestEnvironment'
                }
            }
        }

        It 'Should call Get-FabricLongRunningOperation' {
            $mockWorkspaceId = [guid]::NewGuid()

            New-FabricEnvironment -WorkspaceId $mockWorkspaceId -EnvironmentName 'TestEnvironment' -Confirm:$false

            Should -Invoke -CommandName Get-FabricLongRunningOperation -Times 1
        }

        It 'Should call Get-FabricLongRunningOperationResult when operation succeeds' {
            $mockWorkspaceId = [guid]::NewGuid()

            New-FabricEnvironment -WorkspaceId $mockWorkspaceId -EnvironmentName 'TestEnvironment' -Confirm:$false

            Should -Invoke -CommandName Get-FabricLongRunningOperationResult -Times 1
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

            { New-FabricEnvironment -WorkspaceId $mockWorkspaceId -EnvironmentName 'TestEnvironment' -Confirm:$false } | Should -Not -Throw

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

            { New-FabricEnvironment -WorkspaceId $mockWorkspaceId -EnvironmentName 'TestEnvironment' -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }
}
