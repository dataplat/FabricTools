function Stop-FabricMirroredDatabaseMirroring
{
    <#

    .SYNOPSIS
    Stops the mirroring of a specified mirrored database in a given workspace.

    .DESCRIPTION
    This function sends a POST request to the Microsoft Fabric API to stop the mirroring of a specified mirrored database.
    It requires the workspace ID and the mirrored database ID as parameters.


    .PARAMETER WorkspaceId
    The unique identifier of the workspace where the mirrored database resides. This parameter is mandatory.


    .PARAMETER MirroredDatabaseId
    The unique identifier of the mirrored database to be stopped. This parameter is mandatory.


    .EXAMPLE
    Stop-FabricMirroredDatabaseMirroring -WorkspaceId "12345" -MirroredDatabaseId "67890"
    Stops the mirroring of the mirrored database with ID `67890` in the workspace `12345`.


    .NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Test-TokenExpired` to ensure token validity before making the API request.
    - This function handles asynchronous operations and retrieves operation results if required.

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$MirroredDatabaseId
    )

    try
    {
        # Step 2: Ensure token validity
        Test-TokenExpired

        $apiEndpointUrl = "{0}/workspaces/{1}/mirroredDatabases/{2}/stopMirroring" -f $FabricConfig.BaseUrl, $WorkspaceId, $MirroredDatabaseId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Stop MirroredDatabase Mirroring"))
        {
            # Step 6: Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Post
        }

        # Step 7: Validate the response code
        if ($statusCode -ne 200)
        {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        # Step 9: Handle results
        Write-Message -Message "Database mirroring stopped successfully for MirroredDatabaseId: $MirroredDatabaseId" -Level Info
        return
    }
    catch
    {
        # Step 10: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to stop MirroredDatabase. Error: $errorDetails" -Level Error
    }

}
