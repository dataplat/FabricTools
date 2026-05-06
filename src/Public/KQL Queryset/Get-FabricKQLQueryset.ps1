function Get-FabricKQLQueryset {
    <#
.SYNOPSIS
Retrieves an KQLQueryset or a list of KQLQuerysets from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Get-FabricKQLQueryset` function sends a GET request to the Fabric API to retrieve KQLQueryset details for a given workspace. It can filter the results by `KQLQuerysetName`.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace to query KQLQuerysets.

.PARAMETER KQLQuerysetId
(Optional) The ID of a specific KQLQueryset to retrieve.

.PARAMETER KQLQuerysetName
(Optional) The name of the specific KQLQueryset to retrieve.

.EXAMPLE
    Retrieves the "Development" KQLQueryset from workspace "12345".

    ```powershell
    Get-FabricKQLQueryset -WorkspaceId "12345" -KQLQuerysetName "Development"
    ```

.EXAMPLE
    Retrieves all KQLQuerysets in workspace "12345".

    ```powershell
    Get-FabricKQLQueryset -WorkspaceId "12345"
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
        [string]$KQLQuerysetName
    )

    try {
        # Handle ambiguous input
        if ($KQLQuerysetId -and $KQLQuerysetName) {
            Write-Message -Message "Both 'KQLQuerysetId' and 'KQLQuerysetName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/kqlQuerysets"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Invoke the Fabric API to retrieve KQL Querysets
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            ExtractValue   = 'True'
            HandleResponse = $true
        }
        $KQLQuerysets = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $KQLQueryset = if ($KQLQuerysetId) {
            $KQLQuerysets | Where-Object { $_.Id -eq $KQLQuerysetId }
        } elseif ($KQLQuerysetName) {
            $KQLQuerysets | Where-Object { $_.DisplayName -eq $KQLQuerysetName }
        } else {
            # Return all KQLQuerysets if no filter is provided
            Write-Message -Message "No filter provided. Returning all KQLQuerysets." -Level Debug
            $KQLQuerysets
        }

        # Handle results
        if ($KQLQueryset) {
            Write-Message -Message "KQLQueryset found matching the specified criteria." -Level Debug
            return $KQLQueryset
        } else {
            Write-Message -Message "No KQLQueryset found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve KQLQueryset. Error: $errorDetails" -Level Error
    }

}
