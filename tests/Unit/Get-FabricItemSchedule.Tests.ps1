#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $PSDefaultParameterValues['Mock:ModuleName'] = 'FabricTools'
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = 'FabricTools'
}

Describe 'Get-FabricItemSchedule' -Tag 'UnitTests' {
    It 'Lists schedules for the item and job type' {
        InModuleScope FabricTools {
            Mock Invoke-FabricRestMethod { @() }
            $ws = [guid]::NewGuid()
            $item = [guid]::NewGuid()
            Get-FabricItemSchedule -WorkspaceId $ws -ItemId $item -JobType Pipeline | Out-Null
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -eq "workspaces/$ws/items/$item/jobs/Pipeline/schedules" -and $ExtractValue -eq 'True' -and $HandleResponse
            }
        }
    }
}
