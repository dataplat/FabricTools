function Get-FabricMirroredDatabaseStatus {
    <#

    .SYNOPSIS
    Retrieves the status of a mirrored database in a specified workspace.

    .DESCRIPTION
    Retrieves the status of a mirrored database in a specified workspace. The function validates the authentication token, constructs the API endpoint URL, and makes a POST request to retrieve the mirroring status.
    It handles errors and logs messages at various levels (Debug, Error).

    .PARAMETER WorkspaceId
    The ID of the workspace containing the mirrored database.

    .PARAMETER MirroredDatabaseId
    the ID of the mirrored database whose status is to be retrieved.

    .EXAMPLE
    Get-FabricMirroredDatabaseStatus -WorkspaceId "your-workspace-id" -MirroredDatabaseId "your-mirrored-database-id"
    This example retrieves the status of a mirrored database with the specified ID in the specified workspace.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$MirroredDatabaseId
    )

    try {
        # Step 2: Ensure token validity
        Confirm-TokenState

        $apiEndpointUrl = "{0}/workspaces/{1}/mirroredDatabases/{2}/getMirroringStatus" -f $FabricConfig.BaseUrl, $WorkspaceId, $MirroredDatabaseId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 6: Make the API request
        $response = Invoke-FabricRestMethod `
            -Uri $apiEndpointUrl `
            -Method Post

        # Step 7: Validate the response code
        if ($statusCode -ne 200) {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        # Step 9: Handle results

        Write-Message -Message "Returning status of MirroredDatabases." -Level Debug
        return $response
    } catch {
        # Step 10: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve MirroredDatabase. Error: $errorDetails" -Level Error
    }

}
