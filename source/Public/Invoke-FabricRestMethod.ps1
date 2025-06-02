Function Invoke-FabricRestMethod {

<#
.SYNOPSIS
    Sends an HTTP request to a Fabric API endpoint and retrieves the response.

.DESCRIPTION
    The Invoke-FabricRestMethod function is used to send an HTTP request to a Fabric API endpoint and retrieve the response.

.PARAMETER uri
    The URI of the Fabric API endpoint to send the request to.

.PARAMETER Method
    The HTTP method to be used for the request. Valid values are 'GET', 'POST', 'DELETE', 'PUT', and 'PATCH'. The default value is 'GET'.

.PARAMETER Body
    The body of the request, if applicable.

.EXAMPLE
    Invoke-FabricRestMethod -uri "/api/resource" -method "GET"

    This example sends a GET request to the "/api/resource" endpoint of the Fabric API.

.EXAMPLE
    Invoke-FabricRestMethod -uri "/api/resource" -method "POST" -body $requestBody

    This example sends a POST request to the "/api/resource" endpoint of the Fabric API with a request body.

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl`.

Author: Kamil Nowinski
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Uri,

        [Parameter(Mandatory = $false)]
        [ValidateSet('GET', 'POST', 'DELETE', 'PUT', 'PATCH')]
        [string] $Method = "GET",

        [Parameter(Mandatory = $false)]
        $Body
    )

    Test-TokenExpired

    if ($Uri -notmatch '^https?://.*') {
        $Uri = "{0}/{1}" -f $FabricConfig.BaseUrl, $Uri
    }
    Write-Message -Message "Fabric API Endpoint: $Uri" -Level Verbose

    $response = Invoke-RestMethod `
        -Headers $FabricSession.HeaderParams `
        -Uri $Uri `
        -Method $Method `
        -Body $Body `
        -ContentType "application/json" `
        -ErrorAction 'Stop' `
        -SkipHttpErrorCheck `
        -ResponseHeadersVariable "responseHeader" `
        -StatusCodeVariable "statusCode"

    $script:statusCode = $statusCode
    $script:responseHeader = $responseHeader

    return $response
}
