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
Suspend-FabricCapacity -subscriptionID "your-subscription-id" -resourcegroupID "your-resource-group" -capacityID "your-capacity"

This example suspends a capacity given the subscription ID, resource group, and capacity.

.NOTES
The function defines parameters for the subscription ID, resource group, and capacity. If the 'azToken' environment variable is null, it connects to the Azure account and sets the 'azToken' environment variable. It then defines the headers for the request, defines the URI for the request, and makes a GET request to the URI.
#>

# This function suspends a capacity.
function Suspend-FabricCapacity {
    # Define aliases for the function for flexibility.
    [Alias("Suspend-PowerBICapacity", "Suspend-FabCapacity")]
    [CmdletBinding(SupportsShouldProcess)]

    # Define parameters for the subscription ID, resource group, and capacity.
    Param (
        [Parameter(Mandatory = $true)]
        [string]$subscriptionID,
        [Parameter(Mandatory = $true)]
        [string]$resourcegroup,
        [Parameter(Mandatory = $true)]
        [string]$capacity
    )

    # If the 'azToken' environment variable is null, connect to the Azure account and set the 'azToken' environment variable.
    if ($null -eq $env:azToken) {
        Connect-azaccount -Subscription $subscriptionID
        $env:aztoken = "Bearer " + (get-azAccessToken).Token
    }

    # Define the headers for the request.
    $headers = @{"Authorization" = $env:aztoken }

    # Define the URI for the request.
    $suspendCapacity = "https://management.azure.com/subscriptions/$subscriptionID/resourceGroups/$resourcegroup/providers/Microsoft.Fabric/capacities/$capacity/suspend?api-version=2022-07-01-preview"

    # Make a GET request to the URI and return the response.
    if($PSCmdlet.ShouldProcess("Suspend capacity $capacity")) {
        return Invoke-RestMethod -Method POST -Uri $suspendCapacity -Headers $headers -ErrorAction Stop
    }

}