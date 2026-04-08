function Get-FabricCapacityRefreshables {
    <#
.SYNOPSIS
Returns a list of refreshables for all capacities that the user has access to.

.DESCRIPTION
The Get-FabricCapacityRefreshables function returns refreshables (datasets with refresh activity)
for all capacities the user has access to. Power BI retains a seven-day refresh history for each
dataset, up to a maximum of 60 refreshes.

Requires scope: Capacity.Read.All or Capacity.ReadWrite.All

.PARAMETER top
Required. Returns only the first n results. Must be a positive integer (minimum: 1).

.PARAMETER expand
Optional. Accepts a comma-separated list of data types to expand inline in the response.
Supported values: 'capacity', 'group'.

.PARAMETER filter
Optional. Returns a subset of results based on an OData filter query condition.

.PARAMETER skip
Optional. Skips the first n results. Use together with -top to fetch results beyond the first 1000.

.EXAMPLE
    Retrieves the top 10 refreshables across all capacities.

    ```powershell
    Get-FabricCapacityRefreshables -top 10
    ```

.EXAMPLE
    Retrieves the top 5 refreshables with capacity details expanded.

    ```powershell
    Get-FabricCapacityRefreshables -top 5 -expand 'capacity'
    ```

.NOTES
Author: Ioana Bouariu

    #>

    # Define a mandatory parameter for the number of top refreshable capacities to retrieve.
    Param (
        [Parameter(Mandatory = $false)]
        [string]$top = 5
    )

    Confirm-TokenState

    # Make a GET request to the PowerBI API to retrieve the top refreshable capacities.
    # The function returns the 'value' property of the response.
    $result = Invoke-FabricRestMethod -Method GET -PowerBIApi -Uri "capacities/refreshables?`$top=$top"
    $result.value
}
