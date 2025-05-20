<#
.SYNOPSIS
Removes a tenant setting override from a specific capacity in the Fabric tenant.

.DESCRIPTION
The `Revoke-FabricCapacityTenantSettingOverrides` function deletes a specific tenant setting override for a given capacity in the Fabric tenant by making a DELETE request to the appropriate API endpoint.

.PARAMETER capacityId
The unique identifier of the capacity from which the tenant setting override will be removed.

.PARAMETER tenantSettingName
The name of the tenant setting override to be removed.

.EXAMPLE
Revoke-FabricCapacityTenantSettingOverrides -capacityId "12345" -tenantSettingName "ExampleSetting"

Removes the tenant setting override named "ExampleSetting" from the capacity with ID "12345".

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Test-TokenExpired` to ensure token validity before making the API request.

Author: Tiago Balabuch
#>
function Revoke-FabricCapacityTenantSettingOverrides {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$capacityId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$tenantSettingName
    )
    try {
        # Step 1: Validate authentication token before making API requests
        Write-Message -Message "Validating authentication token..." -Level Debug
        Test-TokenExpired
        Write-Message -Message "Authentication token is valid." -Level Debug

        # Step 2: Construct the API endpoint URL for retrieving capacity tenant setting overrides
        $apiEndpointURI = "{0}/admin/capacities/{1}/delegatedTenantSettingOverrides/{2}" -f $FabricConfig.BaseUrl, $capacityId, $tenantSettingName
        Write-Message -Message "Constructed API Endpoint: $apiEndpointURI" -Level Debug

        if ($PSCmdlet.ShouldProcess("$tenantSettingName" , "Revoke")) {
        # Step 3: Invoke the Fabric API to retrieve capacity tenant setting overrides
        $response = Invoke-FabricAPIRequest `
            -BaseURI $apiEndpointURI `
            -Headers $FabricConfig.FabricHeaders `
            -Method Delete
        }
        Write-Message -Message "Successfully removed the tenant setting override '$tenantSettingName' from the capacity with ID '$capacityId'." -Level Info
        return $response
    } catch {
        # Step 5: Log detailed error information if the API request fails
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Error retrieving capacity tenant setting overrides: $errorDetails" -Level Error
    }
}
