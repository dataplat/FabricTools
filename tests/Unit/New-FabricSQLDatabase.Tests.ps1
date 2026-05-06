#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'New-FabricSQLDatabase'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "New-FabricSQLDatabase" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name New-FabricSQLDatabase
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'Name'; Mandatory = $true }
            @{ Name = 'Description'; Mandatory = $false }
            @{ Name = 'NoWait'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'When creating SQL database successfully with 201 response' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 201
                }
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    displayName = 'NewSQLDatabase'
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()

            New-FabricSQLDatabase -WorkspaceId $mockWorkspaceId -Name 'NewSQLDatabase' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/sqlDatabases*" -and
                $Method -eq 'Post'
            }
        }

        It 'Should return the created SQL database' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = New-FabricSQLDatabase -WorkspaceId $mockWorkspaceId -Name 'NewSQLDatabase' -Confirm:$false

            $result.displayName | Should -Be 'NewSQLDatabase'
        }
    }

    Context 'When creating SQL database with long running operation (202)' -Skip {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 202
                    $script:responseHeader = @{
                        'x-ms-operation-id' = [guid]::NewGuid().ToString()
                        'Location' = 'https://api.fabric.microsoft.com/operations/123'
                        'Retry-After' = 10
                    }
                }
                return $null
            }
            Mock -CommandName Get-FabricLongRunningOperation -MockWith {
                return [pscustomobject]@{
                    status = 'Succeeded'
                    createdTimeUtc = (Get-Date).ToString()
                }
            }
            Mock -CommandName Get-FabricLongRunningOperationResult -MockWith {
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    displayName = 'NewSQLDatabase'
                }
            }
        }

        It 'Should handle long running operation correctly' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = New-FabricSQLDatabase -WorkspaceId $mockWorkspaceId -Name 'NewSQLDatabase' -Confirm:$false

            Should -Invoke -CommandName Get-FabricLongRunningOperation -Times 1
        }
    }

    Context 'When an unexpected status code is returned' -Skip {
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

            New-FabricSQLDatabase -WorkspaceId $mockWorkspaceId -Name 'NewSQLDatabase' -Confirm:$false

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

            { New-FabricSQLDatabase -WorkspaceId $mockWorkspaceId -Name 'NewSQLDatabase' -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to create SQL Database*"
            }
        }
    }
}
