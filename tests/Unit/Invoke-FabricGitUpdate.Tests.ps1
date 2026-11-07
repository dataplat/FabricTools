#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe 'Invoke-FabricGitUpdate' -Tag 'UnitTests' {

    BeforeAll {
        $command = Get-Command -Name Invoke-FabricGitUpdate
    }

    Context 'Command definition' {
        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'RemoteCommitHash'; Mandatory = $false }
            @{ Name = 'WorkspaceHead'; Mandatory = $false }
            @{ Name = 'ConflictResolutionPolicy'; Mandatory = $false }
            @{ Name = 'AllowOverrideItems'; Mandatory = $false }
            @{ Name = 'NoAutoResolve'; Mandatory = $false }
            @{ Name = 'NoWait'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should have high confirm impact' {
            $command.ScriptBlock.Attributes.Where({ $_ -is [System.Management.Automation.CmdletBindingAttribute] }).ConfirmImpact | Should -Be 'High'
        }
    }

    Context 'When updating' {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }
            Mock -CommandName Get-FabricGitStatus -MockWith {
                [pscustomobject]@{ workspaceHead = 'w1'; remoteCommitHash = 'r1' }
            }
            $workspaceId = [guid]::NewGuid()
        }

        It 'Should resolve both hashes and send a minimal body' {
            Invoke-FabricGitUpdate -WorkspaceId $workspaceId -Confirm:$false

            Should -Invoke -CommandName Get-FabricGitStatus -Times 1 -Exactly
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $b = $Body | ConvertFrom-Json
                $Uri -eq "workspaces/$workspaceId/git/updateFromGit" -and
                $Method -eq 'Post' -and
                $b.remoteCommitHash -eq 'r1' -and
                $b.workspaceHead -eq 'w1' -and
                $null -eq $b.conflictResolution -and
                $null -eq $b.options
            }
        }

        It 'Should not resolve when both hashes are supplied' {
            Invoke-FabricGitUpdate -WorkspaceId $workspaceId -RemoteCommitHash 'rX' -WorkspaceHead 'wX' -Confirm:$false

            Should -Invoke -CommandName Get-FabricGitStatus -Times 0 -Exactly
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $b = $Body | ConvertFrom-Json
                $b.remoteCommitHash -eq 'rX' -and $b.workspaceHead -eq 'wX'
            }
        }

        It 'Should send conflict resolution and options' {
            Invoke-FabricGitUpdate -WorkspaceId $workspaceId -ConflictResolutionPolicy PreferRemote -AllowOverrideItems -NoWait -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $b = $Body | ConvertFrom-Json
                $b.conflictResolution.conflictResolutionType -eq 'Workspace' -and
                $b.conflictResolution.conflictResolutionPolicy -eq 'PreferRemote' -and
                $b.options.allowOverrideItems -eq $true -and
                $NoWait
            }
        }

        It 'Should require RemoteCommitHash with -NoAutoResolve' {
            { Invoke-FabricGitUpdate -WorkspaceId $workspaceId -NoAutoResolve -Confirm:$false } | Should -Throw '*RemoteCommitHash is required*'
        }

        It 'Should not resolve with -NoAutoResolve' {
            Invoke-FabricGitUpdate -WorkspaceId $workspaceId -NoAutoResolve -RemoteCommitHash 'rX' -Confirm:$false

            Should -Invoke -CommandName Get-FabricGitStatus -Times 0 -Exactly
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $null -eq ($Body | ConvertFrom-Json).workspaceHead
            }
        }

        It 'Should not call the API with -WhatIf' {
            Invoke-FabricGitUpdate -WorkspaceId $workspaceId -WhatIf

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0 -Exactly
        }
    }

    Context 'When the remote commit hash cannot be resolved' {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }
            Mock -CommandName Get-FabricGitStatus -MockWith { [pscustomobject]@{ workspaceHead = 'w1'; remoteCommitHash = $null } }
        }

        It 'Should throw' {
            { Invoke-FabricGitUpdate -WorkspaceId ([guid]::NewGuid()) -Confirm:$false } | Should -Throw '*Could not determine the remote commit hash*'
        }
    }
}
