#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricSQLDatabase'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricSQLDatabase" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricSQLDatabase
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'SQLDatabaseId'; Mandatory = $false }
            @{ Name = 'SQLDatabaseName'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When getting SQL databases successfully (200)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return @(
                    [pscustomobject]@{ id = [guid]::NewGuid(); displayName = 'SQLDatabase1' }
                    [pscustomobject]@{ id = [guid]::NewGuid(); displayName = 'SQLDatabase2' }
                )
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()

            Get-FabricSQLDatabase -WorkspaceId $mockWorkspaceId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/sqlDatabases*" -and
                $Method -eq 'Get'
            }
        }

        It 'Should return the list of SQL databases' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = Get-FabricSQLDatabase -WorkspaceId $mockWorkspaceId

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 2
        }
    }

    Context 'When an unexpected status code is returned' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return $null
            }
        }

        It 'Should return null for unexpected status codes' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = Get-FabricSQLDatabase -WorkspaceId $mockWorkspaceId

            $result | Should -BeNullOrEmpty
        }
    }

    Context 'When an exception is thrown' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw 'API connection failed'
            }
        }

        It 'Should propagate exceptions' {
            $mockWorkspaceId = [guid]::NewGuid()

            { Get-FabricSQLDatabase -WorkspaceId $mockWorkspaceId } | Should -Throw
        }
    }
}
