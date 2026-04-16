function Get-FabricKQLQuerysetDefinition {
<#
.SYNOPSIS
Retrieves the definition of a KQLQueryset from a specific workspace in Microsoft Fabric.

.DESCRIPTION
This function fetches the KQLQueryset's content or metadata from a workspace.
Handles both synchronous and asynchronous operations, with detailed logging and error handling.

.PARAMETER WorkspaceId
(Mandatory) The unique identifier of the workspace from which the KQLQueryset definition is to be retrieved.

.PARAMETER KQLQuerysetId
(Optional)The unique identifier of the KQLQueryset whose definition needs to be retrieved.

.PARAMETER KQLQuerysetFormat
Specifies the format of the KQLQueryset definition.

.EXAMPLE
    Retrieves the definition of the KQLQueryset with ID `67890` from the workspace with ID `12345` in the `ipynb` format.

    ```powershell
    Get-FabricKQLQuerysetDefinition -WorkspaceId "12345" -KQLQuerysetId "67890"
    ```

.EXAMPLE
    Retrieves the definitions of all KQLQuerysets in the workspace with ID `12345` in the `ipynb` format.

    ```powershell
    Get-FabricKQLQuerysetDefinition -WorkspaceId "12345"
    ```

.NOTES
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
        [guid]$KQLQuerysetId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLQuerysetFormat
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/kqlQuerysets/$KQLQuerysetId/getDefinition"

        if ($KQLQuerysetFormat) {
            $apiEndpointUrl = "$apiEndpointUrl?format=$KQLQuerysetFormat"
        }
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Invoke Fabric API request
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams
        Write-Message -Message "KQLQueryset '$KQLQuerysetId' definition retrieved successfully!" -Level Debug
        return $response.definition.parts
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve KQLQueryset. Error: $errorDetails" -Level Error
    }

}
