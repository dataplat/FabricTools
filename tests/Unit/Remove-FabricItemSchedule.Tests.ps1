#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $PSDefaultParameterValues['Mock:ModuleName'] = 'FabricTools'
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = 'FabricTools'
}

Describe 'Remove-FabricItemSchedule' -Tag 'UnitTests' {
    It 'Deletes a schedule and honors WhatIf' {
        InModuleScope FabricTools {
            Mock Invoke-FabricRestMethod { }
            $ws = [guid]::NewGuid()
            $item = [guid]::NewGuid()
            $schedule = [guid]::NewGuid()
            Remove-FabricItemSchedule -WorkspaceId $ws -ItemId $item -JobType Pipeline -ScheduleId $schedule -Confirm:$false
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -eq "workspaces/$ws/items/$item/jobs/Pipeline/schedules/$schedule" -and $Method -eq 'Delete' -and $HandleResponse
            }
            Remove-FabricItemSchedule -WorkspaceId $ws -ItemId $item -JobType Pipeline -ScheduleId $schedule -WhatIf
            Should -Invoke Invoke-FabricRestMethod -Times 1
        }
    }
}
