function Get-FabricCapacityState {
    <#
.SYNOPSIS
Retrieves the state of a specific capacity.

.DESCRIPTION
The Get-FabricCapacityState function retrieves the state of a specific capacity.

.PARAMETER SubscriptionID
The ID of the subscription. This is a mandatory parameter. This is a parameter found in Azure, not Fabric.

.PARAMETER ResourceGroup
The resource group. This is a mandatory parameter. This is a parameter found in Azure, not Fabric.

.PARAMETER Capacity
The capacity. This is a mandatory parameter. This is a parameter found in Azure, not Fabric.

.EXAMPLE
    This example retrieves the state of a specific capacity given the subscription ID, resource group, and capacity.

    ```powershell
    Get-FabricCapacityState -SubscriptionID "your-subscription-id" -ResourceGroup "your-resource-group" -Capacity "your-capacity"
    ```

.NOTES
The function checks if the Azure token is null. If it is, it connects to the Azure account and retrieves the token.
It then defines the headers for the GET request and the URL for the GET request. Finally, it makes the GET request and returns the response.

Author: Ioana Bouariu

    #>

    # This function retrieves the state of a specific capacity.

    # Define mandatory parameters for the subscription ID, resource group, and capacity.
    Param (
        [Parameter(Mandatory = $true)]
        [guid]$SubscriptionID,
        [Parameter(Mandatory = $true)]
        [string]$ResourceGroup,
        [Parameter(Mandatory = $true)]
        [string]$capacity
    )

    Confirm-TokenState

    $AzureBaseApiUrl = Get-PSFConfigValue 'FabricTools.AzureApi.BaseUrl'
    $headers = Get-PSFConfigValue 'FabricTools.AzureSession.Headers'

    # Define the URL for the GET request.
    $getCapacityState = "$AzureBaseApiUrl/subscriptions/$SubscriptionID/resourceGroups/$ResourceGroup/providers/Microsoft.Fabric/capacities/$Capacity/?api-version=2022-07-01-preview"

    # Make the GET request and return the response.
    return Invoke-RestMethod -Method GET -Uri $getCapacityState -Headers $headers -ErrorAction Stop
}
