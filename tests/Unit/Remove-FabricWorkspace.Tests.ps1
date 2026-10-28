#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Remove-FabricWorkspace'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Remove-FabricWorkspace" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Remove-FabricWorkspace
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'WorkspaceName'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'Parameter alias validation' {
        It 'Should have "Id" as an alias for WorkspaceId parameter' {
            $param = (Get-Command -Name 'Remove-FabricWorkspace').Parameters['WorkspaceId']
            $param.Aliases | Should -Contain 'Id'
        }

        It 'Should have "Name" as an alias for WorkspaceName parameter' {
            $command.Parameters['WorkspaceName'].Aliases | Should -Contain 'Name'
        }

        It 'Should reject specifying both an ID and a name' {
            { Remove-FabricWorkspace -WorkspaceId ([guid]::NewGuid()) -WorkspaceName 'TestWorkspace' -Confirm:$false } | Should -Throw
        }
    }

    Context 'When resolving a workspace name' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }
            Mock -CommandName Get-FabricWorkspace -MockWith {
                [PSCustomObject]@{ Id = '11111111-1111-1111-1111-111111111111'; DisplayName = 'TestWorkspace' }
            }
        }

        It 'Should delete the resolved workspace using <Parameter>' -ForEach @(
            @{ Parameter = 'WorkspaceName' }
            @{ Parameter = 'Name' }
        ) {
            $parameters = @{ $Parameter = 'TestWorkspace'; Confirm = $false }
            Remove-FabricWorkspace @parameters

            Should -Invoke -CommandName Get-FabricWorkspace -Times 1 -Exactly -ParameterFilter {
                $WorkspaceName -eq 'TestWorkspace'
            }
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -eq 'workspaces/11111111-1111-1111-1111-111111111111' -and
                $Method -eq 'Delete' -and $HandleResponse
            }
        }

        It 'Should not delete when no workspace matches' {
            Mock -CommandName Get-FabricWorkspace -MockWith { return $null }

            Remove-FabricWorkspace -Name 'MissingWorkspace' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0
            Should -Invoke -CommandName Write-Message -Times 1 -ParameterFilter {
                $Level -eq 'Error' -and $Message -like '*No workspace found*'
            }
        }

        It 'Should not delete when multiple workspaces match' {
            Mock -CommandName Get-FabricWorkspace -MockWith {
                [PSCustomObject]@{ Id = [guid]::NewGuid(); DisplayName = 'TestWorkspace' }
                [PSCustomObject]@{ Id = [guid]::NewGuid(); DisplayName = 'TestWorkspace' }
            }

            Remove-FabricWorkspace -Name 'TestWorkspace' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0
            Should -Invoke -CommandName Write-Message -Times 1 -ParameterFilter {
                $Level -eq 'Error' -and $Message -like '*Specify WorkspaceId*'
            }
        }

        It 'Should not delete when name lookup fails' {
            Mock -CommandName Get-FabricWorkspace -MockWith { throw 'Lookup failed' }

            Remove-FabricWorkspace -Name 'TestWorkspace' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0
            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Error' }
        }

        It 'Should not delete when the resolved ID is invalid: <Id>' -ForEach @(
            @{ Id = $null }
            @{ Id = '' }
            @{ Id = 'not-a-guid' }
            @{ Id = '00000000-0000-0000-0000-000000000000' }
        ) {
            Mock -CommandName Get-FabricWorkspace -MockWith {
                [PSCustomObject]@{ Id = $Id; DisplayName = 'TestWorkspace' }
            }

            Remove-FabricWorkspace -Name 'TestWorkspace' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0
            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Error' }
        }

        It 'Should not delete by name with WhatIf' {
            Remove-FabricWorkspace -Name 'TestWorkspace' -WhatIf

            Should -Invoke -CommandName Get-FabricWorkspace -Times 1 -Exactly
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0
        }

        It 'Should not resolve names or delete by ID with WhatIf' {
            Remove-FabricWorkspace -WorkspaceId ([guid]::NewGuid()) -WhatIf

            Should -Invoke -CommandName Get-FabricWorkspace -Times 0
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0
        }

        It 'Should preserve positional ID deletion without looking up names' {
            Remove-FabricWorkspace '11111111-1111-1111-1111-111111111111' -Confirm:$false

            Should -Invoke -CommandName Get-FabricWorkspace -Times 0
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -eq 'workspaces/11111111-1111-1111-1111-111111111111' -and $Method -eq 'Delete'
            }
        }
    }

    Context 'When removing workspace successfully (200)' {
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

            Remove-FabricWorkspace -WorkspaceId $mockWorkspaceId -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*" -and
                $Method -eq 'Delete'
            }
        }

        It 'Should write a success message' {
            $mockWorkspaceId = [guid]::NewGuid()

            Remove-FabricWorkspace -WorkspaceId $mockWorkspaceId -Confirm:$false

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Info' -and $Message -like "*deleted successfully*"
            }
        }
    }

    Context 'When an unexpected status code is returned' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw 'Unexpected response code: 400 - Bad Request'
            }
        }

        It 'Should write an error message for unexpected status codes' {
            $mockWorkspaceId = [guid]::NewGuid()

            Remove-FabricWorkspace -WorkspaceId $mockWorkspaceId -Confirm:$false

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

            { Remove-FabricWorkspace -WorkspaceId $mockWorkspaceId -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }
}
