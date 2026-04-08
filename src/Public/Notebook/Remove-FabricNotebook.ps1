function Remove-FabricNotebook
{
<#
.SYNOPSIS
Deletes an Notebook from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Remove-FabricNotebook` function sends a DELETE request to the Fabric API to remove a specified Notebook from a given workspace.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace containing the Notebook to delete.

.PARAMETER NotebookId
(Mandatory) The ID of the Notebook to be deleted.

.EXAMPLE
    Deletes the Notebook with ID "67890" from workspace "12345".

    ```powershell
    Remove-FabricNotebook -WorkspaceId "12345" -NotebookId "67890"
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
        [guid]$NotebookId
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/notebooks/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $NotebookId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Remove Notebook"))
        {
            # Make the API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Delete'
                TypeName       = 'Notebook'
                ObjectIdOrName = $NotebookId
                HandleResponse = $true
            }
            Invoke-FabricRestMethod @apiParams
        }

    }
    catch
    {
        # Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete notebook '$NotebookId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
