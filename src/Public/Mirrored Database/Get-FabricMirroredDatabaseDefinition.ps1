function Get-FabricMirroredDatabaseDefinition {
<#
.SYNOPSIS
Retrieves the definition of a MirroredDatabase from a specific workspace in Microsoft Fabric.

.DESCRIPTION
This function fetches the MirroredDatabase's content or metadata from a workspace.
Handles both synchronous and asynchronous operations, with detailed logging and error handling.

.PARAMETER WorkspaceId
(Mandatory) The unique identifier of the workspace from which the MirroredDatabase definition is to be retrieved.

.PARAMETER MirroredDatabaseId
(Optional)The unique identifier of the MirroredDatabase whose definition needs to be retrieved.

.EXAMPLE
    Retrieves the definition of the MirroredDatabase with ID `67890` from the workspace with ID `12345`.

    ```powershell
    Get-FabricMirroredDatabaseDefinition -WorkspaceId "12345" -MirroredDatabaseId "67890"
    ```

.EXAMPLE
    Retrieves the definitions of all MirroredDatabases in the workspace with ID `12345`.

    ```powershell
    Get-FabricMirroredDatabaseDefinition -WorkspaceId "12345"
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
        [guid]$MirroredDatabaseId
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/mirroredDatabases/{2}/getDefinition" -f $FabricConfig.BaseUrl, $WorkspaceId, $MirroredDatabaseId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            TypeName       = 'Mirrored Database Definition'
            ObjectIdOrName = $MirroredDatabaseId
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams
        $response
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve MirroredDatabase. Error: $errorDetails" -Level Error
    }

}
