function Get-FabricDomainWorkspace {
<#
.SYNOPSIS
Retrieves the workspaces associated with a specific domain in Microsoft Fabric.

.DESCRIPTION
The `Get-FabricDomainWorkspace` function fetches the workspaces for the given domain ID.

.PARAMETER DomainId
The ID of the domain for which to retrieve workspaces.

.EXAMPLE
    Fetches workspaces for the domain with ID "12345".

    ```powershell
    Get-FabricDomainWorkspace -DomainId "12345"
    ```

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$DomainId
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/admin/domains/{1}/workspaces" -f $FabricConfig.BaseUrl, $DomainId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Make the API request
        $response = Invoke-FabricRestMethod `
            -Uri $apiEndpointUrl `
            -Method Get

        # Validate the response code
        if ($statusCode -ne 200) {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        # Handle empty response
        if (-not $response) {
            Write-Message -Message "No data returned from the API." -Level Warning
            return $null
        }
        # Handle results
        if ($response) {
            return $response.value
        } else {
            Write-Message -Message "No workspace found for the '$DomainId'." -Level Warning
            return $null
        }

    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve domain workspaces. Error: $errorDetails" -Level Error
    }
}
