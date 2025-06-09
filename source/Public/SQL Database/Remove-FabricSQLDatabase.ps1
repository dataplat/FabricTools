<#
.SYNOPSIS
Deletes a SQL Database from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Remove-FabricSQLDatabase` function sends a DELETE request to the Fabric API to remove a specified SQLDatabase from a given workspace.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace containing the SQLDatabase to delete.

.PARAMETER SQLDatabaseId
(Mandatory) The ID of the SQL Database to be deleted.

.EXAMPLE
Remove-FabricSQLDatabas -WorkspaceId "12345" -SQLDatabaseId "67890"

Deletes the SQL Database with ID "67890" from workspace "12345".

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Validates token expiration before making the API request.

Author: Kamil Nowinski

#>

function Remove-FabricSQLDatabase
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SQLDatabaseId
    )

    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/sqldatabases/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $SQLDatabaseId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Delete SQL Database"))
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
        Write-Message -Message "SQL Database '$SQLDatabaseId' deleted successfully from workspace '$WorkspaceId'." -Level Info

    }
    catch
    {
        # Step 5: Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete SQL Database '$SQLDatabaseId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
