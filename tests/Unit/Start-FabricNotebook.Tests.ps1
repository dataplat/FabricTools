#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe 'Start-FabricNotebook' -Tag 'UnitTests' {
    BeforeEach {
        InModuleScope -ModuleName FabricTools {
            $script:workspaceId = [guid]'11111111-1111-1111-1111-111111111111'
            $script:notebookId = [guid]'22222222-2222-2222-2222-222222222222'
            $script:jobLocation = "https://api.fabric.microsoft.com/v1/workspaces/$workspaceId/items/$notebookId/jobs/instances/33333333-3333-3333-3333-333333333333"
            $script:submission = [pscustomobject]@{
                Location = @($jobLocation)
                RetryAfter = @('2')
                OperationId = $null
            }
            $script:notebooks = @([pscustomobject]@{ Id = $notebookId; DisplayName = 'Daily load' })
            $script:jobs = [System.Collections.Queue]::new()
            $script:jobs.Enqueue([pscustomobject]@{ id = 'job-id'; status = 'Completed' })
            $script:pollHeaders = @{ 'Retry-After' = @('7') }
            Mock Start-Sleep {}
            Mock Invoke-FabricRestMethod {
                if ($Method -eq 'Post') {
                    return $script:submission
                }
                if ($Uri -like '*/notebooks') {
                    return $script:notebooks
                }
                $script:responseHeader = $script:pollHeaders
                return $script:jobs.Dequeue()
            }
        }
    }

    It 'Requires WorkspaceId and exactly one notebook identifier' {
        $command = Get-Command Start-FabricNotebook
        $command | Should -HaveParameter WorkspaceId -Mandatory
        $command | Should -HaveParameter WhatIf
        $command | Should -HaveParameter NoWait
        $sets = @($command.ParameterSets | Where-Object { $_.Name -in @('ById', 'ByName') })
        $sets.Count | Should -Be 2
        foreach ($set in $sets) {
            $identifiers = @($set.Parameters | Where-Object { $_.Name -in @('NotebookId', 'NotebookName') })
            $identifiers.Count | Should -Be 1
            $identifiers[0].IsMandatory | Should -BeTrue
        }
    }

    It 'Rejects both identifiers before making any request' {
        InModuleScope -ModuleName FabricTools {
            { Start-FabricNotebook -WorkspaceId $workspaceId -NotebookId $notebookId -NotebookName 'Daily load' } | Should -Throw
            Should -Invoke Invoke-FabricRestMethod -Times 0
        }
    }

    It 'Submits RunNotebook and returns the completed job by default' {
        InModuleScope -ModuleName FabricTools {
            $result = Start-FabricNotebook -WorkspaceId $workspaceId -NotebookId $notebookId
            $result.status | Should -Be 'Completed'
            @($result).Count | Should -Be 1
            Should -Invoke Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Method -eq 'Post' -and
                $Uri -eq "workspaces/$workspaceId/items/$notebookId/jobs/instances?jobType=RunNotebook" -and
                $HandleResponse -and $NoWait -and $TestTokenExpired
            }
            Should -Invoke Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Method -eq 'Get' -and $Uri -eq $jobLocation -and $HandleResponse -and
                $ExtractValue -eq 'False' -and $TestTokenExpired
            }
            Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 2 }
        }
    }

    It 'Resolves a unique exact name in the specified workspace' {
        InModuleScope -ModuleName FabricTools {
            $script:notebooks += [pscustomobject]@{ Id = [guid]::NewGuid(); DisplayName = 'Daily load backup' }
            Start-FabricNotebook -WorkspaceId $workspaceId -NotebookName 'Daily load'
            Should -Invoke Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Method -eq 'Get' -and $Uri -eq "workspaces/$workspaceId/notebooks" -and
                $ExtractValue -eq 'True' -and $HandleResponse
            }
            Should -Invoke Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Method -eq 'Post' -and $Uri -like "*/items/$notebookId/*"
            }
        }
    }

    It 'Rejects a missing notebook name' {
        InModuleScope -ModuleName FabricTools {
            $script:notebooks = @()
            { Start-FabricNotebook -WorkspaceId $workspaceId -NotebookName 'Missing' } | Should -Throw '*not found*'
            Should -Invoke Invoke-FabricRestMethod -Times 0 -ParameterFilter { $Method -eq 'Post' }
        }
    }

    It 'Rejects ambiguous notebook names rather than selecting the first match' {
        InModuleScope -ModuleName FabricTools {
            $script:notebooks += [pscustomobject]@{ Id = [guid]::NewGuid(); DisplayName = 'Daily load' }
            { Start-FabricNotebook -WorkspaceId $workspaceId -NotebookName 'Daily load' } | Should -Throw '*ambiguous*'
            Should -Invoke Invoke-FabricRestMethod -Times 0 -ParameterFilter { $Method -eq 'Post' }
        }
    }

    It 'Makes no requests for WhatIf with an ID' {
        InModuleScope -ModuleName FabricTools {
            Start-FabricNotebook -WorkspaceId $workspaceId -NotebookId $notebookId -WhatIf
            Should -Invoke Invoke-FabricRestMethod -Times 0
            Should -Invoke Start-Sleep -Times 0
        }
    }

    It 'Resolves the name but does not submit for WhatIf' {
        InModuleScope -ModuleName FabricTools {
            Start-FabricNotebook -WorkspaceId $workspaceId -NotebookName 'Daily load' -WhatIf
            Should -Invoke Invoke-FabricRestMethod -Times 1 -Exactly
            Should -Invoke Invoke-FabricRestMethod -Times 0 -ParameterFilter { $Method -eq 'Post' }
        }
    }

    It 'Returns the current job immediately with NoWait' {
        InModuleScope -ModuleName FabricTools {
            $script:jobs.Clear()
            $script:jobs.Enqueue([pscustomobject]@{ id = 'job-id'; status = 'NotStarted' })
            $result = Start-FabricNotebook -WorkspaceId $workspaceId -NotebookId $notebookId -NoWait
            $result.id | Should -Be 'job-id'
            $result.status | Should -Be 'NotStarted'
            Should -Invoke Start-Sleep -Times 0
            Should -Invoke Invoke-FabricRestMethod -Times 2 -Exactly
        }
    }

    It 'Polls queued and running jobs and honors updated Retry-After headers' {
        InModuleScope -ModuleName FabricTools {
            $script:jobs.Clear()
            foreach ($status in @('NotStarted', 'InProgress', 'Completed')) {
                $script:jobs.Enqueue([pscustomobject]@{ id = 'job-id'; status = $status })
            }
            $result = Start-FabricNotebook -WorkspaceId $workspaceId -NotebookId $notebookId
            $result.status | Should -Be 'Completed'
            Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 2 }
            Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 7 }
        }
    }

    It 'Stops at terminal status <Status>' -ForEach @(
        @{ Status = 'Completed' }
        @{ Status = 'Deduped' }
        @{ Status = 'Failed' }
        @{ Status = 'Cancelled' }
    ) {
        InModuleScope -ModuleName FabricTools -Parameters @{ Status = $Status } {
            param($Status)
            $script:jobs.Clear()
            $script:jobs.Enqueue([pscustomobject]@{
                id = 'job-id'
                status = $Status
                failureReason = @{ errorCode = 'ExecutionError'; message = 'Notebook execution failed' }
            })
            $jobErrors = @()
            $result = Start-FabricNotebook -WorkspaceId $workspaceId -NotebookId $notebookId -ErrorAction SilentlyContinue -ErrorVariable jobErrors
            $result.status | Should -Be $Status
            Should -Invoke Invoke-FabricRestMethod -Times 2 -Exactly
            if ($Status -in @('Failed', 'Cancelled')) {
                $jobErrors.Count | Should -Be 1
                $jobErrors[0].ToString() | Should -BeLike '*ExecutionError*'
                $jobErrors[0].ToString() | Should -BeLike '*Notebook execution failed*'
                $jobErrors[0].TargetObject.status | Should -Be $Status
            } else {
                $jobErrors.Count | Should -Be 0
            }
        }
    }

    It 'Allows callers to treat execution failures as terminating errors' {
        InModuleScope -ModuleName FabricTools {
            $script:jobs.Clear()
            $script:jobs.Enqueue([pscustomobject]@{ status = 'Failed'; failureReason = @{ message = 'Spark failed' } })
            { Start-FabricNotebook -WorkspaceId $workspaceId -NotebookId $notebookId -ErrorAction Stop } | Should -Throw '*Spark failed*'
        }
    }

    It 'Uses a safe fallback for missing or invalid Retry-After: <Header>' -ForEach @(
        @{ Header = $null }
        @{ Header = 'invalid' }
        @{ Header = '-1' }
    ) {
        InModuleScope -ModuleName FabricTools -Parameters @{ Header = $Header } {
            param($Header)
            $script:submission.RetryAfter = $Header
            Start-FabricNotebook -WorkspaceId $workspaceId -NotebookId $notebookId
            Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 5 }
        }
    }

    It 'Supports scalar zero Retry-After values' {
        InModuleScope -ModuleName FabricTools {
            $script:submission.RetryAfter = '0'
            Start-FabricNotebook -WorkspaceId $workspaceId -NotebookId $notebookId
            Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 0 }
        }
    }

    It 'Supports HTTP-date Retry-After values' {
        InModuleScope -ModuleName FabricTools {
            $script:submission.RetryAfter = [DateTimeOffset]::UtcNow.AddSeconds(60).ToString('r')
            Start-FabricNotebook -WorkspaceId $workspaceId -NotebookId $notebookId
            Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -gt 0 -and $Seconds -le 60 }
        }
    }

    It 'Rejects a submission without a job-instance URL' {
        InModuleScope -ModuleName FabricTools {
            $script:submission.Location = $null
            { Start-FabricNotebook -WorkspaceId $workspaceId -NotebookId $notebookId } | Should -Throw '*Location*'
            Should -Invoke Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }

    It 'Rejects a malformed job-instance response' {
        InModuleScope -ModuleName FabricTools {
            $script:jobs.Clear()
            $script:jobs.Enqueue([pscustomobject]@{ id = 'job-id' })
            { Start-FabricNotebook -WorkspaceId $workspaceId -NotebookId $notebookId } | Should -Throw '*status*'
        }
    }

    It 'Propagates submission failures without polling' {
        InModuleScope -ModuleName FabricTools {
            Mock Invoke-FabricRestMethod { throw 'Submission failed' } -ParameterFilter { $Method -eq 'Post' }
            { Start-FabricNotebook -WorkspaceId $workspaceId -NotebookId $notebookId } | Should -Throw '*Submission failed*'
            Should -Invoke Start-Sleep -Times 0
        }
    }

    It 'Propagates polling failures rather than looping forever' {
        InModuleScope -ModuleName FabricTools {
            Mock Invoke-FabricRestMethod { throw 'Job lookup failed' } -ParameterFilter { $Uri -like '*/jobs/instances/*' }
            { Start-FabricNotebook -WorkspaceId $workspaceId -NotebookId $notebookId } | Should -Throw '*Job lookup failed*'
        }
    }

    It 'Handles a real 202 response without an operation ID or generic LRO polling' {
        InModuleScope -ModuleName FabricTools {
            Mock Write-Message {}
            Mock Get-FabricLongRunningOperation { throw 'Must not use LRO polling' }
            Mock Get-FabricLongRunningOperationResult { throw 'Must not use LRO results' }
            Mock Invoke-FabricRestMethod {
                if ($Method -eq 'Post') {
                    Test-FabricApiResponse -StatusCode 202 -ResponseHeader @{
                        Location = @($script:jobLocation)
                        'Retry-After' = @('2')
                    } -NoWait:$NoWait -Operation Start
                } else {
                    $script:responseHeader = @{}
                    Test-FabricApiResponse -StatusCode 200 -ResponseHeader @{} -Response (
                        [pscustomobject]@{ id = 'job-id'; status = 'Completed' }
                    ) -Operation Get
                }
            }
            $result = Start-FabricNotebook -WorkspaceId $workspaceId -NotebookId $notebookId
            $result.status | Should -Be 'Completed'
            Should -Invoke Get-FabricLongRunningOperation -Times 0
            Should -Invoke Get-FabricLongRunningOperationResult -Times 0
        }
    }
}
