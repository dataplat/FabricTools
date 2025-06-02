Function Invoke-FabricRestMethodExtended {

<#
.SYNOPSIS
    Sends an HTTP request to a Fabric API endpoint and retrieves the response.
    Takes care of: authentication, 429 throttling, Long-Running-Operation (LRO) response

.DESCRIPTION
    The Invoke-FabricRestMethodExtended function is used to send an HTTP request to a Fabric API endpoint and retrieve the response. It handles various aspects such as authentication, 429 throttling, and Long-Running-Operation (LRO) response.

.PARAMETER Uri
    The URI of the Fabric API endpoint to send the request to.

.PARAMETER Method
    The HTTP method to be used for the request. Valid values are 'GET', 'POST', 'DELETE', 'PUT', and 'PATCH'. The default value is 'GET'.

.PARAMETER Body
    The body of the request, if applicable.

.PARAMETER RetryCount
    The number of times to retry the request in case of a 429 (Too Many Requests) error. The default value is 0.

.EXAMPLE
    Invoke-FabricRestMethodExtended -Uri "/api/resource" -Method "GET"

    This example sends a GET request to the "/api/resource" endpoint of the Fabric API.

.EXAMPLE
    Invoke-FabricRestMethodExtended -Uri "/api/resource" -method "POST" -Body $requestBody

    This example sends a POST request to the "/api/resource" endpoint of the Fabric API with a request body.

.NOTES
    This function based on code that was originally written by Rui Romano (Invoke-FabricAPIRequest) and replaces it.
    It's extended version of simple Invoke-FabricRestMethod function.
    Requires `$FabricConfig` global configuration, including `BaseUrl`.

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
        [int] $RetryCount = 0
    )

    Test-TokenExpired
    if ($Uri -notmatch '^https?://.*') {
        $Uri = "{0}/{1}" -f $FabricConfig.BaseUrl, $Uri
    }
    Write-Message -Message "Fabric API Endpoint: $Uri" -Level Verbose
    $fabricHeaders = $FabricSession.HeaderParams

    try {
        $requestUrl = "$($FabricConfig.BaseUrl)/$uri"
        Write-Message "Calling $requestUrl" -Level Debug
        # If need to use -OutFile beware of the following breaking change: https://github.com/PowerShell/PowerShell/issues/20744
        # TODO: use -SkipHttpErrorCheck to read the entire error response, need to find a solution to handle 429 errors: https://stackoverflow.com/questions/75629606/powershell-webrequest-handle-response-code-and-exit
        $response = Invoke-WebRequest -Headers $fabricHeaders -Method $method -Uri $requestUrl -Body $body # -TimeoutSec $timeoutSec
        $requestId = [string]$response.Headers.requestId
        Write-Message "RAID: $requestId" -Level Debug
        $lroFailOrNoResultFlag = $false
        if ($response.StatusCode -eq 202) {
            do {
                $asyncUrl = [string]$response.Headers.Location
                Write-Log "LRO - Waiting for request to complete in service."
                Start-Sleep -Seconds 5
                $response = Invoke-WebRequest -Headers $fabricHeaders -Method Get -Uri $asyncUrl
                $lroStatusContent = $response.Content | ConvertFrom-Json
            }
            while ($lroStatusContent.status -ine "succeeded" -and $lroStatusContent.status -ine "failed")

            if ($lroStatusContent.status -ieq "succeeded") {
                # Only calls /result if there is a location header, otherwise 'OperationHasNoResult' error is thrown
                $resultUrl = [string]$response.Headers.Location
                if ($resultUrl) {
                    $response = Invoke-WebRequest -Headers $fabricHeaders -Method Get -Uri $resultUrl
                }
                else {
                    $lroFailOrNoResultFlag = $true
                }
            }
            else {
                $lroFailOrNoResultFlag = $true
                if ($lroStatusContent.error) {
                    throw "LRO API Error: '$($lroStatusContent.error.errorCode)' - $($lroStatusContent.error.message)"
                }
            }
        }

        Write-Message "Request completed." -Level Debug

        #if ($response.StatusCode -in @(200,201) -and $response.Content)
        if (!$lroFailOrNoResultFlag -and $response.Content) {

            $contentBytes = $response.RawContentStream.ToArray()
            # Test for BOM
            if ($contentBytes[0] -eq 0xef -and $contentBytes[1] -eq 0xbb -and $contentBytes[2] -eq 0xbf) {
                $contentText = [System.Text.Encoding]::UTF8.GetString($contentBytes[3..$contentBytes.Length])
            }
            else {
                $contentText = $response.Content
            }

            $jsonResult = $contentText | ConvertFrom-Json
            if ($jsonResult.value) {
                $jsonResult = $jsonResult.value
            }
            Write-Output $jsonResult -NoEnumerate
        }
    }
    catch {
        $ex = $_.Exception
        $message = $null

        if ($null -ne $ex.Response) {

            $responseStatusCode = [int]$ex.Response.StatusCode

            if ($responseStatusCode -in @(429)) {
                if ($ex.Response.Headers.RetryAfter) {
                    $retryAfterSeconds = $ex.Response.Headers.RetryAfter.Delta.TotalSeconds + 5
                }
                if (!$retryAfterSeconds) {
                    $retryAfterSeconds = 60
                }
                Write-Message "Exceeded the amount of calls (TooManyRequests - 429), sleeping for $retryAfterSeconds seconds." -Level Verbose
                Start-Sleep -Seconds $retryAfterSeconds
                $maxRetries = 3

                if ($retryCount -le $maxRetries) {
                    Invoke-FabricRestMethod -uri $uri -method $method -body $body -retryCount ($retryCount + 1)
                }
                else {
                    throw "Exceeded the amount of retries ($maxRetries) after 429 error."
                }
            }
            else {
                $apiErrorObj = $ex.Response.Headers | Where-Object { $_.key -ieq "x-ms-public-api-error-code" } | Select-Object -First 1

                if ($apiErrorObj) {
                    $apiError = $apiErrorObj.Value[0]

                    if ($apiError -ieq "ItemHasProtectedLabel") {
                        Write-Message "Item has a protected label." -Level Warning
                    }
                    else {
                        $message = "$($ex.Message); API error code: '$apiError'"

                        throw $message
                    }
                }
            }
        }
        else {
            $message = "$($ex.Message)"
        }

        if ($message) {
            throw $message
        }

    }
}
