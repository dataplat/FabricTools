function Get-FabricDomainTenantSettingOverrides {
    <#
    .SYNOPSIS
    Retrieves tenant setting overrides for a specific domain or all capacities in the Fabric tenant.

    .DESCRIPTION
    The `Get-FabricDomainTenantSettingOverrides` function retrieves tenant setting overrides for all domains in the Fabric tenant by making a GET request to the designated API endpoint. The function ensures token validity before making the request and handles the response appropriately.

    .EXAMPLE
        Fetches tenant setting overrides for all domains in the Fabric tenant.

        ```powershell
        Get-FabricDomainTenantSettingOverrides
        ```

    .NOTES
    - Ensures token validity by invoking `Confirm-TokenState` before making the API request.

    Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding()]
    param ( )

    try {
        # Validate authentication token before making API requests
        Confirm-TokenState

        # Construct the API endpoint URL for retrieving domain tenant setting overrides
        $apiEndpointUrl = "admin/domains/delegatedTenantSettingOverrides"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            HandleResponse = $true
            ExtractValue   = 'True'
            TypeName       = 'DomainTenantSettingOverride'
        }
        $response = Invoke-FabricRestMethod @apiParams

        # Check if any domain tenant setting overrides were retrieved and handle results accordingly
        if ($response) {
            Write-Message -Message "Successfully retrieved domain tenant setting overrides." -Level Debug
            return $response
        } else {
            Write-Message -Message "No domain tenant setting overrides found." -Level Warning
            return $null
        }
    } catch {
        # Log detailed error information if the API request fails
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Error retrieving domain tenant setting overrides: $errorDetails" -Level Error
    }
}
