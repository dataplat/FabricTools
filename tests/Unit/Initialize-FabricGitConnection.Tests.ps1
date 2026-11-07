#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe 'Initialize-FabricGitConnection' -Tag 'UnitTests' {

    BeforeAll {
        $command = Get-Command -Name Initialize-FabricGitConnection
    }

    Context 'Command definition' {
        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'InitializationStrategy'; Mandatory = $false }
            @{ Name = 'NoWait'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should reject an invalid InitializationStrategy' {
            { Initialize-FabricGitConnection -WorkspaceId ([guid]::NewGuid()) -InitializationStrategy 'Bogus' } | Should -Throw
        }
    }

    Context 'When initializing' {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                [pscustomobject]@{ requiredAction = 'UpdateFromGit'; workspaceHead = $null; remoteCommitHash = 'r1' }
            }
            $workspaceId = [guid]::NewGuid()
        }

        It 'Should default the strategy to None' {
            Initialize-FabricGitConnection -WorkspaceId $workspaceId -Confirm:$false | Out-Null

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -eq "workspaces/$workspaceId/git/initializeConnection" -and
                $Method -eq 'Post' -and
                ($Body | ConvertFrom-Json).initializationStrategy -eq 'None'
            }
        }

        It 'Should send the chosen strategy and pass NoWait' {
            Initialize-FabricGitConnection -WorkspaceId $workspaceId -InitializationStrategy PreferRemote -NoWait -Confirm:$false | Out-Null

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                ($Body | ConvertFrom-Json).initializationStrategy -eq 'PreferRemote' -and $NoWait
            }
        }

        It 'Should return the result with WorkspaceId added' {
            $result = Initialize-FabricGitConnection -WorkspaceId $workspaceId -Confirm:$false

            $result.requiredAction | Should -Be 'UpdateFromGit'
            $result.remoteCommitHash | Should -Be 'r1'
            $result.WorkspaceId | Should -Be $workspaceId
        }

        It 'Should not call the API with -WhatIf' {
            Initialize-FabricGitConnection -WorkspaceId $workspaceId -WhatIf

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0 -Exactly
        }
    }
}
