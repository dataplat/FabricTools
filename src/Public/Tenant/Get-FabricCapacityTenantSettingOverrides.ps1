function Get-FabricCapacityTenantSettingOverrides {
    <#
    .SYNOPSIS
    Retrieves tenant setting overrides for a specific capacity or all capacities in the Fabric tenant.

    .DESCRIPTION
    The `Get-FabricCapacityTenantSettingOverrides` function retrieves tenant setting overrides for a specific capacity or all capacities in the Fabric tenant by making a GET request to the appropriate API endpoint. If a `capacityId` is provided, the function retrieves overrides for that specific capacity. Otherwise, it retrieves overrides for all capacities.

    .PARAMETER capacityId
    The ID of the capacity for which tenant setting overrides should be retrieved. If not provided, overrides for all capacities will be retrieved.

    .EXAMPLE
        Returns all capacities tenant setting overrides.

        ```powershell
        Get-FabricCapacityTenantSettingOverrides
        ```

    .EXAMPLE
        Returns tenant setting overrides for the capacity with ID "12345".

        ```powershell
        Get-FabricCapacityTenantSettingOverrides -capacityId "12345"
        ```

    .NOTES
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$CapacityId
    )

    try {
        # Validate authentication token before making API requests
        Confirm-TokenState

        # Construct the API endpoint URL for retrieving capacity tenant setting overrides
        if ($CapacityId) {
            $apiEndpointUrl = "admin/capacities/{0}/delegatedTenantSettingOverrides" -f $CapacityId
        } else {
            $apiEndpointUrl = "admin/capacities/delegatedTenantSettingOverrides"
        }
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            HandleResponse = $true
            ExtractValue   = 'True'
            TypeName       = 'CapacityTenantSettingOverride'
        }
        $response = Invoke-FabricRestMethod @apiParams

        # Check if any capacity tenant setting overrides were retrieved and handle results accordingly
        if ($response) {
            Write-Message -Message "Successfully retrieved capacity tenant setting overrides." -Level Debug
            return $response
        } else {
            Write-Message -Message "No capacity tenant setting overrides found." -Level Warning
            return $null
        }
    } catch {
        # Log detailed error information if the API request fails
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Error retrieving capacity tenant setting overrides: $errorDetails" -Level Error
    }
}
