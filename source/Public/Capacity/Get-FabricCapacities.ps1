<#
.SYNOPSIS
    This function retrieves all resources of type "Microsoft.Fabric/capacities" from all resource groups in a given subscription or all subscriptions if no subscription ID is provided.

.DESCRIPTION
    The Get-AllFabricCapacities function is used to retrieve all resources of type "Microsoft.Fabric/capacities" from all resource groups in a given subscription or all subscriptions if no subscription ID is provided. It uses the Az module to interact with Azure.

.PARAMETER subscriptionID
    An optional parameter that specifies the subscription ID. If this parameter is not provided, the function will retrieve resources from all subscriptions.

.EXAMPLE
    Get-AllFabricCapacities -subscriptionID "12345678-1234-1234-1234-123456789012"

    This command retrieves all resources of type "Microsoft.Fabric/capacities" from all resource groups in the subscription with the ID "12345678-1234-1234-1234-123456789012".

.EXAMPLE
    Get-AllFabricCapacities

    This command retrieves all resources of type "Microsoft.Fabric/capacities" from all resource groups in all subscriptions.

.NOTES
    Alias: Get-AllFabCapacities
#>
function Get-FabricCapacities {
    # Define aliases for the function for flexibility.

    # Define parameters for the function
    Param (
        # Optional parameter for subscription ID
        [Parameter(Mandatory = $false)]
        [string]$subscriptionID
    )

    # Initialize an array to store the results
    $res = @()

    Test-TokenExpired

    # If a subscription ID is provided
    if ($subscriptionID) {
        # Set the context to the provided subscription ID
        Set-AzContext -SubscriptionId $subscriptionID | Out-Null

        # Get all resource groups in the subscription
        $rgs = Get-AzResourceGroup

        # For each resource group, get all resources of type "Microsoft.Fabric/capacities"
        foreach ($r in $rgs) {
            # Get all resources of type "Microsoft.Fabric/capacities" and add them to the results array
            $res += Get-AzResource -ResourceGroupName $r.ResourceGroupName -resourcetype "Microsoft.Fabric/capacities" -ErrorAction SilentlyContinue
        }
    } else {
        # If no subscription ID is provided, get all subscriptions
        $subscriptions = Get-AzSubscription

        # For each subscription, set the context to the subscription ID
        foreach ($sub in $subscriptions) {
            # Set the context to the subscription ID
            Set-AzContext -SubscriptionId $sub.id | Out-Null

            # Get all resource groups in the subscription
            $rgs = Get-AzResourceGroup

            # For each resource group, get all resources of type "Microsoft.Fabric/capacities"
            foreach ($r in $rgs) {
                # Get all resources of type "Microsoft.Fabric/capacities" and add them to the results array
                $res += Get-AzResource -ResourceGroupName $r.ResourceGroupName -ResourceType "Microsoft.Fabric/capacities" -ErrorAction SilentlyContinue
            }
        }
    }

    # Return the results
    return $res
}
