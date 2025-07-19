function New-FabricWorkspaceUsageMetricsReport {
    <#
.SYNOPSIS
Retrieves the workspace usage metrics dataset ID.

.DESCRIPTION
The New-FabricWorkspaceUsageMetricsReport function retrieves the workspace usage metrics dataset ID. It supports multiple aliases for flexibility.

.PARAMETER workspaceId
The ID of the workspace. This is a mandatory parameter.

.EXAMPLE
    This example retrieves the workspace usage metrics dataset ID for a specific workspace given the workspace ID.

    ```powershell
    New-FabricWorkspaceUsageMetricsReport -workspaceId "your-workspace-id"
    ```

.NOTES
The function retrieves the PowerBI access token and the Fabric API cluster URI. It then makes a GET request to the Fabric API to retrieve the workspace usage metrics dataset ID, parses the response and replaces certain keys to match the expected format, and returns the 'dbName' property of the first model in the response, which is the dataset ID.

Author: Ioana Bouariu

    #>

    # Define aliases for the function for flexibility.
    [Alias("New-FabWorkspaceUsageMetricsReport")]
    [CmdletBinding(SupportsShouldProcess)]
    # Define a parameter for the workspace ID.
    param(
        [Parameter(Mandatory = $true)]
        [guid]$WorkspaceId
    )

    Confirm-TokenState

    # Retrieve the Fabric API cluster URI.
    $url = Get-FabricAPIclusterURI

    # Make a GET request to the Fabric API to retrieve the workspace usage metrics dataset ID.
    if ($PSCmdlet.ShouldProcess("Workspace Usage Metrics Report", "Retrieve")) {
        $data = Invoke-WebRequest -Uri "$url/$workspaceId/usageMetricsReportV2?experience=power-bi" -Headers $FabricSession.HeaderParams -ErrorAction SilentlyContinue
        # Parse the response and replace certain keys to match the expected format.
        $response = $data.Content.ToString().Replace("nextRefreshTime", "NextRefreshTime").Replace("lastRefreshTime", "LastRefreshTime") | ConvertFrom-Json

        # Return the 'dbName' property of the first model in the response, which is the dataset ID.
        return $response.models[0].dbName
    } else {
        return $null
    }
}
