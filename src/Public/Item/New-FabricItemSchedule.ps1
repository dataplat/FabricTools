function New-FabricItemSchedule {
    <#
    .SYNOPSIS
        Creates a schedule for a Fabric item.

    .DESCRIPTION
        Creates a Cron, Daily, or Weekly schedule for an item job type.

    .PARAMETER WorkspaceId
        The ID of the workspace containing the item.

    .PARAMETER ItemId
        The ID of the item for which the schedule is created.

    .PARAMETER JobType
        The job type, such as Pipeline or RunNotebook.

    .PARAMETER ScheduleType
        The configuration type: Cron, Daily, or Weekly.

    .PARAMETER IntervalMinutes
        The Cron interval in minutes.

    .PARAMETER Times
        The local execution times for a Daily or Weekly schedule.

    .PARAMETER Weekdays
        The weekdays for a Weekly schedule.

    .PARAMETER StartDateTime
        The date and time when the schedule becomes active.

    .PARAMETER EndDateTime
        The date and time when the schedule expires.

    .PARAMETER TimeZone
        The time zone used by the schedule, as a Windows time zone ID.

    .PARAMETER Enabled
        Creates the schedule enabled. Defaults to true.

    .EXAMPLE
        ```powershell
        New-FabricItemSchedule -WorkspaceId '11111111-1111-1111-1111-111111111111' -ItemId '22222222-2222-2222-2222-222222222222' -JobType Pipeline -ScheduleType Daily -Times '08:00' -StartDateTime '2026-11-09T00:00:00' -EndDateTime '2026-12-31T23:59:59' -TimeZone 'UTC'
        ```

    .NOTES
        https://learn.microsoft.com/en-us/rest/api/fabric/core/job-scheduler/create-item-schedule

        Author: Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [guid]$ItemId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$JobType,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Cron', 'Daily', 'Weekly')]
        [string]$ScheduleType,

        [Parameter()]
        [ValidateRange(1, 1440)]
        [int]$IntervalMinutes,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]$Times,

        [Parameter()]
        [ValidateSet('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')]
        [string[]]$Weekdays,

        [Parameter(Mandatory = $true)]
        [DateTimeOffset]$StartDateTime,

        [Parameter(Mandatory = $true)]
        [DateTimeOffset]$EndDateTime,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TimeZone,

        [Parameter()]
        [bool]$Enabled = $true
    )

    if ($EndDateTime -le $StartDateTime) {
        throw 'EndDateTime must be later than StartDateTime.'
    }
    switch ($ScheduleType) {
        'Cron' {
            if (-not $PSBoundParameters.ContainsKey('IntervalMinutes')) {
                throw 'IntervalMinutes is required for a Cron schedule.'
            }
            $configuration = @{ type = 'Cron'; interval = $IntervalMinutes }
        }
        'Daily' {
            if (-not $Times) {
                throw 'Times is required for a Daily schedule.'
            }
            $configuration = @{ type = 'Daily'; times = @($Times) }
        }
        'Weekly' {
            if (-not $Times -or -not $Weekdays) {
                throw 'Times and Weekdays are required for a Weekly schedule.'
            }
            $configuration = @{ type = 'Weekly'; weekdays = @($Weekdays); times = @($Times) }
        }
    }

    $body = @{
        enabled         = $Enabled
        configuration   = $configuration
        startDateTime   = $StartDateTime.ToString('o')
        endDateTime     = $EndDateTime.ToString('o')
        localTimeZoneId = $TimeZone
    }
    if (-not $PSCmdlet.ShouldProcess("Schedule for item '$ItemId' ($JobType)", 'Create schedule')) {
        return
    }

    $apiParams = @{
        Uri              = "workspaces/$WorkspaceId/items/$ItemId/jobs/$([uri]::EscapeDataString($JobType))/schedules"
        Method           = 'Post'
        Body             = $body
        TypeName         = 'Item schedule'
        ObjectIdOrName   = $ItemId
        HandleResponse   = $true
        TestTokenExpired = $true
    }
    Invoke-FabricRestMethod @apiParams
}
