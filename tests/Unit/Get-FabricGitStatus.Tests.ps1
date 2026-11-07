#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe 'Get-FabricGitStatus' -Tag 'UnitTests' {

    BeforeAll {
        $command = Get-Command -Name Get-FabricGitStatus
    }

    Context 'Command definition' {
        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'NoWait'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should not allow ChangesOnly and ConflictsOnly together' {
            { Get-FabricGitStatus -WorkspaceId ([guid]::NewGuid()) -ChangesOnly -ConflictsOnly } | Should -Throw
        }
    }

    Context 'When the workspace has changes' {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                [pscustomobject]@{
                    workspaceHead    = 'w1'
                    remoteCommitHash = 'r1'
                    changes          = @(
                        [pscustomobject]@{
                            itemMetadata    = [pscustomobject]@{
                                itemIdentifier = [pscustomobject]@{ objectId = 'o1'; logicalId = 'l1' }
                                itemType       = 'Notebook'
                                displayName    = 'NB1'
                            }
                            workspaceChange = 'Modified'
                            remoteChange    = $null
                            conflictType    = 'None'
                        }
                        [pscustomobject]@{
                            itemMetadata    = [pscustomobject]@{
                                itemIdentifier = [pscustomobject]@{ objectId = 'o2'; logicalId = 'l2' }
                                itemType       = 'Report'
                                displayName    = 'RP1'
                            }
                            workspaceChange = 'Modified'
                            remoteChange    = 'Modified'
                            conflictType    = 'Conflict'
                        }
                    )
                }
            }
            $workspaceId = [guid]::NewGuid()
        }

        It 'Should call the status endpoint with GET' {
            Get-FabricGitStatus -WorkspaceId $workspaceId | Out-Null

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -eq "workspaces/$workspaceId/git/status" -and $Method -eq 'Get'
            }
        }

        It 'Should return the full status with WorkspaceId by default' {
            $result = Get-FabricGitStatus -WorkspaceId $workspaceId

            $result.workspaceHead | Should -Be 'w1'
            $result.remoteCommitHash | Should -Be 'r1'
            @($result.changes).Count | Should -Be 2
            $result.WorkspaceId | Should -Be $workspaceId
        }

        It 'Should flatten all changes with -ChangesOnly' {
            $result = @(Get-FabricGitStatus -WorkspaceId $workspaceId -ChangesOnly)

            $result.Count | Should -Be 2
            $result[0].ItemName | Should -Be 'NB1'
            $result[0].ItemType | Should -Be 'Notebook'
            $result[0].ObjectId | Should -Be 'o1'
            $result[0].LogicalId | Should -Be 'l1'
            $result[0].WorkspaceChange | Should -Be 'Modified'
            $result[0].WorkspaceId | Should -Be $workspaceId
        }

        It 'Should return only conflicts with -ConflictsOnly' {
            $result = @(Get-FabricGitStatus -WorkspaceId $workspaceId -ConflictsOnly)

            $result.Count | Should -Be 1
            $result[0].ItemName | Should -Be 'RP1'
            $result[0].ConflictType | Should -Be 'Conflict'
        }
    }

    Context 'When -NoWait returns an operation descriptor' {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                [pscustomobject]@{ OperationId = 'op1'; Location = 'https://x'; RetryAfter = '5' }
            }
        }

        It 'Should return the descriptor even with -ChangesOnly' {
            $result = Get-FabricGitStatus -WorkspaceId ([guid]::NewGuid()) -ChangesOnly -NoWait

            $result.OperationId | Should -Be 'op1'
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter { $NoWait }
        }
    }
}
