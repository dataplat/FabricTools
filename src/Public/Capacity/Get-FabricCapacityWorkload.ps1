function Get-FabricCapacityWorkload {
    <#
.SYNOPSIS
Retrieves the workloads for a specific capacity.

.DESCRIPTION
The Get-FabricCapacityWorkload function retrieves the workloads for a specific capacity. It supports multiple aliases for flexibility.

.PARAMETER capacityID
The ID of the capacity. This is a mandatory parameter.

.EXAMPLE
    This example retrieves the workloads for a specific capacity given the capacity ID and authentication token.

    ```powershell
    Get-FabricCapacityWorkload -capacityID "your-capacity-id"
    ```

.NOTES
The function retrieves the PowerBI access token and makes a GET request to the PowerBI API to retrieve the workloads for the specified capacity. It then returns the 'value' property of the response, which contains the workloads.

Author: Ioana Bouariu

    #>

    # This function retrieves the workloads for a specific capacity.
    # Define aliases for the function for flexibility.
    # Define a mandatory parameter for the capacity ID.
    Param (
        [Parameter(Mandatory = $true)]
        [guid]$CapacityId
    )

    Confirm-TokenState

    # Make a GET request to the PowerBI API to retrieve the workloads for the specified capacity.
    $apiParams = @{
        Uri            = "capacities/$capacityID/Workloads"
        Method         = 'Get'
        ApiType        = 'PowerBI'
        TypeName       = 'Capacity Workload'
        ObjectIdOrName = $capacityID
        HandleResponse = $true
        ExtractValue   = 'True'
    }
    Invoke-FabricRestMethod @apiParams
}


#https://learn.microsoft.com/en-us/rest/api/power-bi/capacities/get-workloads
