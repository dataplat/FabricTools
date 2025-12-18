#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Remove-FabricDomainWorkspaceAssignment'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Remove-FabricDomainWorkspaceAssignment" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Remove-FabricDomainWorkspaceAssignment
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'DomainId'; Mandatory = $true }
            @{ Name = 'WorkspaceIds'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'When removing domain workspace assignment successfully (200)' {
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
            $mockDomainId = [guid]::NewGuid()
            $mockWorkspaceIds = @([guid]::NewGuid().ToString())

            Remove-FabricDomainWorkspaceAssignment -DomainId $mockDomainId -WorkspaceIds $mockWorkspaceIds -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*admin/domains/*/unassignWorkspaces*" -and
                $Method -eq 'Post'
            }
        }

        It 'Should write a success message' {
            $mockDomainId = [guid]::NewGuid()
            $mockWorkspaceIds = @([guid]::NewGuid().ToString())

            Remove-FabricDomainWorkspaceAssignment -DomainId $mockDomainId -WorkspaceIds $mockWorkspaceIds -Confirm:$false

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Info'
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
            $mockDomainId = [guid]::NewGuid()
            $mockWorkspaceIds = @([guid]::NewGuid().ToString())

            Remove-FabricDomainWorkspaceAssignment -DomainId $mockDomainId -WorkspaceIds $mockWorkspaceIds -Confirm:$false

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
            $mockDomainId = [guid]::NewGuid()
            $mockWorkspaceIds = @([guid]::NewGuid().ToString())

            { Remove-FabricDomainWorkspaceAssignment -DomainId $mockDomainId -WorkspaceIds $mockWorkspaceIds -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }
}
