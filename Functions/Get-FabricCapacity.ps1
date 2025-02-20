<#
.SYNOPSIS
Retrieves the fabric capacity information.

.DESCRIPTION
This function makes a GET request to the Fabric API to retrieve the tenant settings.

.PARAMETER capacity
Specifies the capacity to retrieve information for. If not provided, all capacities will be retrieved.

.EXAMPLE
Get-FabricCapacity -capacity "exampleCapacity"
Retrieves the fabric capacity information for the specified capacity.

Get-FabricCapacity
Retrieves the fabric capacity information for all capacities.

#>

function Get-FabricCapacity  {
    # Define aliases for the function for flexibility.
    [Alias("Get-FabCapacity")]

    Param(
        [Parameter(Mandatory=$false)]
        [string]$capacity
    )

    if ($capacity) {
        return Invoke-FabricAPIRequest -uri "capacities/$capacity" -Method GET
    } else {
        return Invoke-FabricAPIRequest -uri "capacities" -Method GET
    }


}