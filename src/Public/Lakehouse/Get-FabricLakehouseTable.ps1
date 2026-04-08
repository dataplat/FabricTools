function Get-FabricLakehouseTable {

    <#
.SYNOPSIS
Retrieves tables from a specified Lakehouse in a Fabric workspace.

.DESCRIPTION
This function retrieves tables from a specified Lakehouse in a Fabric workspace. It handles pagination using a continuation token to ensure all data is retrieved.

.PARAMETER WorkspaceId
The ID of the workspace containing the Lakehouse.

.PARAMETER LakehouseId
The ID of the Lakehouse from which to retrieve tables.

.EXAMPLE
    This example retrieves all tables from the specified Lakehouse in the specified workspace.

    ```powershell
    Get-FabricLakehouseTable -WorkspaceId "your-workspace-id" -LakehouseId "your-lakehouse-id"
    ```

.NOTES

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$LakehouseId
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        $apiEndpointUrl = "workspaces/{0}/lakehouses/{1}/tables" -f $WorkspaceId, $LakehouseId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Table list endpoint returns .data instead of .value; collect per-page response objects
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            TypeName       = 'Lakehouse Table'
            HandleResponse = $true
        }
        $tables = @(Invoke-FabricRestMethod @apiParams) | ForEach-Object { $_.data }

        if ($tables) {
            Write-Message -Message "Tables found in the Lakehouse '$LakehouseId'." -Level Debug
            return $tables
        } else {
            Write-Message -Message "No tables found matching in the Lakehouse '$LakehouseId'." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Lakehouse. Error: $errorDetails" -Level Error
    }

}
