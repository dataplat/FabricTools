#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Remove-FabricSQLDatabase'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Remove-FabricSQLDatabase" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Remove-FabricSQLDatabase
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'SQLDatabaseId'; Mandatory = $true }
            @{ Name = 'SQLDatabaseName'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }

        It 'Should require exactly one database identifier' {
            {
                Remove-FabricSQLDatabase -WorkspaceId ([guid]::NewGuid()) -SQLDatabaseId ([guid]::NewGuid()) -SQLDatabaseName 'TestDatabase' -Confirm:$false
            } | Should -Throw
        }
    }

    Context 'When removing SQL database successfully (200)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return $null
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockSQLDatabaseId = [guid]::NewGuid()

            Remove-FabricSQLDatabase -WorkspaceId $mockWorkspaceId -SQLDatabaseId $mockSQLDatabaseId -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/sqlDatabases/*" -and
                $Method -eq 'Delete'
            }
        }

        It 'Should complete without error' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockSQLDatabaseId = [guid]::NewGuid()

            { Remove-FabricSQLDatabase -WorkspaceId $mockWorkspaceId -SQLDatabaseId $mockSQLDatabaseId -Confirm:$false } | Should -Not -Throw
        }
    }

    Context 'When resolving a SQL database name' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Get-FabricSQLDatabase -MockWith {
                [PSCustomObject]@{ id = '11111111-1111-1111-1111-111111111111'; displayName = 'TestDatabase' }
            }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }
        }

        It 'Should delete the database found by its exact name' {
            Remove-FabricSQLDatabase -WorkspaceId ([guid]::NewGuid()) -SQLDatabaseName 'TestDatabase' -Confirm:$false

            Should -Invoke Get-FabricSQLDatabase -Times 1 -Exactly -ParameterFilter {
                $WorkspaceId -and $SQLDatabaseName -eq 'TestDatabase'
            }
            Should -Invoke Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -like 'workspaces/*/sqldatabases/11111111-1111-1111-1111-111111111111' -and
                $Method -eq 'DELETE' -and $ObjectIdOrName -eq 'TestDatabase'
            }
        }

        It 'Should support the Name alias' {
            Remove-FabricSQLDatabase -WorkspaceId ([guid]::NewGuid()) -Name 'TestDatabase' -Confirm:$false

            Should -Invoke Get-FabricSQLDatabase -Times 1 -ParameterFilter {
                $SQLDatabaseName -eq 'TestDatabase'
            }
        }

        It 'Should not delete when no database matches' {
            Mock -CommandName Get-FabricSQLDatabase -MockWith { return $null }

            Remove-FabricSQLDatabase -WorkspaceId ([guid]::NewGuid()) -SQLDatabaseName 'MissingDatabase' -Confirm:$false

            Should -Invoke Invoke-FabricRestMethod -Times 0
            Should -Invoke Write-Message -Times 1 -ParameterFilter {
                $Level -eq 'Error' -and $Message -like '*No SQL Database found*'
            }
        }

        It 'Should not delete when multiple databases match' {
            Mock -CommandName Get-FabricSQLDatabase -MockWith {
                [PSCustomObject]@{ id = [guid]::NewGuid(); displayName = 'TestDatabase' }
                [PSCustomObject]@{ id = [guid]::NewGuid(); displayName = 'TestDatabase' }
            }

            Remove-FabricSQLDatabase -WorkspaceId ([guid]::NewGuid()) -SQLDatabaseName 'TestDatabase' -Confirm:$false

            Should -Invoke Invoke-FabricRestMethod -Times 0
            Should -Invoke Write-Message -Times 1 -ParameterFilter {
                $Level -eq 'Error' -and $Message -like '*Multiple SQL Databases found*'
            }
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
            $mockSQLDatabaseId = [guid]::NewGuid()

            Remove-FabricSQLDatabase -WorkspaceId $mockWorkspaceId -SQLDatabaseId $mockSQLDatabaseId -Confirm:$false

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
            $mockSQLDatabaseId = [guid]::NewGuid()

            { Remove-FabricSQLDatabase -WorkspaceId $mockWorkspaceId -SQLDatabaseId $mockSQLDatabaseId -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to delete SQL Database*"
            }
        }
    }
}
