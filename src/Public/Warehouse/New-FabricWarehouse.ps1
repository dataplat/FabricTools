function New-FabricWarehouse
{
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
        This example creates a new warehouse named "New Warehouse" in the workspace with ID "workspace-12345" with the provided description.

        ```powershell
        New-FabricWarehouse -WorkspaceId "workspace-12345" -WarehouseName "New Warehouse" -WarehouseDescription "Description of the new warehouse"
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.

        Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WarehouseName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$WarehouseDescription
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/{0}/warehouses" -f $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $WarehouseName
        }

        if ($WarehouseDescription)
        {
            $body.description = $WarehouseDescription
        }

        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Create Warehouse"))
        {
            # Make the API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                HandleResponse = $true
                TypeName       = 'Warehouse'
                ObjectIdOrName = $WarehouseName
            }
            $response = Invoke-FabricRestMethod @apiParams
        }

        Write-Message -Message "Data Warehouse created successfully!" -Level Info
        return $response

    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create Warehouse. Error: $errorDetails" -Level Error
    }
}
