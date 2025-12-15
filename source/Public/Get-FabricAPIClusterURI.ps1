function Get-FabricAPIclusterURI {
    <#
.SYNOPSIS
    Retrieves the cluster URI for the tenant.

.DESCRIPTION
    The Get-FabricAPIclusterURI function retrieves the cluster URI for the tenant.

.EXAMPLE
    Get-FabricAPIclusterURI

    This example retrieves the cluster URI for the tenant.

.NOTES
    The function retrieves the PowerBI access token and makes a GET request to the PowerBI API to retrieve the datasets.
    It then extracts the '@odata.context' property from the response, splits it on the '/' character, and selects the third element.
    This element is used to construct the cluster URI, which is then returned by the function.

    Author: Ioana Bouariu

    #>

    [CmdletBinding()]
    [OutputType([string])]
    Param (
    )

    Confirm-TokenState

    # Make a GET request to the PowerBI API to retrieve the datasets.
    $reply = Invoke-FabricRestMethod -Method GET -PowerBIApi -Uri "datasets"

    # Extract the '@odata.context' property from the response.
    $unaltered = $reply.'@odata.context'

    # Split the '@odata.context' property on the '/' character and select the third element.
    $stripped = $unaltered.split('/')[2]

    # Construct the cluster URI.
    $clusterURI = "https://$stripped/beta/myorg/groups"

    # Return the cluster URI.
    return $clusterURI
}
