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

    Context 'Parameter alias validation' {
        It 'Should have "Id" as an alias for WorkspaceId parameter' {
            $param = (Get-Command -Name 'Update-FabricWorkspaceRoleAssignment').Parameters['WorkspaceId']
            $param.Aliases | Should -Contain 'Id'
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
}
