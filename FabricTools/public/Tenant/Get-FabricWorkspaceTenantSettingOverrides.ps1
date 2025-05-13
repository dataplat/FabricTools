<#
.SYNOPSIS
Retrieves tenant setting overrides for all workspaces in the Fabric tenant.

.DESCRIPTION
The `Get-FabricWorkspaceTenantSettingOverrides` function retrieves tenant setting overrides for all workspaces in the Fabric tenant by making a GET request to the appropriate API endpoint. The function validates the authentication token before making the request and handles the response accordingly.

.EXAMPLE
Get-FabricWorkspaceTenantSettingOverrides

Returns all workspaces tenant setting overrides.

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Test-TokenExpired` to ensure token validity before making the API request.

Author: Tiago Balabuch
#>
function Get-FabricWorkspaceTenantSettingOverrides {
    [CmdletBinding()]
    param ( )

    try {
        # Step 1: Validate authentication token before making API requests
        Write-Message -Message "Validating authentication token..." -Level Debug
        Test-TokenExpired
        Write-Message -Message "Authentication token is valid." -Level Debug

        # Step 2: Construct the API endpoint URL for retrieving workspaces tenant setting overrides
        $apiEndpointURI = "{0}/admin/workspaces/delegatedTenantSettingOverrides" -f $FabricConfig.BaseUrl
        Write-Message -Message "Constructed API Endpoint: $apiEndpointURI" -Level Debug

        # Step 3: Invoke the Fabric API to retrieve workspaces tenant setting overrides
        $response = Invoke-FabricAPIRequest `
            -BaseURI $apiEndpointURI `
            -Headers $FabricConfig.FabricHeaders `
            -Method Get 

        # Step 4: Check if any workspaces tenant setting overrides were retrieved and handle results accordingly
        if ($response) {
            Write-Message -Message "Successfully retrieved workspaces tenant setting overrides." -Level Debug
            return $response
        }
        else {
            Write-Message -Message "No workspaces tenant setting overrides found." -Level Warning
            return $null
        }
    }
    catch {
        # Step 5: Log detailed error information if the API request fails
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Error retrieving workspaces tenant setting overrides: $errorDetails" -Level Error
    }
}