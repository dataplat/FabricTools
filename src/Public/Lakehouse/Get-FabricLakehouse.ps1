function Get-FabricLakehouse {
    <#
.SYNOPSIS
Retrieves an Lakehouse or a list of Lakehouses from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Get-FabricLakehouse` function sends a GET request to the Fabric API to retrieve Lakehouse details for a given workspace. It can filter the results by `LakehouseName`.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace to query Lakehouses.

.PARAMETER LakehouseId
(Optional) The ID of a specific Lakehouse to retrieve.

.PARAMETER LakehouseName
(Optional) The name of the specific Lakehouse to retrieve.

.EXAMPLE
    Retrieves the "Development" Lakehouse from workspace "12345".

    ```powershell
    Get-FabricLakehouse -WorkspaceId "12345" -LakehouseName "Development"
    ```

.EXAMPLE
    Retrieves all Lakehouses in workspace "12345".

    ```powershell
    Get-FabricLakehouse -WorkspaceId "12345"
    ```

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
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
        [guid]$LakehouseId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$LakehouseName
    )

    try {
        # Handle ambiguous input
        if ($LakehouseId -and $LakehouseName) {
            Write-Message -Message "Both 'LakehouseId' and 'LakehouseName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        $apiEndpointUrl = "workspaces/{0}/lakehouses" -f $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            TypeName       = 'Lakehouse'
            HandleResponse = $true
            ExtractValue   = 'True'
        }
        $lakehouses = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $lakehouses = if ($LakehouseId) {
            $lakehouses | Where-Object { $_.Id -eq $LakehouseId }
        } elseif ($LakehouseName) {
            $lakehouses | Where-Object { $_.DisplayName -eq $LakehouseName }
        } else {
            Write-Message -Message "No filter provided. Returning all Lakehouses." -Level Debug
            $lakehouses
        }

        if ($lakehouses) {
            Write-Message -Message "Lakehouse found matching the specified criteria." -Level Debug
            return $lakehouses
        } else {
            Write-Message -Message "No Lakehouse found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Lakehouse. Error: $errorDetails" -Level Error
    }

}
