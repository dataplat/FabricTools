function Get-FabricItemSchedule {
    <#
    .SYNOPSIS
        Gets the schedules for a Fabric item.

    .DESCRIPTION
        Lists schedules for an item and job type.

    .PARAMETER WorkspaceId
        The ID of the workspace containing the item.

    .PARAMETER ItemId
        The ID of the item.

    .PARAMETER JobType
        The job type, such as Pipeline or RunNotebook.

    .EXAMPLE
        ```powershell
        Get-FabricItemSchedule -WorkspaceId '11111111-1111-1111-1111-111111111111' -ItemId '22222222-2222-2222-2222-222222222222' -JobType Pipeline
        ```
    #>
    [CmdletBinding()]
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
        [string]$JobType
    )

    $apiParams = @{
        Uri              = "workspaces/$WorkspaceId/items/$ItemId/jobs/$([uri]::EscapeDataString($JobType))/schedules"
        Method           = 'Get'
        TypeName         = 'Item schedule'
        ObjectIdOrName   = $ItemId
        HandleResponse   = $true
        ExtractValue     = 'True'
        TestTokenExpired = $true
    }
    @(Invoke-FabricRestMethod @apiParams)
}
