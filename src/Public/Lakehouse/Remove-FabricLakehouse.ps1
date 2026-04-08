function Remove-FabricLakehouse
{
<#
.SYNOPSIS
Deletes an Lakehouse from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Remove-FabricLakehouse` function sends a DELETE request to the Fabric API to remove a specified Lakehouse from a given workspace.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace containing the Lakehouse to delete.

.PARAMETER LakehouseId
(Mandatory) The ID of the Lakehouse to be deleted.

.EXAMPLE
    Deletes the Lakehouse with ID "67890" from workspace "12345".

    ```powershell
    Remove-FabricLakehouse -WorkspaceId "12345" -LakehouseId "67890"
    ```

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Validates token expiration before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$LakehouseId
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/lakehouses/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $LakehouseId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Remove Lakehouse"))
        {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Delete'
                TypeName       = 'Lakehouse'
                ObjectIdOrName = $LakehouseId
                HandleResponse = $true
            }
            Invoke-FabricRestMethod @apiParams
        }

    }
    catch
    {
        # Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete Lakehouse '$LakehouseId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
