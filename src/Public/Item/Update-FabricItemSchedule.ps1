function Update-FabricItemSchedule {
    <#
    .SYNOPSIS
        Updates a Fabric item schedule.

    .DESCRIPTION
        Enables or disables a schedule, and optionally updates its configuration or date range.

    .PARAMETER WorkspaceId
        The ID of the workspace containing the item.

    .PARAMETER ItemId
        The ID of the item.

    .PARAMETER JobType
        The job type, such as Pipeline or RunNotebook.

    .PARAMETER ScheduleId
        The ID of the schedule to update.

    .PARAMETER Enabled
        Enables or disables the schedule.

    .PARAMETER ScheduleType
        The replacement configuration type: Cron, Daily, or Weekly.

    .PARAMETER IntervalMinutes
        The Cron interval in minutes.

    .PARAMETER Times
        The local execution times for a Daily or Weekly schedule.

    .PARAMETER Weekdays
        The weekdays for a Weekly schedule.

    .PARAMETER StartDateTime
        The updated start date and time.

    .PARAMETER EndDateTime
        The updated end date and time.

    .PARAMETER TimeZone
        The updated Windows time zone ID.

    .EXAMPLE
        Update-FabricItemSchedule -WorkspaceId '11111111-1111-1111-1111-111111111111' -ItemId '22222222-2222-2222-2222-222222222222' -JobType Pipeline -ScheduleId '33333333-3333-3333-3333-333333333333' -Enabled $false
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$ItemId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$JobType,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$ScheduleId,

        [Parameter()]
        [bool]$Enabled,

        [Parameter()]
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

        [Parameter()]
        [DateTimeOffset]$StartDateTime,

        [Parameter()]
        [DateTimeOffset]$EndDateTime,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$TimeZone
    )

    $body = @{}
    if ($PSBoundParameters.ContainsKey('Enabled')) {
        $body.enabled = $Enabled
    }
    $configurationWasSpecified = $PSBoundParameters.ContainsKey('IntervalMinutes') -or
        $PSBoundParameters.ContainsKey('Times') -or $PSBoundParameters.ContainsKey('Weekdays')
    if ($configurationWasSpecified -and -not $ScheduleType) {
        throw 'ScheduleType is required when changing schedule configuration.'
    }
    if ($ScheduleType) {
        switch ($ScheduleType) {
            'Cron' {
                if (-not $PSBoundParameters.ContainsKey('IntervalMinutes')) {
                    throw 'IntervalMinutes is required for a Cron schedule.'
                }
                $body.configuration = @{ type = 'Cron'; interval = $IntervalMinutes }
            }
            'Daily' {
                if (-not $Times) {
                    throw 'Times is required for a Daily schedule.'
                }
                $body.configuration = @{ type = 'Daily'; times = @($Times) }
            }
            'Weekly' {
                if (-not $Times -or -not $Weekdays) {
                    throw 'Times and Weekdays are required for a Weekly schedule.'
                }
                $body.configuration = @{ type = 'Weekly'; weekdays = @($Weekdays); times = @($Times) }
            }
        }
    }
    if ($PSBoundParameters.ContainsKey('StartDateTime')) {
        $body.startDateTime = $StartDateTime.ToString('o')
    }
    if ($PSBoundParameters.ContainsKey('EndDateTime')) {
        $body.endDateTime = $EndDateTime.ToString('o')
    }
    if ($PSBoundParameters.ContainsKey('TimeZone')) {
        $body.localTimeZoneId = $TimeZone
    }
    if ($body.Count -eq 0) {
        throw 'Specify at least one schedule property to update.'
    }
    if ($PSBoundParameters.ContainsKey('StartDateTime') -and $PSBoundParameters.ContainsKey('EndDateTime') -and $EndDateTime -le $StartDateTime) {
        throw 'EndDateTime must be later than StartDateTime.'
    }
    if (-not $PSCmdlet.ShouldProcess("Schedule '$ScheduleId' for item '$ItemId'", 'Update schedule')) {
        return
    }

    $apiParams = @{
        Uri              = "workspaces/$WorkspaceId/items/$ItemId/jobs/$([uri]::EscapeDataString($JobType))/schedules/$ScheduleId"
        Method           = 'Patch'
        Body             = $body
        TypeName         = 'Item schedule'
        ObjectIdOrName   = $ScheduleId
        HandleResponse   = $true
        TestTokenExpired = $true
    }
    Invoke-FabricRestMethod @apiParams
}
