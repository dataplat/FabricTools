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
    Author: Tiago Balabuch, Kamil Nowinski
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
        $apiEndpointUrl = "admin/tenantsettings"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Invoke the Fabric API to retrieve tenant settings
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            ExtractValue   = 'Auto'
            HandleResponse = $true
        }
        $settings = Invoke-FabricRestMethod @apiParams

        # Filter tenant settings based on the provided SettingTitle parameter (if specified)
        if ($SettingTitle) {
            Write-Message -Message "Filtering tenant settings by title: '$SettingTitle'" -Level Debug
            $filteredSettings = $settings | Where-Object { $_.title -eq $SettingTitle }
            if ($filteredSettings) {
                Write-Message -Message "Tenant settings successfully retrieved." -Level Debug
                return $filteredSettings
            } else {
                Write-Message -Message "No tenant settings found matching the specified criteria." -Level Warning
                return $null
            }
        } else {
            Write-Message -Message "No filter specified. Retrieving all tenant settings." -Level Debug
            return $settings
        }
    } catch {
        # Log detailed error information if the API request fails
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Error retrieving tenant settings: $errorDetails" -Level Error
    }
}
