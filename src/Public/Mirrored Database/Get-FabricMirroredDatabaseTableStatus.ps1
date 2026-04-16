function Get-FabricMirroredDatabaseTableStatus {
    <#

    .SYNOPSIS
    Retrieves the status of tables in a mirrored database.

    .DESCRIPTION
    Retrieves the status of tables in a mirrored database. The function validates the authentication token, constructs the API endpoint URL, and makes a POST request to retrieve the mirroring status of tables. It handles errors and logs messages at various levels (Debug, Error).

    .PARAMETER WorkspaceId
    The ID of the workspace containing the mirrored database.

    .PARAMETER MirroredDatabaseId
    The ID of the mirrored database whose table status is to be retrieved.

    .EXAMPLE
    This example retrieves the status of tables in a mirrored database with the specified ID in the specified workspace.

    ```powershell
    Get-FabricMirroredDatabaseTableStatus -WorkspaceId "your-workspace-id" -MirroredDatabaseId "your-mirrored-database-id"
    ```

    .NOTES
    The function retrieves the PowerBI access token and makes a POST request to the PowerBI API to retrieve the status of tables in the specified mirrored database. It then returns the 'value' property of the response, which contains the table statuses.

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
        [guid]$MirroredDatabaseId
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        $apiEndpointUrl = "{0}/workspaces/{1}/mirroredDatabases/{2}/getTablesMirroringStatus" -f $FabricConfig.BaseUrl, $WorkspaceId, $MirroredDatabaseId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # This endpoint returns .data instead of .value
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            TypeName       = 'Mirrored Database Table Status'
            ObjectIdOrName = $MirroredDatabaseId
            HandleResponse = $true
            ExtractValue   = 'False'
        }
        Write-Message -Message "No filter provided. Returning all MirroredDatabases." -Level Debug
        @(Invoke-FabricRestMethod @apiParams) | ForEach-Object { $_.data }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve MirroredDatabase. Error: $errorDetails" -Level Error
    }

}
