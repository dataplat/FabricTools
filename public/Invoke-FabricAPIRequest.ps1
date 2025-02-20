
<#
    .SYNOPSIS
        Sends an HTTP request to a Fabric API endpoint and retrieves the response.
        Takes care of: authentication, 429 throttling, Long-Running-Operation (LRO) response

    .DESCRIPTION
        The Invoke-FabricAPIRequest function is used to send an HTTP request to a Fabric API endpoint and retrieve the response. It handles various aspects such as authentication, 429 throttling, and Long-Running-Operation (LRO) response.

    .PARAMETER authToken
        The authentication token to be used for the request. If not provided, it will be obtained using the Get-FabricAuthToken function.

    .PARAMETER uri
        The URI of the Fabric API endpoint to send the request to.

    .PARAMETER method
        The HTTP method to be used for the request. Valid values are 'Get', 'Post', 'Delete', 'Put', and 'Patch'. The default value is 'Get'.

    .PARAMETER body
        The body of the request, if applicable.

    .PARAMETER contentType
        The content type of the request. The default value is 'application/json; charset=utf-8'.

    .PARAMETER timeoutSec
        The timeout duration for the request in seconds. The default value is 240 seconds.

    .PARAMETER outFile
        The file path to save the response content to, if applicable.

    .PARAMETER retryCount
        The number of times to retry the request in case of a 429 (Too Many Requests) error. The default value is 0.

    .EXAMPLE
        Invoke-FabricAPIRequest -uri "/api/resource" -method "Get"

        This example sends a GET request to the "/api/resource" endpoint of the Fabric API.

    .EXAMPLE
        Invoke-FabricAPIRequest -authToken "abc123" -uri "/api/resource" -method "Post" -body $requestBody

        This example sends a POST request to the "/api/resource" endpoint of the Fabric API with a request body.

    .NOTES
        This function requires the Get-FabricAuthToken function to be defined in the same script or module.
        This function was originally written by Rui Romano.
        https://github.com/RuiRomano/fabricps-pbip
    #>


Function Invoke-FabricAPIRequest {
    <#
    .SYNOPSIS
        Sends an HTTP request to a Fabric API endpoint and retrieves the response.
        Takes care of: authentication, 429 throttling, Long-Running-Operation (LRO) response
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)] [string] $authToken,
        [Parameter(Mandatory = $true)] [string] $uri,
        [Parameter(Mandatory = $false)] [ValidateSet('Get', 'Post', 'Delete', 'Put', 'Patch')] [string] $method = "Get",
        [Parameter(Mandatory = $false)] $body,
        [Parameter(Mandatory = $false)] [string] $contentType = "application/json; charset=utf-8",
        [Parameter(Mandatory = $false)] [int] $timeoutSec = 240,
        [Parameter(Mandatory = $false)] [int] $retryCount = 0

    )

    if ([string]::IsNullOrEmpty($authToken)) {
        $authToken = Get-FabricAuthToken
        $authToken = Get-FabricAuthToken
    }

    $fabricHeaders = @{
        'Content-Type'  = $contentType
        'Authorization' = "Bearer {0}" -f $authToken
    }
    write-verbose  "authToken: $authToken"

    try {


        $requestUrl = "$($script:apiUrl)/$uri"

        Write-Verbose "Calling $requestUrl"

        $response = Invoke-WebRequest -Headers $fabricHeaders -Method $method -Uri $requestUrl -Body $body -TimeoutSec $timeoutSec 

        if ($response.StatusCode -eq 202) {
            if ($uri -match "jobType=Pipeline") {
                write-output "Waiting for pipeline to complete. Please check the status in the Power BI Service."
            }
            else {
                do {
                    $asyncUrl = [string]$response.Headers.Location
                

                    Write-Output "Waiting for request to complete. Sleeping..."

                    Start-Sleep -Seconds 5

                    $response2 = Invoke-WebRequest -Headers $fabricHeaders -Method Get -Uri $asyncUrl

                    $lroStatusContent = $response2.Content | ConvertFrom-Json
                }
                while ($lroStatusContent.status -ine "succeeded" -and $lroStatusContent.status -ine "failed")
            
                try {
                    $response = Invoke-WebRequest -Headers $fabricHeaders -Method Get -Uri "$asyncUrl/result"
                }
                catch {
                    write-output "No result URL"
                }
            }
        }

        #if ($response.StatusCode -in @(200,201) -and $response.Content)
        if ($response.Content) {
            $contentBytes = $response.RawContentStream.ToArray()

            if ($contentBytes[0] -eq 0xef -and $contentBytes[1] -eq 0xbb -and $contentBytes[2] -eq 0xbf) {
                $contentText = [System.Text.Encoding]::UTF8.GetString($contentBytes[3..$contentBytes.Length])
            }
            else {
                $contentText = $response.Content
            }

            $jsonResult = $contentText | ConvertFrom-Json

            Write-Output $jsonResult -NoEnumerate
        }
        
        else {
            Write-Output $response -NoEnumerate
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

                Write-Output "Exceeded the amount of calls (TooManyRequests - 429), sleeping for $retryAfterSeconds seconds."

                Start-Sleep -Seconds $retryAfterSeconds

                $maxRetries = 3

                if ($retryCount -le $maxRetries) {
                    Invoke-FabricAPIRequest -authToken $authToken -uri $uri -method $method -body $body -contentType $contentType -timeoutSec $timeoutSec -retryCount ($retryCount + 1)
                }
                else {
                    throw "Exceeded the amount of retries ($maxRetries) after 429 error."
                }

            }
            else {
                $apiErrorObj = $ex.Response.Headers | Where-Object { $_.key -ieq "x-ms-public-api-error-code" } | Select-object -First 1

                if ($apiErrorObj) {
                    $apiError = $apiErrorObj.Value[0]
                }

                if ($apiError -ieq "ItemHasProtectedLabel") {
                    Write-Warning "Item has a protected label."
                }
                else {
                    throw
                }

                # TODO: Investigate why response.Content is empty but powershell can read it on throw

                #$errorContent = $ex.Response.Content.ReadAsStringAsync().Result;

                #$message = "$($ex.Message) - StatusCode: '$($ex.Response.StatusCode)'; Content: '$errorContent'"
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