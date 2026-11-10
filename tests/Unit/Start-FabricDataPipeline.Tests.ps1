#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $PSDefaultParameterValues['Mock:ModuleName'] = 'FabricTools'
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = 'FabricTools'
}

Describe 'Start-FabricDataPipeline' -Tag 'UnitTests' {
    BeforeEach {
        InModuleScope FabricTools {
            $script:workspaceId = [guid]'11111111-1111-1111-1111-111111111111'
            $script:itemId = [guid]'22222222-2222-2222-2222-222222222222'
            $script:location = 'https://api.fabric.microsoft.com/v1/jobs/instances/job-id'
            $script:jobs = [System.Collections.Queue]::new()
            $script:jobs.Enqueue([pscustomobject]@{ id = 'job-id'; status = 'Completed' })
            Mock Start-Sleep {}
            Mock Invoke-FabricRestMethod {
                if ($Method -eq 'Post') { return [pscustomobject]@{ Location = $script:location; RetryAfter = '0' } }
                if ($Uri -like '*/dataPipelines') { return @([pscustomobject]@{ Id = $script:itemId; DisplayName = 'Daily' }) }
                $script:jobs.Dequeue()
            }
        }
    }

    It 'Submits Pipeline execution parameters and returns the completed job' {
        InModuleScope FabricTools {
            $parameters = @{ date = '2026-11-09' }
            $result = Start-FabricDataPipeline -WorkspaceId $workspaceId -DataPipelineId $itemId -Parameters $parameters
            $result.status | Should -Be 'Completed'
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Method -eq 'Post' -and
                $Uri -eq "workspaces/$workspaceId/items/$itemId/jobs/instances?jobType=Pipeline" -and
                $NoWait -and $Body.executionData.parameters.date -eq '2026-11-09'
            }
        }
    }

    It 'Resolves pipeline names and returns immediately with NoWait' {
        InModuleScope FabricTools {
            $script:jobs.Clear()
            $script:jobs.Enqueue([pscustomobject]@{ id = 'job-id'; status = 'NotStarted' })
            $result = Start-FabricDataPipeline -WorkspaceId $workspaceId -DataPipelineName Daily -NoWait
            $result.status | Should -Be 'NotStarted'
            Should -Invoke Start-Sleep -Times 0
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter { $Method -eq 'Get' -and $ExtractValue -eq 'True' }
        }
    }
}
