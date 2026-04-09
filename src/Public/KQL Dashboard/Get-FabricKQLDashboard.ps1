function Get-FabricKQLDashboard {
<#
.SYNOPSIS
Retrieves an KQLDashboard or a list of KQLDashboards from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Get-FabricKQLDashboard` function sends a GET request to the Fabric API to retrieve KQLDashboard details for a given workspace. It can filter the results by `KQLDashboardName`.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace to query KQLDashboards.

.PARAMETER KQLDashboardId
(Optional) The ID of the specific KQLDashboard to retrieve.

.PARAMETER KQLDashboardName
(Optional) The name of the specific KQLDashboard to retrieve.

.EXAMPLE
    Retrieves the "Development" KQLDashboard from workspace "12345". .PARAMETER KQLDashboardID The Id of the KQLDashboard to retrieve. This parameter cannot be used together with KQLDashboardName. The value for KQLDashboardID is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.

    ```powershell
    Get-FabricKQLDashboard -WorkspaceId "12345" -KQLDashboardName "Development"
    ```

.EXAMPLE
    Retrieves all KQLDashboards in workspace "12345".

    ```powershell
    Get-FabricKQLDashboard -WorkspaceId "12345"
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
        [guid]$KQLDashboardId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLDashboardName
    )

    try {
        # Handle ambiguous input
        if ($KQLDashboardId -and $KQLDashboardName) {
            Write-Message -Message "Both 'KQLDashboardId' and 'KQLDashboardName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        $apiEndpointUrl = "{0}/workspaces/{1}/kqlDashboards" -f $FabricConfig.BaseUrl, $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            TypeName       = 'KQL Dashboard'
            HandleResponse = $true
            ExtractValue   = 'True'
        }
        $KQLDashboards = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $KQLDashboard = if ($KQLDashboardId) {
            $KQLDashboards | Where-Object { $_.Id -eq $KQLDashboardId }
        } elseif ($KQLDashboardName) {
            $KQLDashboards | Where-Object { $_.DisplayName -eq $KQLDashboardName }
        } else {
            Write-Message -Message "No filter provided. Returning all KQLDashboards." -Level Debug
            $KQLDashboards
        }

        # Handle results
        if ($KQLDashboard) {
            Write-Message -Message "KQLDashboard found matching the specified criteria." -Level Debug
            return $KQLDashboard
        } else {
            Write-Message -Message "No KQLDashboard found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve KQLDashboard. Error: $errorDetails" -Level Error
    }

}
