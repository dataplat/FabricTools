#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Update-FabricWorkspaceRoleAssignment'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Update-FabricWorkspaceRoleAssignment
}

Describe "Update-FabricWorkspaceRoleAssignment" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'WorkspaceRoleAssignmentId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'WorkspaceRole'; ExpectedParameterType = 'string'; Mandatory = 'True' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Successful workspace role assignment update" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    id   = "00000000-0000-0000-0000-000000000001"
                    role = "Member"
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should update workspace role assignment with valid parameters' {
            $result = Update-FabricWorkspaceRoleAssignment -WorkspaceId (New-Guid) -WorkspaceRoleAssignmentId (New-Guid) -WorkspaceRole 'Member' -Confirm:$false
            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Info' } -Times 1 -Exactly -Scope It
        }
    }

    Context "Unexpected status code handling" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 400
                }
                return [pscustomobject]@{
                    message   = 'Bad Request'
                    errorCode = 'InvalidRequest'
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should write error messages for unexpected status codes' {
            $result = Update-FabricWorkspaceRoleAssignment -WorkspaceId (New-Guid) -WorkspaceRoleAssignmentId (New-Guid) -WorkspaceRole 'Member' -Confirm:$false
            $result | Should -BeNullOrEmpty

            Should -Invoke -CommandName Write-Message -ParameterFilter { $Message -like '*Unexpected response code*' -and $Level -eq 'Error' } -Times 1 -Exactly -Scope It
            Should -Invoke -CommandName Write-Message -ParameterFilter { $Message -like '*Error:*' -and $Level -eq 'Error' } -Times 1 -Exactly -Scope It
            Should -Invoke -CommandName Write-Message -ParameterFilter { $Message -like '*Error Code:*' -and $Level -eq 'Error' } -Times 1 -Exactly -Scope It
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 400
                }
                throw "API Error"
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should handle error when API call fails' {
            {
                Update-FabricWorkspaceRoleAssignment -WorkspaceId (New-Guid) -WorkspaceRoleAssignmentId (New-Guid) -WorkspaceRole 'Member' -Confirm:$false
            } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Error' } -Times 1 -Exactly -Scope It
        }
    }
}
