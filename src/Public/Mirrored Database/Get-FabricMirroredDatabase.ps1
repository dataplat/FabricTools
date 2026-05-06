function Get-FabricMirroredDatabase {
    <#
.SYNOPSIS
Retrieves an MirroredDatabase or a list of MirroredDatabases from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Get-FabricMirroredDatabase` function sends a GET request to the Fabric API to retrieve MirroredDatabase details for a given workspace. It can filter the results by `MirroredDatabaseName`.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace to query MirroredDatabases.

.PARAMETER MirroredDatabaseId
(Optional) The ID of a specific MirroredDatabase to retrieve.

.PARAMETER MirroredDatabaseName
(Optional) The name of the specific MirroredDatabase to retrieve.

.EXAMPLE
    Retrieves the "Development" MirroredDatabase from workspace "12345".

    ```powershell
    Get-FabricMirroredDatabase -WorkspaceId "12345" -MirroredDatabaseName "Development"
    ```

.EXAMPLE
    Retrieves all MirroredDatabases in workspace "12345".

    ```powershell
    Get-FabricMirroredDatabase -WorkspaceId "12345"
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
        [guid]$MirroredDatabaseId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$MirroredDatabaseName
    )

    try {
        # Handle ambiguous input
        if ($MirroredDatabaseId -and $MirroredDatabaseName) {
            Write-Message -Message "Both 'MirroredDatabaseId' and 'MirroredDatabaseName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        $apiEndpointUrl = "{0}/workspaces/{1}/mirroredDatabases" -f $FabricConfig.BaseUrl, $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            TypeName       = 'Mirrored Database'
            HandleResponse = $true
            ExtractValue   = 'True'
        }
        $MirroredDatabases = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $MirroredDatabase = if ($MirroredDatabaseId) {
            $MirroredDatabases | Where-Object { $_.Id -eq $MirroredDatabaseId }
        } elseif ($MirroredDatabaseName) {
            $MirroredDatabases | Where-Object { $_.DisplayName -eq $MirroredDatabaseName }
        } else {
            Write-Message -Message "No filter provided. Returning all MirroredDatabases." -Level Debug
            $MirroredDatabases
        }

        # Handle results
        if ($MirroredDatabase) {
            Write-Message -Message "MirroredDatabase found matching the specified criteria." -Level Debug
            return $MirroredDatabase
        } else {
            Write-Message -Message "No MirroredDatabase found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve MirroredDatabase. Error: $errorDetails" -Level Error
    }

}
