function Get-FabricKQLDatabaseDefinition {
<#
.SYNOPSIS
Retrieves the definition of a KQLDatabase from a specific workspace in Microsoft Fabric.

.DESCRIPTION
This function fetches the KQLDatabase's content or metadata from a workspace.
It supports retrieving KQLDatabase definitions in the Jupyter KQLDatabase (`ipynb`) format.
Handles both synchronous and asynchronous operations, with detailed logging and error handling.

.PARAMETER WorkspaceId
(Mandatory) The unique identifier of the workspace from which the KQLDatabase definition is to be retrieved.

.PARAMETER KQLDatabaseId
(Optional)The unique identifier of the KQLDatabase whose definition needs to be retrieved.

.PARAMETER KQLDatabaseFormat
Specifies the format of the KQLDatabase definition. Currently, only 'ipynb' is supported.

.EXAMPLE
    Retrieves the definition of the KQLDatabase with ID `67890` from the workspace with ID `12345` in the `ipynb` format.

    ```powershell
    Get-FabricKQLDatabaseDefinition -WorkspaceId "12345" -KQLDatabaseId "67890"
    ```

.EXAMPLE
    Retrieves the definitions of all KQLDatabases in the workspace with ID `12345` in the `ipynb` format.

    ```powershell
    Get-FabricKQLDatabaseDefinition -WorkspaceId "12345"
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
        [guid]$KQLDatabaseId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLDatabaseFormat
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/KQLDatabases/{2}/getDefinition" -f $FabricConfig.BaseUrl, $WorkspaceId, $KQLDatabaseId

        if ($KQLDatabaseFormat) {
            $apiEndpointUrl = "{0}?format={1}" -f $apiEndpointUrl, $KQLDatabaseFormat
        }
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            TypeName       = 'KQL Database Definition'
            ObjectIdOrName = $KQLDatabaseId
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams
        $response
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve KQLDatabase. Error: $errorDetails" -Level Error
    }
}
