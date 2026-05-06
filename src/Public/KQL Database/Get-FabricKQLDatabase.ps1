function Get-FabricKQLDatabase {
    <#
.SYNOPSIS
Retrieves an KQLDatabase or a list of KQLDatabases from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Get-FabricKQLDatabase` function sends a GET request to the Fabric API to retrieve KQLDatabase details for a given workspace. It can filter the results by `KQLDatabaseName`.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace to query KQLDatabases.

.PARAMETER KQLDatabaseId
(Optional) The ID of a specific KQLDatabase to retrieve.

.PARAMETER KQLDatabaseName
(Optional) The name of the specific KQLDatabase to retrieve.

.EXAMPLE
    Retrieves the "Development" KQLDatabase from workspace "12345".

    ```powershell
    Get-FabricKQLDatabase -WorkspaceId "12345" -KQLDatabaseName "Development"
    ```

.EXAMPLE
    Retrieves all KQLDatabases in workspace "12345".

    ```powershell
    Get-FabricKQLDatabase -WorkspaceId "12345"
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
        [guid]$KQLDatabaseId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLDatabaseName
    )

    try {
        # Handle ambiguous input
        if ($KQLDatabaseId -and $KQLDatabaseName) {
            Write-Message -Message "Both 'KQLDatabaseId' and 'KQLDatabaseName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        $apiEndpointUrl = "{0}/workspaces/{1}/kqlDatabases" -f $FabricConfig.BaseUrl, $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            TypeName       = 'KQL Database'
            HandleResponse = $true
            ExtractValue   = 'True'
        }
        $KQLDatabases = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $KQLDatabase = if ($KQLDatabaseId) {
            $KQLDatabases | Where-Object { $_.Id -eq $KQLDatabaseId }
        } elseif ($KQLDatabaseName) {
            $KQLDatabases | Where-Object { $_.DisplayName -eq $KQLDatabaseName }
        } else {
            Write-Message -Message "No filter provided. Returning all KQLDatabases." -Level Debug
            $KQLDatabases
        }

        # Handle results
        if ($KQLDatabase) {
            Write-Message -Message "KQLDatabase found matching the specified criteria." -Level Debug
            return $KQLDatabase
        } else {
            Write-Message -Message "No KQLDatabase found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve KQLDatabase. Error: $errorDetails" -Level Error
    }

}
