function Get-FabricCapacitySkus {
    <#
.SYNOPSIS
Retrieves the fabric capacity information.

.DESCRIPTION
This function makes a GET request to the Fabric API to retrieve the tenant settings.

.PARAMETER subscriptionID
Specifies the subscription ID for the Azure subscription.

.PARAMETER ResourceGroupName
Specifies the name of the resource group in which the Fabric capacity is located.

.PARAMETER capacity
Specifies the capacity to retrieve information for. If not provided, all capacities will be retrieved.

.EXAMPLE
    Retrieves the fabric capacity information for the specified capacity.

    ```powershell
    Get-FabricCapacitySkus -capacity "exampleCapacity"
    ```

.NOTES

Author: Kamil Nowinski

#>

    Param(
        [Parameter(Mandatory = $true)]
        [guid]$subscriptionID,
        [Parameter(Mandatory = $true)]
        [string]$ResourceGroupName,
        [Parameter(Mandatory = $true)]
        [string]$capacity
    )

    Confirm-TokenState

    #GET https://management.azure.com/subscriptions/548B7FB7-3B2A-4F46-BB02-66473F1FC22C/resourceGroups/TestRG/providers/Microsoft.Fabric/capacities/azsdktest/skus?api-version=2023-11-01
    $uri = "$($AzureSession.BaseApiUrl)/subscriptions/$subscriptionID/resourceGroups/$ResourceGroupName/providers/Microsoft.Fabric/capacities/$capacity/skus?api-version=2023-11-01"
    $result = Invoke-RestMethod -Headers $AzureSession.HeaderParams -Uri $uri -Method GET

    return $result.value

}
