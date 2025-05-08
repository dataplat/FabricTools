<#
.SYNOPSIS
Retrieves tenant setting overrides for a specific capacity or all capacities in the Fabric tenant.

.DESCRIPTION
The `Get-FabricCapacityTenantSettingOverrides` function retrieves tenant setting overrides for a specific capacity or all capacities in the Fabric tenant by making a GET request to the appropriate API endpoint. If a `capacityId` is provided, the function retrieves overrides for that specific capacity. Otherwise, it retrieves overrides for all capacities.

.PARAMETER capacityId
The ID of the capacity for which tenant setting overrides should be retrieved. If not provided, overrides for all capacities will be retrieved.

.EXAMPLE
Get-FabricCapacityTenantSettingOverrides

Returns all capacities tenant setting overrides.

.EXAMPLE
Get-FabricCapacityTenantSettingOverrides -capacityId "12345"

Returns tenant setting overrides for the capacity with ID "12345".

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Test-TokenExpired` to ensure token validity before making the API request.

Author: Tiago Balabuch
#>
function Get-FabricCapacityTenantSettingOverrides {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$capacityId
    )

    try {
        # Step 1: Validate authentication token before making API requests
        Write-Message -Message "Validating authentication token..." -Level Debug
        Test-TokenExpired
        Write-Message -Message "Authentication token is valid." -Level Debug

        # Step 2: Construct the API endpoint URL for retrieving capacity tenant setting overrides
        if ($capacityId) {
            $apiEndpointURI = "{0}/admin/capacities/{1}/delegatedTenantSettingOverrides" -f $FabricConfig.BaseUrl, $capacityId
            $message = "Successfully retrieved tenant setting overrides for capacity ID: $capacityId."
        } else {
            $apiEndpointURI = "{0}/admin/capacities/delegatedTenantSettingOverrides" -f $FabricConfig.BaseUrl
            $message = "Successfully retrieved capacity tenant setting overrides."
        }
        Write-Message -Message "Constructed API Endpoint: $apiEndpointURI" -Level Debug

        # Step 3: Invoke the Fabric API to retrieve capacity tenant setting overrides
        $response = Invoke-FabricAPIRequest `
            -BaseURI $apiEndpointURI `
            -Headers $FabricConfig.FabricHeaders `
            -Method Get 

        # Step 4: Check if any capacity tenant setting overrides were retrieved and handle results accordingly
        if ($response) {
            Write-Message -Message $message -Level Debug
            return $response
        }
        else {
            Write-Message -Message "No capacity tenant setting overrides found." -Level Warning
            return $null
        }
    }
    catch {
        # Step 5: Log detailed error information if the API request fails
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Error retrieving capacity tenant setting overrides: $errorDetails" -Level Error
    }
}