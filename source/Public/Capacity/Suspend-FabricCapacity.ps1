function Suspend-FabricCapacity {
    <#
.SYNOPSIS
Suspends a capacity.

.DESCRIPTION
The Suspend-FabricCapacity function suspends a capacity.

.PARAMETER SubscriptionID
The ID of the subscription. This is a mandatory parameter. This is a parameter found in Azure, not Fabric.

.PARAMETER ResourceGroup
The resource group. This is a mandatory parameter. This is a parameter found in Azure, not Fabric.

.PARAMETER Capacity
The the capacity. This is a mandatory parameter. This is a parameter found in Azure, not Fabric.

.EXAMPLE
    This example suspends a capacity given the subscription ID, resource group, and capacity.

    ```powershell
    Suspend-FabricCapacity -SubscriptionID "your-subscription-id" -ResourceGroup "your-resource-group" -Capacity "your-capacity"
    ```

.NOTES
The function defines parameters for the subscription ID, resource group, and capacity. If the 'azToken' environment variable is null, it connects to the Azure account and sets the 'azToken' environment variable. It then defines the headers for the request, defines the URI for the request, and makes a GET request to the URI.

Author: Ioana Bouariu

    #>
    [CmdletBinding(SupportsShouldProcess)]

    # Define parameters for the subscription ID, resource group, and capacity.
    Param (
        [Parameter(Mandatory = $true)]
        [guid]$SubscriptionID,
        [Parameter(Mandatory = $true)]
        [string]$ResourceGroup,
        [Parameter(Mandatory = $true)]
        [string]$Capacity
    )

    Confirm-TokenState

    $AzureBaseApiUrl = Get-PSFConfigValue 'FabricTools.AzureApi.BaseUrl'
    $headers = Get-PSFConfigValue 'FabricTools.AzureSession.Headers'

    # Define the URI for the request.
    $suspendCapacity = "$AzureBaseApiUrl/subscriptions/$SubscriptionID/resourceGroups/$ResourceGroup/providers/Microsoft.Fabric/capacities/$Capacity/suspend?api-version=2023-11-01"

    # Make a GET request to the URI and return the response.
    if ($PSCmdlet.ShouldProcess("Suspend capacity $capacity")) {
        return Invoke-RestMethod -Method POST -Uri $suspendCapacity -Headers $headers -ErrorAction Stop
    }

}
