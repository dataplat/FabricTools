function Suspend-FabricCapacity {
        <#
.SYNOPSIS
Suspends a capacity.

.DESCRIPTION
The Suspend-FabricCapacity function suspends a capacity. It supports multiple aliases for flexibility.

.PARAMETER subscriptionID
The ID of the subscription. This is a mandatory parameter. This is a parameter found in Azure, not Fabric.

.PARAMETER resourcegroup
The resource group. This is a mandatory parameter. This is a parameter found in Azure, not Fabric.

.PARAMETER capacity
The the capacity. This is a mandatory parameter. This is a parameter found in Azure, not Fabric.

.EXAMPLE
    This example suspends a capacity given the subscription ID, resource group, and capacity.

    ```powershell
    Suspend-FabricCapacity -subscriptionID "your-subscription-id" -resourcegroupID "your-resource-group" -capacityID "your-capacity"
    ```

.NOTES
The function defines parameters for the subscription ID, resource group, and capacity. If the 'azToken' environment variable is null, it connects to the Azure account and sets the 'azToken' environment variable. It then defines the headers for the request, defines the URI for the request, and makes a GET request to the URI.

Author: Ioana Bouariu

    #>
    # Define aliases for the function for flexibility.
    [Alias("Suspend-PowerBICapacity", "Suspend-FabCapacity")]
    [CmdletBinding(SupportsShouldProcess)]

    # Define parameters for the subscription ID, resource group, and capacity.
    Param (
        [Parameter(Mandatory = $true)]
        [guid]$subscriptionID,
        [Parameter(Mandatory = $true)]
        [string]$resourcegroup,
        [Parameter(Mandatory = $true)]
        [string]$capacity
    )

    Confirm-TokenState

    # Define the URI for the request.
    $suspendCapacity = "$($AzureSession.BaseApiUrl)/subscriptions/$subscriptionID/resourceGroups/$resourcegroup/providers/Microsoft.Fabric/capacities/$capacity/suspend?api-version=2023-11-01"

    # Make a GET request to the URI and return the response.
    if ($PSCmdlet.ShouldProcess("Suspend capacity $capacity")) {
        return Invoke-RestMethod -Method POST -Uri $suspendCapacity -Headers $script:AzureSession.HeaderParams -ErrorAction Stop
    }

}
