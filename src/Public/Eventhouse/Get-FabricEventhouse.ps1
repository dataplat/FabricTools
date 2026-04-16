function Get-FabricEventhouse {
    <#
    .SYNOPSIS
        Retrieves Fabric Eventhouses

    .DESCRIPTION
        Retrieves Fabric Eventhouses. Without the EventhouseName or EventhouseID parameter, all Eventhouses are returned.
        If you want to retrieve a specific Eventhouse, you can use the EventhouseName or EventhouseID parameter. These
        parameters cannot be used together.

    .PARAMETER WorkspaceId
        Id of the Fabric Workspace for which the Eventhouses should be retrieved. The value for WorkspaceId is a GUID.
        An example of a GUID is '12345678-1234-1234-1234-123456789012'.

    .PARAMETER EventhouseName
        The name of the Eventhouse to retrieve. This parameter cannot be used together with EventhouseID.

    .PARAMETER EventhouseId
        The Id of the Eventhouse to retrieve. This parameter cannot be used together with EventhouseName. The value for WorkspaceId is a GUID.
        An example of a GUID is '12345678-1234-1234-1234-123456789012'.

    .EXAMPLE
    This example will give you all Eventhouses in the Workspace.

    ```powershell
    Get-FabricEventhouse -WorkspaceId '12345678-1234-1234-1234-123456789012'
    ```

    .EXAMPLE
    This example will give you all Information about the Eventhouse with the name 'MyEventhouse'.

    ```powershell
    Get-FabricEventhouse -WorkspaceId '12345678-1234-1234-1234-123456789012' -EventhouseName 'MyEventhouse'
    ```

    .EXAMPLE
    This example will give you all Information about the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'.

    ```powershell
    Get-FabricEventhouse -WorkspaceId '12345678-1234-1234-1234-123456789012' -EventhouseId '12345678-1234-1234-1234-123456789012'
    ```

    .LINK
        https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP

    .NOTES
        TODO: Add functionality to list all Eventhouses in the subscription. To do so fetch all workspaces
        and then all eventhouses in each workspace.

        Author: Tiago Balabuch, Kamil Nowinski

        #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$EventhouseId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EventhouseName
    )

    # Handle ambiguous input
    if ($EventhouseId -and $EventhouseName) {
        Write-Message -Message "Both 'EventhouseId' and 'EventhouseName' were provided. Please specify only one." -Level Error
        return $null
    }

    try {
        # Ensure token validity
        Confirm-TokenState

        $apiParams = @{
            Uri            = "workspaces/$WorkspaceId/eventhouses"
            Method         = 'Get'
            TypeName       = 'Eventhouse'
            ObjectIdOrName = $EventhouseName
            HandleResponse = $true
            ExtractValue   = 'True'
        }

        $eventhouses = @(Invoke-FabricRestMethod @apiParams)

        if ($EventhouseId) {
            $eventhouses | Where-Object { $_.Id -eq $EventhouseId }
        } elseif ($EventhouseName) {
            $eventhouses | Where-Object { $_.DisplayName -eq $EventhouseName }
        } else {
            $eventhouses
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Eventhouse. Error: $errorDetails" -Level Error
    }
}
