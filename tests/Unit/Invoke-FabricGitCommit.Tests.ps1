#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe 'Invoke-FabricGitCommit' -Tag 'UnitTests' {

    BeforeAll {
        $command = Get-Command -Name Invoke-FabricGitCommit
    }

    Context 'Command definition' {
        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'Comment'; Mandatory = $false }
            @{ Name = 'Item'; Mandatory = $false }
            @{ Name = 'WorkspaceHead'; Mandatory = $false }
            @{ Name = 'NoAutoResolve'; Mandatory = $false }
            @{ Name = 'NoWait'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should reject a comment longer than 300 characters' {
            { Invoke-FabricGitCommit -WorkspaceId ([guid]::NewGuid()) -Comment ('x' * 301) } | Should -Throw
        }
    }

    Context 'When committing' {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }
            Mock -CommandName Get-FabricGitStatus -MockWith {
                [pscustomobject]@{ workspaceHead = 'resolvedHead'; remoteCommitHash = 'r1' }
            }
            $workspaceId = [guid]::NewGuid()
        }

        It 'Should commit all changes and resolve the workspace head' {
            Invoke-FabricGitCommit -WorkspaceId $workspaceId -Comment 'msg' -Confirm:$false

            Should -Invoke -CommandName Get-FabricGitStatus -Times 1 -Exactly
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $b = $Body | ConvertFrom-Json
                $Uri -eq "workspaces/$workspaceId/git/commitToGit" -and
                $Method -eq 'Post' -and
                $b.mode -eq 'All' -and
                $b.workspaceHead -eq 'resolvedHead' -and
                $b.comment -eq 'msg' -and
                $null -eq $b.items
            }
        }

        It 'Should use the supplied WorkspaceHead without resolving' {
            Invoke-FabricGitCommit -WorkspaceId $workspaceId -WorkspaceHead 'given' -Confirm:$false

            Should -Invoke -CommandName Get-FabricGitStatus -Times 0 -Exactly
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                ($Body | ConvertFrom-Json).workspaceHead -eq 'given'
            }
        }

        It 'Should not resolve the head with -NoAutoResolve' {
            Invoke-FabricGitCommit -WorkspaceId $workspaceId -NoAutoResolve -Confirm:$false

            Should -Invoke -CommandName Get-FabricGitStatus -Times 0 -Exactly
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $null -eq ($Body | ConvertFrom-Json).workspaceHead
            }
        }

        It 'Should commit piped items selectively in one call' {
            @(
                [pscustomobject]@{ WorkspaceId = $workspaceId; ObjectId = 'o1'; LogicalId = 'l1' }
                [pscustomobject]@{ WorkspaceId = $workspaceId; ObjectId = 'o2'; LogicalId = $null }
            ) | Invoke-FabricGitCommit -Comment 'some' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $b = $Body | ConvertFrom-Json
                $b.mode -eq 'Selective' -and
                @($b.items).Count -eq 2 -and
                $b.items[0].objectId -eq 'o1' -and $b.items[0].logicalId -eq 'l1' -and
                $b.items[1].objectId -eq 'o2' -and $null -eq $b.items[1].logicalId
            }
        }

        It 'Should accept raw changes with itemMetadata' {
            $change = [pscustomobject]@{
                itemMetadata = [pscustomobject]@{ itemIdentifier = [pscustomobject]@{ objectId = 'o9'; logicalId = 'l9' } }
            }
            Invoke-FabricGitCommit -WorkspaceId $workspaceId -Item $change -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $b = $Body | ConvertFrom-Json
                $b.mode -eq 'Selective' -and $b.items[0].objectId -eq 'o9'
            }
        }

        It 'Should commit all when a workspace object is piped' {
            [pscustomobject]@{ id = $workspaceId; displayName = 'Sales' } | Invoke-FabricGitCommit -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -eq "workspaces/$workspaceId/git/commitToGit" -and ($Body | ConvertFrom-Json).mode -eq 'All'
            }
        }

        It 'Should throw for an item without identifiers' {
            { Invoke-FabricGitCommit -WorkspaceId $workspaceId -Item ([pscustomobject]@{ Name = 'x' }) -Confirm:$false } |
                Should -Throw '*no ObjectId or LogicalId*'
        }

        It 'Should not call the API with -WhatIf' {
            Invoke-FabricGitCommit -WorkspaceId $workspaceId -WhatIf

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0 -Exactly
            Should -Invoke -CommandName Get-FabricGitStatus -Times 0 -Exactly
        }
    }

    Context 'When the API call fails' {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { throw 'API request failed with status code 400.' }
        }

        It 'Should warn and rethrow' {
            { Invoke-FabricGitCommit -WorkspaceId ([guid]::NewGuid()) -WorkspaceHead 'h' -Confirm:$false } | Should -Throw '*400*'

            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Warning' -and $Message -like '*Get-FabricGitStatus*' }
        }
    }
}
