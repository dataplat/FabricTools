<#
.SYNOPSIS
Deletes an KQLDatabase from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Remove-FabricKQLDatabase` function sends a DELETE request to the Fabric API to remove a specified KQLDatabase from a given workspace.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace containing the KQLDatabase to delete.

.PARAMETER KQLDatabaseId
(Mandatory) The ID of the KQLDatabase to be deleted.

.EXAMPLE
Remove-FabricKQLDatabase -WorkspaceId "12345" -KQLDatabaseId "67890"

Deletes the KQLDatabase with ID "67890" from workspace "12345".

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Validates token expiration before making the API request.

Author: Tiago Balabuch

#>

function Remove-FabricKQLDatabase
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$KQLDatabaseId
    )

    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/kqlDatabases/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $KQLDatabaseId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Remove KQLDatabase"))
        {
            # Step 3: Check if the API endpoint is valid
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
            Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }
        Write-Message -Message "KQLDatabase '$KQLDatabaseId' deleted successfully from workspace '$WorkspaceId'." -Level Info

    }
    catch
    {
        # Step 5: Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete KQLDatabase '$KQLDatabaseId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
