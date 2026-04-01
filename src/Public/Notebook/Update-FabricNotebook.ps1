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

Author: Tiago Balabuch

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
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/notebooks/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $NotebookId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
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
            # Step 4: Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Patch `
                -Body $bodyJson
        }
        # Step 5: Validate the response code
        if ($statusCode -ne 200)
        {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        # Step 6: Handle results
        Write-Message -Message "Notebook '$NotebookName' updated successfully!" -Level Info
        return $response
    }
    catch
    {
        # Step 7: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update notebook. Error: $errorDetails" -Level Error
    }
}
