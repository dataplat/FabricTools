<#
.SYNOPSIS
Deletes an MirroredDatabase from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Remove-FabricMirroredDatabase` function sends a DELETE request to the Fabric API to remove a specified MirroredDatabase from a given workspace.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace containing the MirroredDatabase to delete.

.PARAMETER MirroredDatabaseId
(Mandatory) The ID of the MirroredDatabase to be deleted.

.EXAMPLE
Remove-FabricMirroredDatabase -WorkspaceId "12345" -MirroredDatabaseId "67890"

Deletes the MirroredDatabase with ID "67890" from workspace "12345".

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Validates token expiration before making the API request.

Author: Tiago Balabuch
#>

function Remove-FabricMirroredDatabase
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$MirroredDatabaseId
    )

    try
    {
        # Step 1: Ensure token validity
        Test-TokenExpired

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/mirroredDatabases/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $MirroredDatabaseId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Remove MirroredDatabase"))
        {
            # Step 3: Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Delete
        }

        # Step 4: Validate the response code
        if ($statusCode -ne 200)
        {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }
        Write-Message -Message "MirroredDatabase '$MirroredDatabaseId' deleted successfully from workspace '$WorkspaceId'." -Level Info

    }
    catch
    {
        # Step 5: Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete MirroredDatabase '$MirroredDatabaseId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
