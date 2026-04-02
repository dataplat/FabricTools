function Get-FabricTenantSetting {
    <#
    .SYNOPSIS
    Retrieves tenant settings from the Fabric environment.

    .DESCRIPTION
    The `Get-FabricTenantSetting` function retrieves tenant settings for a Fabric environment by making a GET request to the appropriate API endpoint. Optionally, it filters the results by the `SettingTitle` parameter.

    .PARAMETER SettingTitle
    (Optional) The title of a specific tenant setting to filter the results.

    .EXAMPLE
        Returns all tenant settings.

        ```powershell
        Get-FabricTenantSetting
        ```

    .EXAMPLE
        Returns the tenant setting with the title "SomeSetting".

        ```powershell
        Get-FabricTenantSetting -SettingTitle "SomeSetting"
        ```

    .NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Is-TokenExpired` to ensure token validity before making the API request.

    Author: Tiago Balabuch
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SettingTitle
    )

    try {
        # Validate authentication token before making API requests
        Write-Message -Message "Validating authentication token..." -Level Debug
        Confirm-TokenState
        Write-Message -Message "Authentication token is valid." -Level Debug

        # Construct the API endpoint URL for retrieving tenant settings
        $apiEndpointURI = "admin/tenantsettings"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointURI" -Level Debug

        # Invoke the Fabric API to retrieve tenant settings
        $response = Invoke-FabricRestMethod `
            -Uri $apiEndpointURI `
            -Method Get

        # Filter tenant settings based on the provided SettingTitle parameter (if specified)
        $settings = if ($SettingTitle) {
            Write-Message -Message "Filtering tenant settings by title: '$SettingTitle'" -Level Debug
            $response.tenantSettings | Where-Object { $_.title -eq $SettingTitle }
        } else {
            Write-Message -Message "No filter specified. Retrieving all tenant settings." -Level Debug
            $response.tenantSettings
        }

        # Check if any tenant settings were found and return results accordingly
        if ($settings) {
            Write-Message -Message "Tenant settings successfully retrieved." -Level Debug
            return $settings
        } else {
            Write-Message -Message "No tenant settings found matching the specified criteria." -Level Warning
            return $null
        }
    } catch {
        # Log detailed error information if the API request fails
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Error retrieving tenant settings: $errorDetails" -Level Error
    }
}
