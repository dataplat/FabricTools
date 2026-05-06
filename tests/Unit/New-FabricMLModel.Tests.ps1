#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'New-FabricMLModel'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "New-FabricMLModel" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name New-FabricMLModel
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'MLModelName'; Mandatory = $true }
            @{ Name = 'MLModelDescription'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'When creating ML model successfully with immediate completion (201)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 201
                }
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    displayName = 'TestMLModel'
                    description = 'Test Description'
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()

            New-FabricMLModel -WorkspaceId $mockWorkspaceId -MLModelName 'TestMLModel' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/mlModels" -and
                $Method -eq 'Post'
            }
        }

        It 'Should return the created ML model' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = New-FabricMLModel -WorkspaceId $mockWorkspaceId -MLModelName 'TestMLModel' -Confirm:$false

            $result.displayName | Should -Be 'TestMLModel'
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

            { New-FabricMLModel -WorkspaceId $mockWorkspaceId -MLModelName 'TestMLModel' -Confirm:$false } | Should -Not -Throw

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

            { New-FabricMLModel -WorkspaceId $mockWorkspaceId -MLModelName 'TestMLModel' -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }
}
