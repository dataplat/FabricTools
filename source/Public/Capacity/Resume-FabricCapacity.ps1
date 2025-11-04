function Resume-FabricCapacity {
    <#
    .SYNOPSIS
    Resumes a capacity.

    .DESCRIPTION
    The Resume-FabricCapacity function resumes a capacity. It supports multiple aliases for flexibility.

    .PARAMETER SubscriptionID
    The the ID of the subscription. This is a mandatory parameter. This is a parameter found in Azure, not Fabric.

    .PARAMETER ResourceGroup
    The resource group. This is a mandatory parameter. This is a parameter found in Azure, not Fabric.

    .PARAMETER capacity
    The capacity. This is a mandatory parameter. This is a parameter found in Azure, not Fabric.

    .EXAMPLE
        This example resumes a capacity given the subscription ID, resource group, and capacity.

        ```powershell
        Resume-FabricCapacity -subscriptionID "your-subscription-id" -ResourceGroup "your-resource-group" -capacityID "your-capacity"
        ```

    .NOTES
    The function defines parameters for the subscription ID, resource group, and capacity. If the 'azToken' environment variable is null, it connects to the Azure account and sets the 'azToken' environment variable. It then defines the headers for the request, defines the URI for the request, and makes a GET request to the URI.

    Author: Ioana Bouariu
    #>
    # Define aliases for the function for flexibility.
    [Alias("Resume-FabCapacity")]
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

    # Define the URI for the request.
    $resumeCapacity = "$AzureBaseApiUrl/subscriptions/$SubscriptionID/resourceGroups/$ResourceGroup/providers/Microsoft.Fabric/capacities/$Capacity/resume?api-version=2022-07-01-preview"

    # Make a GET request to the URI and return the response.
    if ($PSCmdlet.ShouldProcess("Resume capacity $Capacity")) {
        return Invoke-RestMethod -Method POST -Uri $resumeCapacity -Headers $script:AzureSession.HeaderParams -ErrorAction Stop
    }
}
