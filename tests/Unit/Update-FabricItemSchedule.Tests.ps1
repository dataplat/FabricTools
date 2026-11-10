#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $PSDefaultParameterValues['Mock:ModuleName'] = 'FabricTools'
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = 'FabricTools'
}

Describe 'Update-FabricItemSchedule' -Tag 'UnitTests' {
    It 'Updates only the enabled state' {
        InModuleScope FabricTools {
            Mock Invoke-FabricRestMethod { }
            $ws = [guid]::NewGuid()
            $item = [guid]::NewGuid()
            $schedule = [guid]::NewGuid()
            Update-FabricItemSchedule -WorkspaceId $ws -ItemId $item -JobType Pipeline -ScheduleId $schedule -Enabled $false -Confirm:$false
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Method -eq 'Patch' -and $Uri -eq "workspaces/$ws/items/$item/jobs/Pipeline/schedules/$schedule" -and
                $Body.ContainsKey('enabled') -and $Body.enabled -eq $false
            }
        }
    }

    It 'Requires an update property' {
        InModuleScope FabricTools {
            { Update-FabricItemSchedule -WorkspaceId ([guid]::NewGuid()) -ItemId ([guid]::NewGuid()) -JobType Pipeline -ScheduleId ([guid]::NewGuid()) -Confirm:$false } | Should -Throw '*Specify at least one*'
        }
    }

    It 'Replaces the complete weekly configuration' {
        InModuleScope FabricTools {
            Mock Invoke-FabricRestMethod { }
            $ws = [guid]::NewGuid()
            $item = [guid]::NewGuid()
            $schedule = [guid]::NewGuid()
            Update-FabricItemSchedule -WorkspaceId $ws -ItemId $item -JobType Pipeline -ScheduleId $schedule -ScheduleType Weekly -Weekdays Monday,Friday -Times '08:00' -Confirm:$false
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Body.configuration.type -eq 'Weekly' -and
                $Body.configuration.weekdays.Count -eq 2 -and
                $Body.configuration.times[0] -eq '08:00'
            }
        }
    }
}
