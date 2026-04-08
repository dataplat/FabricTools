function Get-FabricNotebook {
    <#
.SYNOPSIS
Retrieves an Notebook or a list of Notebooks from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Get-FabricNotebook` function sends a GET request to the Fabric API to retrieve Notebook details for a given workspace. It can filter the results by `NotebookName`.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace to query Notebooks.

.PARAMETER NotebookId
(Optional) The ID of a specific Notebook to retrieve.

.PARAMETER NotebookName
(Optional) The name of the specific Notebook to retrieve.

.EXAMPLE
    Retrieves the "Development" Notebook from workspace "12345".

    ```powershell
    Get-FabricNotebook -WorkspaceId "12345" -NotebookName "Development"
    ```

.EXAMPLE
    Retrieves all Notebooks in workspace "12345".

    ```powershell
    Get-FabricNotebook -WorkspaceId "12345"
    ```

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$NotebookId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$NotebookName
    )

    try {
        # Handle ambiguous input
        if ($NotebookId -and $NotebookName) {
            Write-Message -Message "Both 'NotebookId' and 'NotebookName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        $apiEndpointUrl = "workspaces/{0}/notebooks" -f $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            TypeName       = 'Notebook'
            HandleResponse = $true
            ExtractValue   = 'True'
        }
        $notebooks = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $notebook = if ($NotebookId) {
            $notebooks | Where-Object { $_.Id -eq $NotebookId }
        } elseif ($NotebookName) {
            $notebooks | Where-Object { $_.DisplayName -eq $NotebookName }
        } else {
            Write-Message -Message "No filter provided. Returning all Notebooks." -Level Debug
            $notebooks
        }

        if ($notebook) {
            Write-Message -Message "Notebook found matching the specified criteria." -Level Debug
            return $notebook
        } else {
            Write-Message -Message "No notebook found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Notebook. Error: $errorDetails" -Level Error
    }

}
