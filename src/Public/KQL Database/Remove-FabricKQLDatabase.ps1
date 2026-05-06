function Remove-FabricKQLDatabase
{
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
    Deletes the KQLDatabase with ID "67890" from workspace "12345".

    ```powershell
    Remove-FabricKQLDatabase -WorkspaceId "12345" -KQLDatabaseId "67890"
    ```

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Validates token expiration before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

#>
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
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/kqlDatabases/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $KQLDatabaseId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Remove KQLDatabase"))
        {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Delete'
                TypeName       = 'KQL Database'
                ObjectIdOrName = $KQLDatabaseId
                HandleResponse = $true
            }
            Invoke-FabricRestMethod @apiParams
        }

        Write-Message -Message "KQLDatabase '$KQLDatabaseId' deleted successfully from workspace '$WorkspaceId'." -Level Info
    }
    catch
    {
        # Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete KQLDatabase '$KQLDatabaseId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
