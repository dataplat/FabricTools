<#
.SYNOPSIS
Retrieves the workloads for a specific capacity.

.DESCRIPTION
The Get-FabricCapacityWorkload function retrieves the workloads for a specific capacity. It supports multiple aliases for flexibility.

.PARAMETER capacityID
The ID of the capacity. This is a mandatory parameter.

.PARAMETER authToken
The authentication token to access the PowerBI API. If not provided, the function will retrieve the token using the Get-FabricAuthToken function.

.EXAMPLE
Get-FabricCapacityWorkload -capacityID "your-capacity-id" -authToken "your-auth-token"

This example retrieves the workloads for a specific capacity given the capacity ID and authentication token.

.NOTES
The function retrieves the PowerBI access token and makes a GET request to the PowerBI API to retrieve the workloads for the specified capacity. It then returns the 'value' property of the response, which contains the workloads.
#>

# This function retrieves the workloads for a specific capacity.
function Get-FabricCapacityWorkload  {
    # Define aliases for the function for flexibility.
    [Alias("Get-FabCapacityWorkload")]

    # Define a mandatory parameter for the capacity ID.
    Param (
        [Parameter(Mandatory=$true)]
        [string]$capacityID,
        [Parameter(Mandatory=$false)]
        [string]$authToken
    )
    if ([string]::IsNullOrEmpty($authToken)) {
        $authToken = Get-FabricAuthToken
    }

    $fabricHeaders = @{
        'Authorization' = "Bearer {0}" -f $authToken
    }

    # Make a GET request to the PowerBI API to retrieve the workloads for the specified capacity.
    # The function returns the 'value' property of the response.
    return (Invoke-RestMethod -uri "https://api.powerbi.com/v1.0/myorg/capacities/$capacityID/Workloads" -Headers $fabricHeaders -Method GET).value
}