Function Invoke-FabricRestMethod {

<#
.SYNOPSIS
    Sends an HTTP request to a Fabric or Power BI API endpoint and retrieve the response.

.DESCRIPTION
    Sends an HTTP request to a Fabric or Power BI API endpoint and retrieve the response.
    Supports pagination by recognizing continuation tokens in the response.
    Supports handling of long-running operations and throttling (error 429) responses. Facilitates both synchronous and asynchronous operations.
    Message logging is provided for debugging and informational purposes.

.PARAMETER Uri
    The URI of the Fabric API endpoint to send the request to.
    Can be a relative path (e.g., "workspaces") or a full URL (e.g., "https://api.fabric.microsoft.com/v1/workspaces").

.PARAMETER Method
    The HTTP method to be used for the request. Valid values are 'GET', 'POST', 'DELETE', 'PUT', and 'PATCH'. The default value is 'GET'.

.PARAMETER Body
    The body of the request, if applicable. This can be a hashtable or a string. If a hashtable is provided, it will be converted to JSON format.

.PARAMETER TestTokenExpired
    A switch parameter to test if the Fabric token is expired before making the request. If the token is expired, it will attempt to refresh it.
    Default is False. If set to True, the function will check the token state before making the request.

.PARAMETER PowerBIApi
    A switch parameter to indicate that the request should be sent to the Power BI API instead of the Fabric API.

.PARAMETER NoWait
    A switch parameter to indicate that the function should not wait for the response. This is useful for asynchronous operations.
    Default is False. If set to True, the function will return immediately without waiting for the operation to complete.

.PARAMETER HandleResponse
    A switch parameter to indicate that the response should be handled after call API. Default is False.
    The operation will be processed based on the response status code and supports Throttling (429) and Long-Running Operations.

.PARAMETER ExtractValue
    A string parameter to specify whether to extract the 'value' property from the response.
    Valid values are 'True', 'False', and 'Auto'. The default is 'False'.
    'Auto' will extract 'value' if it exists in the response.

.PARAMETER TypeName
    Optional. The type of resource being operated on. This is used for logging purposes. Default is 'Fabric Item'.
    Should be used when `HandleResponse` is set to True.

.PARAMETER ObjectIdOrName
    Optional. The name or ID of the resource being operated on. This is used for logging purposes.
    Should be used when `HandleResponse` is set to True.

.PARAMETER SuccessMessage
    Optional. A message to log upon successful completion of the operation. This is used for logging purposes.
    Should be used when `HandleResponse` is set to True. Overrides the default message based on Operation, TypeName, ObjectIdOrName.

.EXAMPLE
    Invoke-FabricRestMethod -uri "workspaces" -method "GET"

    This example sends a GET request to the "https://api.fabric.microsoft.com/v1/workspaces" endpoint of the Fabric API.

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

        [Parameter(Mandatory = $false)]
        [switch] $TestTokenExpired,

        [Parameter(Mandatory = $false)]
        [switch] $PowerBIApi,

        [Parameter(Mandatory = $false)]
        [switch] $NoWait = $false,

        [Parameter(Mandatory = $false)]
        [switch] $HandleResponse,

        [Parameter(Mandatory = $false)]
        [ValidateSet('True', 'False', 'Auto')]
        [string] $ExtractValue,

        [Parameter(Mandatory = $false)]
        [string] $TypeName = "Fabric Item",

        [Parameter(Mandatory = $false)]
        [string] $ObjectIdOrName,

        [Parameter(Mandatory = $false)]
        [string] $SuccessMessage
    )

    Write-Message -Message "::Begin" -Level Debug

    if ($TestTokenExpired) {
        Confirm-TokenState
    }

    if ($HandleResponse -and -not $ExtractValue) {
        $ExtractValue = "Auto"
        Write-Message -Message "ExtractValue = AUTO" -Level Debug
    }
    if (-not $ExtractValue) {
        $ExtractValue = "False"
        Write-Message -Message "ExtractValue = FALSE" -Level Debug
    }

    $Method = $Method.ToUpperInvariant()
    $baseUrl = $FabricConfig.BaseUrl
    if ($PowerBIApi) {
        $baseUrl = Get-PSFConfigValue -FullName 'FabricTools.PowerBiApi.BaseUrl'
    }

    if ($Uri -notmatch '^https?://.*') {
        $Uri = "{0}/{1}" -f $baseUrl, $Uri
    } elseif ($PowerBIApi) {
        Write-Message -Message "PowerBIApi param is ignored when full Uri is provided." -Level Warning
    }

    $Headers = $FabricSession.HeaderParams
    if ($Uri.StartsWith($AzureSession.BaseApiUrl)) {
        $Headers = $AzureSession.HeaderParams
        Write-Message -Message "Using AzureSession headers for request." -Level Debug
    }

    if ($Body -is [hashtable]) {
        $Body = $Body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $Body" -Level Debug
    } elseif ($Body -is [string]) {
        Write-Message -Message "Request Body: $Body" -Level Debug
    } else {
        Write-Message -Message "No request body provided." -Level Debug
    }

    $headers = Get-PSFConfigValue -FullName 'FabricTools.FabricSession.Headers'
    $contentType = Get-PSFConfigValue -FullName 'FabricTools.FabricApi.ContentType'

    $continuationToken = $null
    $repeat = $false

    do {
        $apiEndpointUrl = $Uri
        if ($null -ne $continuationToken) {
            $encodedToken = [System.Web.HttpUtility]::UrlEncode($continuationToken)
            $apiEndpointUrl = "{0}?continuationToken={1}" -f $apiEndpointUrl, $encodedToken
        }
        Write-Message -Message "API Endpoint: $Method $apiEndpointUrl" -Level Verbose

        $request = @{
            Headers = $headers
            Uri = $Uri
            Method = $Method
            Body = $Body
            ContentType = $contentType
            ErrorAction = 'Stop'
            SkipHttpErrorCheck = $true
            ResponseHeadersVariable = "responseHeader"
            StatusCodeVariable = "statusCode"
        }
        $response = Invoke-RestMethod @request

        # Needed for backward compatibility, example: Get-FabricWorkspace
        $script:statusCode = $statusCode
        $script:responseHeader = $responseHeader

        if ($HandleResponse) {
            $params = @{
                Response = $response
                ResponseHeader = $responseHeader
                StatusCode = $statusCode
                Operation = (Get-PSCallStack)[1].Command.Split('-')[0]
                ObjectIdOrName = $ObjectIdOrName
                TypeName = $TypeName
                NoWait = $NoWait
                SuccessMessage = $SuccessMessage
            }
            $response = Test-FabricApiResponse @params
            $repeat = $response -is [string] -and $response -eq "Command:Repeat"
            if ($repeat) { $response = $null }
        }

        # Process response and update continuation token
        Write-Message -Message "Result response code: $statusCode" -Level Debug
        if ($null -ne $response) {
            $continuationToken = Get-FabricContinuationToken -Response $response

            if ($ExtractValue -eq 'Auto' -and $null -ne $response.value) {
                $ExtractValue = 'True'
            }
            if ($ExtractValue -eq 'True') {
                Write-Message -Message "Extracting 'value' from Response." -Level Debug
                $response = $response.value
            }
            $response

            Write-Message -Message "Result return: $response | Count: $($response.Count)" -Level Debug
        }

    } while ($repeat -or $continuationToken)

    Write-Message -Message "::End" -Level Debug
}
