#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Remove-FabricItem'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Remove-FabricItem" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Remove-FabricItem
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'workspaceId'; Mandatory = $true }
            @{ Name = 'itemID'; Mandatory = $false }
            @{ Name = 'filter'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'When removing item successfully (200)' {
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
            $mockItemId = [guid]::NewGuid()

            Remove-FabricItem -workspaceId $mockWorkspaceId -itemID $mockItemId -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/items/*" -and
                $Method -eq 'Delete'
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
            $mockItemId = [guid]::NewGuid()

            Remove-FabricItem -workspaceId $mockWorkspaceId -itemID $mockItemId -Confirm:$false

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }

    Context 'When an exception is thrown' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw 'API connection failed'
            }
        }

        It 'Should throw the exception' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockItemId = [guid]::NewGuid()

            { Remove-FabricItem -workspaceId $mockWorkspaceId -itemID $mockItemId -Confirm:$false } | Should -Throw
        }
    }

    Context 'Deletion scope' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                if ($Method -eq 'Get') {
                    return @(
                        [pscustomobject]@{ id = '11111111-1111-1111-1111-111111111111'; displayName = 'keep-me' }
                        [pscustomobject]@{ id = '22222222-2222-2222-2222-222222222222'; displayName = 'test-one' }
                        [pscustomobject]@{ id = '33333333-3333-3333-3333-333333333333'; displayName = 'test-two' }
                    )
                }
                return $null
            }
        }

        It 'Should delete only the items matching the filter' {
            $mockWorkspaceId = [guid]::NewGuid()

            Remove-FabricItem -workspaceId $mockWorkspaceId -filter 'test-*' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 2 -Exactly -ParameterFilter {
                $Method -eq 'Delete'
            }
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0 -Exactly -ParameterFilter {
                $Method -eq 'Delete' -and $Uri -like '*11111111-1111-1111-1111-111111111111*'
            } -Because 'keep-me does not match the filter'
        }

        It 'Should delete every item when no filter is supplied' {
            $mockWorkspaceId = [guid]::NewGuid()

            Remove-FabricItem -workspaceId $mockWorkspaceId -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 3 -Exactly -ParameterFilter {
                $Method -eq 'Delete'
            }
        }

        It 'Should delete nothing under -WhatIf' {
            $mockWorkspaceId = [guid]::NewGuid()

            Remove-FabricItem -workspaceId $mockWorkspaceId -WhatIf

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0 -ParameterFilter {
                $Method -eq 'Delete'
            }
        }
    }
}
