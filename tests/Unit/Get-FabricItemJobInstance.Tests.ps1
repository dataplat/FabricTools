#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $PSDefaultParameterValues['Mock:ModuleName'] = 'FabricTools'
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = 'FabricTools'
}

Describe 'Get-FabricItemJobInstance' -Tag 'UnitTests' {
    BeforeEach {
        InModuleScope FabricTools { Mock Invoke-FabricRestMethod { [pscustomobject]@{ status = 'Completed' } } }
    }

    It 'Gets a specific item job instance' {
        InModuleScope FabricTools {
            $ws = [guid]::NewGuid()
            $item = [guid]::NewGuid()
            $job = [guid]::NewGuid()
            Get-FabricItemJobInstance -WorkspaceId $ws -ItemId $item -JobType Pipeline -JobInstanceId $job | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -eq "workspaces/$ws/items/$item/jobs/instances/$job`?jobType=Pipeline" -and $Method -eq 'Get'
            }
        }
    }

    It 'Lists recent instances by job type' {
        InModuleScope FabricTools {
            $ws = [guid]::NewGuid()
            $item = [guid]::NewGuid()
            Get-FabricItemJobInstance -WorkspaceId $ws -ItemId $item -JobType RunNotebook | Out-Null
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -eq "workspaces/$ws/items/$item/jobs/instances?jobType=RunNotebook" -and $ExtractValue -eq 'True'
            }
        }
    }
}
