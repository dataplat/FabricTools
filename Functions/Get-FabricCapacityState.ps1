<#
.SYNOPSIS
Retrieves the state of a specific capacity.

.DESCRIPTION
The Get-FabricCapacityState function retrieves the state of a specific capacity. It supports multiple aliases for flexibility.

.PARAMETER subscriptionID
The ID of the subscription. This is a mandatory parameter. This is a parameter found in Azure, not Fabric.

.PARAMETER resourcegroup
The resource group. This is a mandatory parameter. This is a parameter found in Azure, not Fabric.

.PARAMETER capacity
The capacity. This is a mandatory parameter. This is a parameter found in Azure, not Fabric.

.EXAMPLE
Get-FabricCapacityState -subscriptionID "your-subscription-id" -resourcegroupID "your-resource-group" -capacityID "your-capacity"

This example retrieves the state of a specific capacity given the subscription ID, resource group, and capacity.

.NOTES
The function checks if the Azure token is null. If it is, it connects to the Azure account and retrieves the token. It then defines the headers for the GET request and the URL for the GET request. Finally, it makes the GET request and returns the response.
#>

# This function retrieves the state of a specific capacity.
function Get-FabricCapacityState {
    # Define aliases for the function for flexibility.
    [Alias("Get-FabCapacityState")]

    # Define mandatory parameters for the subscription ID, resource group, and capacity.
    Param (
        [Parameter(Mandatory=$true)]
        [string]$subscriptionID,
        [Parameter(Mandatory=$true)]
        [string]$resourcegroup,
        [Parameter(Mandatory=$true)]
        [string]$capacity
    )

    # Check if the Azure token is null.
    if ($null -eq $env:azToken) {
        # If it is, connect to the Azure account and retrieve the token.
        Connect-azaccount -Subscription $subscriptionID
        $env:aztoken = "Bearer "+(get-azAccessToken).Token
    }

    # Define the headers for the GET request.
    $headers = @{"Authorization"=$env:aztoken}

    # Define the URL for the GET request.
    $getCapacityState = "https://management.azure.com/subscriptions/$subscriptionID/resourceGroups/$resourcegroup/providers/Microsoft.Fabric/capacities/$capacity/?api-version=2022-07-01-preview"

    # Make the GET request and return the response.
    return Invoke-RestMethod -Method GET -Uri $getCapacityState -Headers $headers -ErrorAction Stop
}