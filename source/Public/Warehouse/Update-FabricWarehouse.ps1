<#
.SYNOPSIS
    Updates an existing warehouse in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a PATCH request to the Microsoft Fabric API to update an existing warehouse
    in the specified workspace. It supports optional parameters for warehouse description.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the warehouse exists. This parameter is optional.

.PARAMETER WarehouseId
    The unique identifier of the warehouse to be updated. This parameter is mandatory.

.PARAMETER WarehouseName
    The new name of the warehouse. This parameter is mandatory.

.PARAMETER WarehouseDescription
    An optional new description for the warehouse.

.EXAMPLE
    This example updates the warehouse with ID "warehouse-67890" in the workspace with ID "workspace-12345" with a new name and description.

    ```powershell
    Update-FabricWarehouse -WorkspaceId "workspace-12345" -WarehouseId "warehouse-67890" -WarehouseName "Updated Warehouse" -WarehouseDescription "Updated description"
    ```

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch

#>
function Update-FabricWarehouse
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WarehouseId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WarehouseName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$WarehouseDescription
    )

    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointURI = "workspaces/{0}/warehouses/{1}" -f $WorkspaceId, $WarehouseId

        # Step 3: Construct the request body
        $body = @{
            displayName = $WarehouseName
        }

        if ($WarehouseDescription)
        {
            $body.description = $WarehouseDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointURI, "Update Warehouse"))
        {
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointURI `
                -method Patch `
                -body $bodyJson
        }

        # Step 6: Handle results
        Write-Message -Message "Warehouse '$WarehouseName' updated successfully!" -Level Info
        return $response
    }
    catch
    {
        # Step 7: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update Warehouse. Error: $errorDetails" -Level Error
    }
}
