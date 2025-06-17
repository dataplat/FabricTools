<#
.SYNOPSIS
    Retrieves warehouse details from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function retrieves warehouse details from a specified workspace using either the provided WarehouseId or WarehouseName.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the warehouse exists. This parameter is mandatory.

.PARAMETER WarehouseId
    The unique identifier of the warehouse to retrieve. This parameter is optional.

.PARAMETER WarehouseName
    The name of the warehouse to retrieve. This parameter is optional.

.EXAMPLE
     Get-FabricWarehouse -WorkspaceId "workspace-12345" -WarehouseId "warehouse-67890"
    This example retrieves the warehouse details for the warehouse with ID "warehouse-67890" in the workspace with ID "workspace-12345".

.EXAMPLE
     Get-FabricWarehouse -WorkspaceId "workspace-12345" -WarehouseName "My Warehouse"
    This example retrieves the warehouse details for the warehouse named "My Warehouse" in the workspace with ID "workspace-12345".

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch
#>
function Get-FabricWarehouse {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$WarehouseId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$WarehouseName
    )

    try {
        # Step 1: Handle ambiguous input
        if ($WarehouseId -and $WarehouseName) {
            Write-Message -Message "Both 'WarehouseId' and 'WarehouseName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Step 2: Ensure token validity
        Confirm-TokenState
        # Step 3: Initialize variables


        # Step 4: Loop to retrieve all capacities with continuation token
        $apiEndpointURI = "workspaces/{0}/warehouses" -f $WorkspaceId

        $apiParams = @{
            Uri    = $apiEndpointURI
            Method = 'Get'
        }
        $Warehouses = (Invoke-FabricRestMethod @apiParams).Value

        # Step 8: Filter results based on provided parameters
        $Warehouse = if ($WarehouseId) {
            $Warehouses | Where-Object { $_.Id -eq $WarehouseId }
        } elseif ($WarehouseName) {
            $Warehouses | Where-Object { $_.DisplayName -eq $WarehouseName }
        } else {
            # Return all Warehouses if no filter is provided
            Write-Message -Message "No filter provided. Returning all Warehouses." -Level Debug
            $Warehouses
        }

        # Step 9: Handle results
        if ($Warehouse) {
            Write-Message -Message "Warehouse found matching the specified criteria." -Level Debug
            return $Warehouse
        } else {
            Write-Message -Message "No Warehouse found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Step 10: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Warehouse. Error: $errorDetails" -Level Error
    }

}
