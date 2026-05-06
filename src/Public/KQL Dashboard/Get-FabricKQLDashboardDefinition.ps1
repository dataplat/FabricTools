function Get-FabricKQLDashboardDefinition {
<#
.SYNOPSIS
Retrieves the definition of a KQLDashboard from a specific workspace in Microsoft Fabric.

.DESCRIPTION
This function fetches the KQLDashboard's content or metadata from a workspace.
Handles both synchronous and asynchronous operations, with detailed logging and error handling.

.PARAMETER WorkspaceId
(Mandatory) The unique identifier of the workspace from which the KQLDashboard definition is to be retrieved.

.PARAMETER KQLDashboardId
(Optional)The unique identifier of the KQLDashboard whose definition needs to be retrieved.

.PARAMETER KQLDashboardFormat
Specifies the format of the KQLDashboard definition.

.EXAMPLE
    Retrieves the definition of the KQLDashboard with ID `67890` from the workspace with ID `12345` in the `ipynb` format.

    ```powershell
    Get-FabricKQLDashboardDefinition -WorkspaceId "12345" -KQLDashboardId "67890"
    ```

.EXAMPLE
    Retrieves the definitions of all KQLDashboards in the workspace with ID `12345` in the `ipynb` format.

    ```powershell
    Get-FabricKQLDashboardDefinition -WorkspaceId "12345"
    ```

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Handles long-running operations asynchronously.

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
        [string]$KQLDashboardFormat
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/kqlDashboards/{2}/getDefinition" -f $FabricConfig.BaseUrl, $WorkspaceId, $KQLDashboardId

        if ($KQLDashboardFormat) {
            $apiEndpointUrl = "{0}?format={1}" -f $apiEndpointUrl, $KQLDashboardFormat
        }
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            TypeName       = 'KQL Dashboard Definition'
            ObjectIdOrName = $KQLDashboardId
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams
        $response
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve KQLDashboard. Error: $errorDetails" -Level Error
    }

}
