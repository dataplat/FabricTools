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
    The body of the request, if applicable. This can be a hashtable or a string. If a hashtable is provided, it will be converted to JSON format.

.PARAMETER TestTokenExpired
    A switch parameter to test if the Fabric token is expired before making the request. If the token is expired, it will attempt to refresh it.

.PARAMETER PowerBIApi
    A switch parameter to indicate that the request should be sent to the Power BI API instead of the Fabric API.

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
        $Body,

        [switch] $TestTokenExpired,

        [switch] $PowerBIApi
    )

    Write-Message -Message "[Invoke-FabricRestMethod]::Begin" -Level Debug

    if ($TestTokenExpired) {
        Confirm-TokenState
    }

    $baseUrl = $FabricConfig.BaseUrl
    if ($PowerBIApi) {
        $baseUrl = Get-PSFConfigValue -FullName 'FabricTools.PowerBiApi.BaseUrl'
    }

    if ($Uri -notmatch '^https?://.*') {
        $Uri = "{0}/{1}" -f $baseUrl, $Uri
    } elseif ($PowerBIApi) {
        Write-Message -Message "PowerBIApi param is ignored when full Uri is provided." -Level Warning
    }
    Write-Message -Message "Target API Endpoint: $Uri" -Level Verbose

    if ($Body -is [hashtable]) {
        $Body = $Body | ConvertTo-Json -Depth 10
        Write-Message -Message "[Invoke-FabricRestMethod] Request Body: $Body" -Level Debug
    } elseif ($Body -is [string]) {
        Write-Message -Message "[Invoke-FabricRestMethod] Request Body: $Body" -Level Debug
    } else {
        Write-Message -Message "[Invoke-FabricRestMethod] No request body provided." -Level Debug
    }

    $request = @{
        Headers = $FabricSession.HeaderParams
        Uri = $Uri
        Method = $Method
        Body = $Body
        ContentType = "application/json"
        ErrorAction = 'Stop'
        SkipHttpErrorCheck = $true
        ResponseHeadersVariable = "responseHeader"
        StatusCodeVariable = "statusCode"
    }
    $response = Invoke-RestMethod @request

    Write-Message -Message "[Invoke-FabricRestMethod] Result response code: $statusCode" -Level Debug
    Write-Message -Message "[Invoke-FabricRestMethod] Result return: $response" -Level Debug
    $script:statusCode = $statusCode
    $script:responseHeader = $responseHeader

    Write-Message -Message "[Invoke-FabricRestMethod]::End" -Level Debug
    return $response
}
