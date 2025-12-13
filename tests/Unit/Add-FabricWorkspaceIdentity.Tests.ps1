#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Add-FabricWorkspaceIdentity'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Add-FabricWorkspaceIdentity" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Add-FabricWorkspaceIdentity
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When provisioning identity successfully with immediate completion (200)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    applicationId = [guid]::NewGuid()
                    servicePrincipalId = [guid]::NewGuid()
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()

            Add-FabricWorkspaceIdentity -WorkspaceId $mockWorkspaceId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/provisionIdentity" -and
                $Method -eq 'Post'
            }
        }

        It 'Should return the identity information' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = Add-FabricWorkspaceIdentity -WorkspaceId $mockWorkspaceId

            $result.applicationId | Should -Not -BeNullOrEmpty
            $result.servicePrincipalId | Should -Not -BeNullOrEmpty
        }
    }

    Context 'When provisioning identity with long-running operation (202)' {
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
                    applicationId = [guid]::NewGuid()
                    servicePrincipalId = [guid]::NewGuid()
                }
            }
        }

        It 'Should call Get-FabricLongRunningOperation' {
            $mockWorkspaceId = [guid]::NewGuid()

            Add-FabricWorkspaceIdentity -WorkspaceId $mockWorkspaceId

            Should -Invoke -CommandName Get-FabricLongRunningOperation -Times 1
        }

        It 'Should call Get-FabricLongRunningOperationResult when operation succeeds' {
            $mockWorkspaceId = [guid]::NewGuid()

            Add-FabricWorkspaceIdentity -WorkspaceId $mockWorkspaceId

            Should -Invoke -CommandName Get-FabricLongRunningOperationResult -Times 1
        }
    }

    Context 'When long-running operation fails' {
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
                    status = 'Failed'
                    error = @{
                        message = 'Operation failed'
                    }
                }
            }
            Mock -CommandName Get-FabricLongRunningOperationResult -MockWith {
                return $null
            }
        }

        It 'Should not call Get-FabricLongRunningOperationResult when operation fails' {
            $mockWorkspaceId = [guid]::NewGuid()

            Add-FabricWorkspaceIdentity -WorkspaceId $mockWorkspaceId

            Should -Invoke -CommandName Get-FabricLongRunningOperation -Times 1
            Should -Not -Invoke -CommandName Get-FabricLongRunningOperationResult
        }

        It 'Should write an error message' {
            $mockWorkspaceId = [guid]::NewGuid()

            Add-FabricWorkspaceIdentity -WorkspaceId $mockWorkspaceId

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
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

            # The throw inside the switch is caught by the catch block, so it writes an error instead of throwing
            { Add-FabricWorkspaceIdentity -WorkspaceId $mockWorkspaceId } | Should -Not -Throw

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

            { Add-FabricWorkspaceIdentity -WorkspaceId $mockWorkspaceId } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to provision workspace identity*"
            }
        }
    }
}
