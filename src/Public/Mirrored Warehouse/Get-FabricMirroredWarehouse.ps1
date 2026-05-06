function Get-FabricMirroredWarehouse {
    <#
.SYNOPSIS
Retrieves an MirroredWarehouse or a list of MirroredWarehouses from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Get-FabricMirroredWarehouse` function sends a GET request to the Fabric API to retrieve MirroredWarehouse details for a given workspace. It can filter the results by `MirroredWarehouseName`.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace to query MirroredWarehouses.

.PARAMETER MirroredWarehouseId
(Optional) The ID of a specific MirroredWarehouse to retrieve.

.PARAMETER MirroredWarehouseName
(Optional) The name of the specific MirroredWarehouse to retrieve.

.EXAMPLE
    Retrieves the "Development" MirroredWarehouse from workspace "12345".

    ```powershell
    Get-FabricMirroredWarehouse -WorkspaceId "12345" -MirroredWarehouseName "Development"
    ```

.EXAMPLE
    Retrieves all MirroredWarehouses in workspace "12345".

    ```powershell
    Get-FabricMirroredWarehouse -WorkspaceId "12345"
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$MirroredWarehouseId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$MirroredWarehouseName
    )

    try {
        # Handle ambiguous input
        if ($MirroredWarehouseId -and $MirroredWarehouseName) {
            Write-Message -Message "Both 'MirroredWarehouseId' and 'MirroredWarehouseName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/MirroredWarehouses"
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Make the API request
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            ExtractValue   = 'True'
            HandleResponse = $true
        }
        $MirroredWarehouses = @(Invoke-FabricRestMethod @apiParams)


        # Filter results based on provided parameters
        $MirroredWarehouse = if ($MirroredWarehouseId) {
            $MirroredWarehouses | Where-Object { $_.Id -eq $MirroredWarehouseId }
        } elseif ($MirroredWarehouseName) {
            $MirroredWarehouses | Where-Object { $_.DisplayName -eq $MirroredWarehouseName }
        } else {
            # Return all MirroredWarehouses if no filter is provided
            Write-Message -Message "No filter provided. Returning all MirroredWarehouses." -Level Debug
            $MirroredWarehouses
        }

        # Handle results
        if ($MirroredWarehouse) {
            Write-Message -Message "MirroredWarehouse found matching the specified criteria." -Level Debug
            return $MirroredWarehouse
        } else {
            Write-Message -Message "No MirroredWarehouse found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve MirroredWarehouse. Error: $errorDetails" -Level Error
    }

}
