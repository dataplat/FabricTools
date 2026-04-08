function Update-FabricNotebook
{
<#
.SYNOPSIS
Updates the properties of a Fabric Notebook.

.DESCRIPTION
The `Update-FabricNotebook` function updates the name and/or description of a specified Fabric Notebook by making a PATCH request to the API.

.PARAMETER WorkspaceId
The unique identifier of the workspace where the Notebook exists.

.PARAMETER NotebookId
The unique identifier of the Notebook to be updated.

.PARAMETER NotebookName
The new name for the Notebook.

.PARAMETER NotebookDescription
(Optional) The new description for the Notebook.

.EXAMPLE
    Updates the name of the Notebook with the ID "Notebook123" to "NewNotebookName".

    ```powershell
    Update-FabricNotebook -NotebookId "Notebook123" -NotebookName "NewNotebookName"
    ```

.EXAMPLE
    Updates both the name and description of the Notebook "Notebook123".

    ```powershell
    Update-FabricNotebook -NotebookId "Notebook123" -NotebookName "NewName" -NotebookDescription "Updated description"
    ```

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$NotebookId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$NotebookName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$NotebookDescription
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/notebooks/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $NotebookId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $NotebookName
        }

        if ($NotebookDescription)
        {
            $body.description = $NotebookDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Update Notebook"))
        {
            # Make the API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Patch'
                Body           = $bodyJson
                TypeName       = 'Notebook'
                ObjectIdOrName = $NotebookName
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update notebook. Error: $errorDetails" -Level Error
    }
}
