function Remove-FabricItemSchedule {
    <#
    .SYNOPSIS
        Removes a Fabric item schedule.

    .PARAMETER WorkspaceId
        The ID of the workspace containing the item.

    .PARAMETER ItemId
        The ID of the item.

    .PARAMETER JobType
        The job type, such as Pipeline or RunNotebook.

    .PARAMETER ScheduleId
        The ID of the schedule to remove.

    .EXAMPLE
        ```powershell
        Remove-FabricItemSchedule -WorkspaceId '11111111-1111-1111-1111-111111111111' -ItemId '22222222-2222-2222-2222-222222222222' -JobType Pipeline -ScheduleId '33333333-3333-3333-3333-333333333333'
        ```
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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
        [guid]$ScheduleId
    )

    if (-not $PSCmdlet.ShouldProcess("Schedule '$ScheduleId' for item '$ItemId'", 'Remove schedule')) {
        return
    }
    $apiParams = @{
        Uri              = "workspaces/$WorkspaceId/items/$ItemId/jobs/$([uri]::EscapeDataString($JobType))/schedules/$ScheduleId"
        Method           = 'Delete'
        TypeName         = 'Item schedule'
        ObjectIdOrName   = $ScheduleId
        HandleResponse   = $true
        TestTokenExpired = $true
    }
    Invoke-FabricRestMethod @apiParams
}
