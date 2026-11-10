#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $PSDefaultParameterValues['Mock:ModuleName'] = 'FabricTools'
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = 'FabricTools'
}

Describe 'New-FabricItemSchedule' -Tag 'UnitTests' {
    BeforeEach {
        InModuleScope FabricTools { Mock Invoke-FabricRestMethod { [pscustomobject]@{ id = 'schedule-id' } } }
    }

    It 'Creates a Cron configuration' {
        InModuleScope FabricTools {
            $ws = [guid]::NewGuid()
            $item = [guid]::NewGuid()
            New-FabricItemSchedule -WorkspaceId $ws -ItemId $item -JobType Pipeline -ScheduleType Cron -IntervalMinutes 30 -StartDateTime '2026-11-09T00:00:00Z' -EndDateTime '2026-11-10T00:00:00Z' -TimeZone UTC -Confirm:$false
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Method -eq 'Post' -and $Uri -eq "workspaces/$ws/items/$item/jobs/Pipeline/schedules" -and
                $Body.configuration.type -eq 'Cron' -and $Body.configuration.interval -eq 30
            }
        }
    }

    It 'Creates Daily and Weekly recurrence configurations' -ForEach @(
        @{ Type = 'Daily'; Times = @('08:00'); Weekdays = @() }
        @{ Type = 'Weekly'; Times = @('08:00', '16:00'); Weekdays = @('Monday', 'Friday') }
    ) {
        InModuleScope FabricTools -Parameters @{ Type = $Type; Times = $Times; Weekdays = $Weekdays } {
            param($Type, $Times, $Weekdays)
            $ws = [guid]::NewGuid()
            $item = [guid]::NewGuid()
            $params = @{
                WorkspaceId = $ws
                ItemId = $item
                JobType = 'Pipeline'
                ScheduleType = $Type
                Times = $Times
                StartDateTime = '2026-11-09T00:00:00Z'
                EndDateTime = '2026-11-10T00:00:00Z'
                TimeZone = 'UTC'
                Confirm = $false
            }
            if ($Weekdays.Count) {
                $params.Weekdays = $Weekdays
            }
            New-FabricItemSchedule @params
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Body.configuration.type -eq $Type -and
                $Body.configuration.times.Count -eq $Times.Count
            }
        }
    }

    It 'Requires times and weekdays for a Weekly configuration' {
        InModuleScope FabricTools {
            { New-FabricItemSchedule -WorkspaceId ([guid]::NewGuid()) -ItemId ([guid]::NewGuid()) -JobType Pipeline -ScheduleType Weekly -StartDateTime '2026-11-09T00:00:00Z' -EndDateTime '2026-11-10T00:00:00Z' -TimeZone UTC -Confirm:$false } | Should -Throw '*Times and Weekdays*'
            Should -Invoke Invoke-FabricRestMethod -Times 0
        }
    }

    It 'Honors WhatIf' {
        InModuleScope FabricTools {
            New-FabricItemSchedule -WorkspaceId ([guid]::NewGuid()) -ItemId ([guid]::NewGuid()) -JobType Pipeline -ScheduleType Cron -IntervalMinutes 15 -StartDateTime '2026-11-09T00:00:00Z' -EndDateTime '2026-11-10T00:00:00Z' -TimeZone UTC -WhatIf
            Should -Invoke Invoke-FabricRestMethod -Times 0
        }
    }
}
