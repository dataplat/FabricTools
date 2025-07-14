
function Get-FabricDashboard {
<#
.SYNOPSIS
    Retrieves dashboards from a specified workspace.

.DESCRIPTION
    This function retrieves all dashboards from a specified workspace using the provided WorkspaceId.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The ID of the workspace from which to retrieve dashboards. This parameter is mandatory.

.EXAMPLE
    This example retrieves all dashboards from the workspace with ID "12345".

    ```powershell
    Get-FabricDashboard -WorkspaceId "12345"
    ```

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointURI = "workspaces/{0}/dashboards" -f $WorkspaceId

        # Invoke the Fabric API to retrieve capacity details
        $apiParams = @{
            Uri    = $apiEndpointURI
            Method = 'Get'
        }
        $Dashboards = Invoke-FabricRestMethod @apiParams

        return $Dashboards

    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Dashboard. Error: $errorDetails" -Level Error
    }
}
