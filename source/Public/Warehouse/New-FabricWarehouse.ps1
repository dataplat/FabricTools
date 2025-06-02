<#
.SYNOPSIS
    Creates a new warehouse in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a POST request to the Microsoft Fabric API to create a new warehouse
    in the specified workspace. It supports optional parameters for warehouse description.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the warehouse will be created. This parameter is mandatory.

.PARAMETER WarehouseName
    The name of the warehouse to be created. This parameter is mandatory.

.PARAMETER WarehouseDescription
    An optional description for the warehouse.

.EXAMPLE
    New-FabricWarehouse -WorkspaceId "workspace-12345" -WarehouseName "New Warehouse" -WarehouseDescription "Description of the new warehouse"
    This example creates a new warehouse named "New Warehouse" in the workspace with ID "workspace-12345" with the provided description.

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Test-TokenExpired` to ensure token validity before making the API request.

    Author: Tiago Balabuch
#>
function New-FabricWarehouse
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

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
        Test-TokenExpired

        # Step 2: Construct the API URL
        $apiEndpointURI = "workspaces/{0}/warehouses" -f $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointURI" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            displayName = $WarehouseName
        }

        if ($WarehouseDescription)
        {
            $body.description = $WarehouseDescription
        }

        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointURI, "Create Warehouse"))
        {
            # Step 4: Make the API request
            $apiParams = @{
                Uri    = $apiEndpointURI
                Method = 'Post'
                Body   = $bodyJson
            }
            $response = Invoke-FabricRestMethod @apiParams
        }

        Write-Message -Message "Data Warehouse created successfully!" -Level Info
        return $response

    }
    catch
    {
        # Step 6: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create Warehouse. Error: $errorDetails" -Level Error
    }
}
