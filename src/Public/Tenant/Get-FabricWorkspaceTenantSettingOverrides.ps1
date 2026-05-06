function Get-FabricWorkspaceTenantSettingOverrides {
    <#
    .SYNOPSIS
        Retrieves tenant setting overrides for all workspaces in the Fabric tenant.

    .DESCRIPTION
        The `Get-FabricWorkspaceTenantSettingOverrides` function retrieves tenant setting overrides for all workspaces in the Fabric tenant by making a GET request to the appropriate API endpoint. The function validates the authentication token before making the request and handles the response accordingly.

    .EXAMPLE
        Returns all workspaces tenant setting overrides.

        ```powershell
        Get-FabricWorkspaceTenantSettingOverrides
        ```

    .NOTES
        Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding()]
    param ( )

    try {
        # Validate authentication token before making API requests
        Confirm-TokenState

        # Construct the API endpoint URL for retrieving workspaces tenant setting overrides
        $apiEndpointUrl = "admin/workspaces/delegatedTenantSettingOverrides"

        # Invoke the Fabric API to retrieve workspaces tenant setting overrides
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            ExtractValue   = 'Auto'
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams

        Write-Message -Message "Successfully retrieved workspaces tenant setting overrides." -Level Debug
        return $response
    } catch {
        # Log detailed error information if the API request fails
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Error retrieving workspaces tenant setting overrides: $errorDetails" -Level Error
    }
}
