function Update-FabricCapacity
{
    <#
    .SYNOPSIS
        Creates or updates a Microsoft Fabric capacity.

    .DESCRIPTION
        The `Update-FabricCapacity` function sends a PATCH request to the Microsoft Fabric API to create or update a capacity
        in the specified Azure subscription and resource group. It supports parameters for capacity administration,
        SKU details, and optional tags.

    .PARAMETER SubscriptionId
        The ID of the target subscription. The value must be a UUID.

    .PARAMETER ResourceGroupName
        The name of the resource group. The name is case insensitive.

    .PARAMETER CapacityName
        The name of the Microsoft Fabric capacity. It must be a minimum of 3 characters, and a maximum of 63.
        Must match pattern: ^[a-z][a-z0-9]*$

    .PARAMETER SkuName
        The name of the SKU level (e.g., "F2").

    .PARAMETER AdministrationMembers
        An array of administrator user identities for the capacity administration.

    .PARAMETER Tags
        Optional resource tags as a hashtable.

    .PARAMETER NoWait
        If specified, the function will not wait for the operation to complete and will return immediately.

    .EXAMPLE
        ```powershell
        Update-FabricCapacity -SubscriptionId "548B7FB7-3B2A-4F46-BB02-66473F1FC22C" -ResourceGroupName "TestRG" -CapacityName "azsdktest" -SkuName "F2" -AdministrationMembers @("azsdktest@microsoft.com", "azsdktest2@microsoft.com")
        ```

    .EXAMPLE
        ```powershell
        Update-FabricCapacity -SubscriptionId "548B7FB7-3B2A-4F46-BB02-66473F1FC22C" -ResourceGroupName "TestRG" -CapacityName "azsdktest" -SkuName "F2" -AdministrationMembers @("admin@company.com") -Tags @{Environment="Production"; Owner="IT Team"}
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.
        - Uses Azure Resource Manager API endpoint for capacity management.

        Author: Kamil Nowinski

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$SubscriptionId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1, 90)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(3, 63)]
        [ValidatePattern('^[a-z][a-z0-9]*$')]
        [string]$CapacityName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SkuName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Location,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$AdministrationMembers,

        [Parameter(Mandatory = $false)]
        [hashtable]$Tags,

        [switch]$NoWait = $false
    )

    $SkuTier = "Fabric"

    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "$($AzureSession.BaseApiUrl)/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.Fabric/capacities/{2}?api-version=2023-11-01" -f $SubscriptionId, $ResourceGroupName, $CapacityName

        # Step 3: Construct the request body
        $body = @{
            properties = @{
                administration = @{
                    members = $AdministrationMembers
                }
            }
            sku = @{
                name = $SkuName
                tier = $SkuTier
            }
            location = $Location
        }

        if ($Tags)
        {
            $body.tags = $Tags
        }

        # Step 4: Make the API request
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Update Fabric Capacity"))
        {
            $apiParams = @{
                Uri = $apiEndpointUrl
                Method = 'PUT'
                Body = $body
                TypeName = 'Fabric Capacity'
                NoWait = $NoWait
                HandleResponse = $true
                ObjectIdOrName = $CapacityName
            }
            $response = Invoke-FabricRestMethod @apiParams
            $response
        }
    }
    catch
    {
        # Step 5: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update Fabric Capacity. Error: $errorDetails" -Level Error
        throw
    }
}
