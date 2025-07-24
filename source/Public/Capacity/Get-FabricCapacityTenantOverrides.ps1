function Get-FabricCapacityTenantOverrides {
    <#
.SYNOPSIS
Retrieves the tenant overrides for all capacities.

.DESCRIPTION
The Get-FabricCapacityTenantOverrides function retrieves the tenant overrides for all capacities. It supports multiple aliases for flexibility.

.EXAMPLE
    This example retrieves the tenant overrides for all capacities.

    ```powershell
    Get-FabricCapacityTenantOverrides
    ```

.NOTES
The function retrieves the PowerBI access token and makes a GET request to the Fabric API to retrieve the tenant overrides for all capacities. It then returns the response of the GET request.

Author: Ioana Bouariu

    #>

    # This function retrieves the tenant overrides for all capacities.
    # Define aliases for the function for flexibility.
    [Alias("Get-FabCapacityTenantOverrides")]

    Param (
    )

    Confirm-TokenState

    # Make a GET request to the Fabric API to retrieve the tenant overrides for all capacities.
    # The function returns the response of the GET request.
    return Invoke-RestMethod -uri "$($FabricSession.BaseApiUrl)/admin/capacities/delegatedTenantSettingOverrides" -Headers $FabricSession.HeaderParams -Method GET
}
