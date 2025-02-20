<#
.SYNOPSIS
Retrieves the cluster URI for the tenant.

.DESCRIPTION
The Get-FabricAPIclusterURI function retrieves the cluster URI for the tenant. It supports multiple aliases for flexibility.

.EXAMPLE
Get-FabricAPIclusterURI

This example retrieves the cluster URI for the tenant.

.NOTES
The function retrieves the PowerBI access token and makes a GET request to the PowerBI API to retrieve the datasets. It then extracts the '@odata.context' property from the response, splits it on the '/' character, and selects the third element. This element is used to construct the cluster URI, which is then returned by the function.

#>

#This function retrieves the cluster URI for the tenant.


function Get-FabricAPIclusterURI  {
    # Define aliases for the function for flexibility.
    [Alias("Get-FabAPIClusterURI")]
    Param (
        [Parameter(Mandatory=$false)]
        [string]$authToken
    )

    if ([string]::IsNullOrEmpty($authToken)) {
        $authToken = Get-FabricAuthToken
    }

    $fabricHeaders = @{
        'Content-Type'  = $contentType
        'Authorization' = "Bearer {0}" -f $authToken
    }
    # Make a GET request to the PowerBI API to retrieve the datasets.
    $reply = Invoke-RestMethod -uri "https://api.powerbi.com/v1.0/myorg/datasets" -Headers $fabricHeaders -Method GET

    # Extract the '@odata.context' property from the response.
    $unaltered = $reply.'@odata.context'

    # Split the '@odata.context' property on the '/' character and select the third element.
    $stripped = $unaltered.split('/')[2]

    # Construct the cluster URI.
    $clusterURI = "https://$stripped/beta/myorg/groups"

    # Return the cluster URI.
    return $clusterURI
}