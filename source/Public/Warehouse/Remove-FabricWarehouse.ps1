<#
.SYNOPSIS
    Removes a warehouse from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a DELETE request to the Microsoft Fabric API to remove a warehouse
    from the specified workspace using the provided WorkspaceId and WarehouseId.

.PARAMETER WorkspaceId
    The unique identifier of the workspace from which the warehouse will be removed.

.PARAMETER WarehouseId
    The unique identifier of the warehouse to be removed.

.EXAMPLE
    Remove-FabricWarehouse -WorkspaceId "workspace-12345" -WarehouseId "warehouse-67890"
    This example removes the warehouse with ID "warehouse-67890" from the workspace with ID "workspace-12345".

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch
#>
function Remove-FabricWarehouse
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WarehouseId
    )
    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointURI = "workspaces/{0}/warehouses/{1}" -f $WorkspaceId, $WarehouseId

        if ($PSCmdlet.ShouldProcess($apiEndpointURI, "Delete Warehouse"))
        {
            # Step 3: Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointURI `
                -method Delete `
        }

        Write-Message -Message "Warehouse '$WarehouseId' deleted successfully from workspace '$WorkspaceId'." -Level Info
        return $response

    }
    catch
    {
        # Step 5: Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete Warehouse '$WarehouseId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
