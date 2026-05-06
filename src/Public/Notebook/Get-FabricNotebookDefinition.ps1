function Get-FabricNotebookDefinition {
<#
.SYNOPSIS
Retrieves the definition of a notebook from a specific workspace in Microsoft Fabric.

.DESCRIPTION
This function fetches the notebook's content or metadata from a workspace.
It supports retrieving notebook definitions in the Jupyter Notebook (`ipynb`) format.
Handles both synchronous and asynchronous operations, with detailed logging and error handling.

.PARAMETER WorkspaceId
(Mandatory) The unique identifier of the workspace from which the notebook definition is to be retrieved.

.PARAMETER NotebookId
(Optional)The unique identifier of the notebook whose definition needs to be retrieved.

.PARAMETER NotebookFormat
Specifies the format of the notebook definition. Currently, only 'ipynb' is supported.
Default: 'ipynb'.

.EXAMPLE
    Retrieves the definition of the notebook with ID `67890` from the workspace with ID `12345` in the `ipynb` format.

    ```powershell
    Get-FabricNotebookDefinition -WorkspaceId "12345" -NotebookId "67890"
    ```

.EXAMPLE
    Retrieves the definitions of all notebooks in the workspace with ID `12345` in the `ipynb` format.

    ```powershell
    Get-FabricNotebookDefinition -WorkspaceId "12345"
    ```

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Handles long-running operations asynchronously.

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
        [ValidateSet('ipynb')]
        [string]$NotebookFormat = 'ipynb'
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/notebooks/{2}/getDefinition" -f $FabricConfig.BaseUrl, $WorkspaceId, $NotebookId

        if ($NotebookFormat) {
            $apiEndpointUrl = "{0}?format={1}" -f $apiEndpointUrl, $NotebookFormat
        }


        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Make the API request
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            TypeName       = 'Notebook Definition'
            ObjectIdOrName = $NotebookId
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams
        $response
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Notebook. Error: $errorDetails" -Level Error
    }

}
