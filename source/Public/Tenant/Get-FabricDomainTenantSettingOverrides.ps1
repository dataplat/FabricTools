<#
.SYNOPSIS
Retrieves tenant setting overrides for a specific domain or all capacities in the Fabric tenant.

.DESCRIPTION
The `Get-FabricDomainTenantSettingOverrides` function retrieves tenant setting overrides for all domains in the Fabric tenant by making a GET request to the designated API endpoint. The function ensures token validity before making the request and handles the response appropriately.

.EXAMPLE
Get-FabricDomainTenantSettingOverrides

Fetches tenant setting overrides for all domains in the Fabric tenant.

.NOTES
- Requires the `$FabricConfig` global configuration, which must include `BaseUrl` and `FabricHeaders`.
- Ensures token validity by invoking `Confirm-TokenState` before making the API request.
- Logs detailed messages for debugging and error handling.

Author: Tiago Balabuch
#>
function Get-FabricDomainTenantSettingOverrides {
    [CmdletBinding()]
    param ( )

    try {
        # Step 1: Validate authentication token before making API requests
        Confirm-TokenState

        # Step 2: Construct the API endpoint URL for retrieving domain tenant setting overrides
        $apiEndpointURI = "admin/domains/delegatedTenantSettingOverrides"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointURI" -Level Debug

        # Step 3: Invoke the Fabric API to retrieve domain tenant setting overrides
        $response = Invoke-FabricRestMethod `
            -Uri $apiEndpointURI `
            -Method Get

        # Step 4: Check if any domain tenant setting overrides were retrieved and handle results accordingly
        if ($response) {
            Write-Message -Message "Successfully retrieved domain tenant setting overrides." -Level Debug
            return $response
        } else {
            Write-Message -Message "No domain tenant setting overrides found." -Level Warning
            return $null
        }
    } catch {
        # Step 5: Log detailed error information if the API request fails
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Error retrieving domain tenant setting overrides: $errorDetails" -Level Error
    }
}
