#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe 'Update-FabricGitCredential' -Tag 'UnitTests' {

    BeforeAll {
        $command = Get-Command -Name Update-FabricGitCredential
    }

    Context 'Command definition' {
        It 'Should have the parameter sets: <_>' -ForEach @('Automatic', 'ConfiguredConnection', 'None') {
            $command.ParameterSets.Name | Should -Contain $_
        }

        It 'Should not allow -Automatic with -ConnectionId' {
            { Update-FabricGitCredential -WorkspaceId ([guid]::NewGuid()) -Automatic -ConnectionId ([guid]::NewGuid()) } | Should -Throw
        }
    }

    Context 'When updating credentials' {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { [pscustomobject]@{ source = 'x' } }
            $workspaceId = [guid]::NewGuid()
        }

        It 'Should send source Automatic with -Automatic' {
            Update-FabricGitCredential -WorkspaceId $workspaceId -Automatic -Confirm:$false | Out-Null

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $b = $Body | ConvertFrom-Json
                $Uri -eq "workspaces/$workspaceId/git/myGitCredentials" -and
                $Method -eq 'Patch' -and
                $b.source -eq 'Automatic' -and $null -eq $b.connectionId
            }
        }

        It 'Should send ConfiguredConnection with -ConnectionId' {
            $connectionId = [guid]::NewGuid()
            Update-FabricGitCredential -WorkspaceId $workspaceId -ConnectionId $connectionId -Confirm:$false | Out-Null

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $b = $Body | ConvertFrom-Json
                $b.source -eq 'ConfiguredConnection' -and $b.connectionId -eq $connectionId.ToString()
            }
        }

        It 'Should send source None with -None' {
            Update-FabricGitCredential -WorkspaceId $workspaceId -None -Confirm:$false | Out-Null

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                ($Body | ConvertFrom-Json).source -eq 'None'
            }
        }

        It 'Should return the response with WorkspaceId added' {
            $result = Update-FabricGitCredential -WorkspaceId $workspaceId -Automatic -Confirm:$false

            $result.WorkspaceId | Should -Be $workspaceId
        }

        It 'Should not call the API with -WhatIf' {
            Update-FabricGitCredential -WorkspaceId $workspaceId -Automatic -WhatIf

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0 -Exactly
        }
    }
}
