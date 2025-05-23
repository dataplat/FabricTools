function Get-FabricCapacityWorkload {
    <#
.SYNOPSIS
Retrieves the workloads for a specific capacity.

.DESCRIPTION
The Get-FabricCapacityWorkload function retrieves the workloads for a specific capacity. It supports multiple aliases for flexibility.

.PARAMETER capacityID
The ID of the capacity. This is a mandatory parameter.

.EXAMPLE
Get-FabricCapacityWorkload -capacityID "your-capacity-id"

This example retrieves the workloads for a specific capacity given the capacity ID and authentication token.

.NOTES
The function retrieves the PowerBI access token and makes a GET request to the PowerBI API to retrieve the workloads for the specified capacity. It then returns the 'value' property of the response, which contains the workloads.
    #>

    # This function retrieves the workloads for a specific capacity.
    # Define aliases for the function for flexibility.
    [Alias("Get-FabCapacityWorkload")]

    # Define a mandatory parameter for the capacity ID.
    Param (
        [Parameter(Mandatory = $true)]
        [string]$capacityID
    )

    Test-TokenExpired

    # Make a GET request to the PowerBI API to retrieve the workloads for the specified capacity.
    # The function returns the 'value' property of the response.
    return (Invoke-RestMethod -uri "$($PowerBI.BaseApiUrl)/capacities/$capacityID/Workloads" -Headers $FabricSession.HeaderParams -Method GET).value
}


#https://learn.microsoft.com/en-us/rest/api/power-bi/capacities/get-workloads
