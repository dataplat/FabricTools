function Get-FabricCapacityTenantOverrides {
    <#
.SYNOPSIS
Retrieves the tenant overrides for all capacities.

.DESCRIPTION
The Get-FabricCapacityTenantOverrides function retrieves the tenant overrides for all capacities. It supports multiple aliases for flexibility.

.EXAMPLE
Get-FabricCapacityTenantOverrides

This example retrieves the tenant overrides for all capacities.

.NOTES
The function retrieves the PowerBI access token and makes a GET request to the Fabric API to retrieve the tenant overrides for all capacities. It then returns the response of the GET request.
    #>

    # This function retrieves the tenant overrides for all capacities.
    # Define aliases for the function for flexibility.
    [Alias("Get-FabCapacityTenantOverrides")]

    Param (
    )

    Test-TokenExpired

    # Make a GET request to the Fabric API to retrieve the tenant overrides for all capacities.
    # The function returns the response of the GET request.
    return Invoke-RestMethod -uri "$($FabricSession.BaseApiUrl)/admin/capacities/delegatedTenantSettingOverrides" -Headers $FabricSession.HeaderParams -Method GET
}
