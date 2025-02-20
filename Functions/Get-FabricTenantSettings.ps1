
<#
.SYNOPSIS
Retrieves the tenant settings from the Fabric API.

.DESCRIPTION
The Get-FabricTenantSettings function makes a GET request to the Fabric API to retrieve the tenant settings. It returns the 'tenantSettings' property of the first item in the response.

.PARAMETER None
This function does not have any parameters.

.EXAMPLE
Get-FabricTenantSettings
Retrieves the tenant settings from the Fabric API.

#>

function Get-FabricTenantSettings  {
    [Alias("Get-FabTenantSettings")]
    Param ()
    $reply = Invoke-FabricAPIRequest -uri  "admin/tenantsettings"  -Method GET

    return $reply[0].tenantSettings
}