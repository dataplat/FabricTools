#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe 'Disconnect-FabricGit' -Tag 'UnitTests' {

    BeforeAll {
        $command = Get-Command -Name Disconnect-FabricGit
    }

    Context 'Command definition' {
        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess with high impact' {
            $command.Parameters.Keys | Should -Contain 'WhatIf'
            $command.ScriptBlock.Attributes.Where({ $_ -is [System.Management.Automation.CmdletBindingAttribute] }).ConfirmImpact | Should -Be 'High'
        }
    }

    Context 'When disconnecting' {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }
            $workspaceId = [guid]::NewGuid()
        }

        It 'Should call the disconnect endpoint with POST' {
            Disconnect-FabricGit -WorkspaceId $workspaceId -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -eq "workspaces/$workspaceId/git/disconnect" -and $Method -eq 'Post'
            }
        }

        It 'Should not call the API with -WhatIf' {
            Disconnect-FabricGit -WorkspaceId $workspaceId -WhatIf

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0 -Exactly
        }

        It 'Should return nothing' {
            Disconnect-FabricGit -WorkspaceId $workspaceId -Confirm:$false | Should -BeNullOrEmpty
        }
    }
}
