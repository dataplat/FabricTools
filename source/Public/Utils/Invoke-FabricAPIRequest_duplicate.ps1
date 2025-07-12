function Invoke-FabricAPIRequest_duplicate {

    <#
    .SYNOPSIS
        Sends an HTTP request to a Fabric API endpoint and retrieves the response.
        Takes care of: authentication, 429 throttling, Long-Running-Operation (LRO) response

    .DESCRIPTION
        The Invoke-RestMethod function is used to send an HTTP request to a Fabric API endpoint and retrieve the response. It handles various aspects such as authentication, 429 throttling, and Long-Running-Operation (LRO) response.

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
    This example sends a GET request to the "/api/resource" endpoint of the Fabric API. ```powershell ```

    ```powershell
    Invoke-FabricAPIRequest_duplicate -uri "/api/resource" -method "Get"
    ```

    .EXAMPLE
    This example sends a POST request to the "/api/resource" endpoint of the Fabric API with a request body. ```powershell ```

    ```powershell
    Invoke-FabricAPIRequest_duplicate -authToken "abc123" -uri "/api/resource" -method "Post" -body $requestBody
    ```

    .NOTES
        This function requires the Get-FabricAuthToken function to be defined in the same script or module.

        Author: Rui Romano.

    #>
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [hashtable]$Headers,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$BaseURI,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Get', 'Post', 'Delete', 'Put', 'Patch')]
        [string] $Method,

        [Parameter(Mandatory = $false)]
        [string] $Body,

        [Parameter(Mandatory = $false)]
        [string] $ContentType = "application/json; charset=utf-8"
    )

    $continuationToken = $null
    $results = @()

    if (-not ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetName().Name -eq "System.Web" })) {
        Add-Type -AssemblyName System.Web
    }

    do {
        $apiEndpointURI = $BaseURI
        if ($null -ne $continuationToken) {
            $encodedToken = [System.Web.HttpUtility]::UrlEncode($continuationToken)

            if ($BaseURI -like "*`?*") {
                # URI already has parameters, append with &
                $apiEndpointURI = "$BaseURI&continuationToken=$encodedToken"
            } else {
                # No existing parameters, append with ?
                $apiEndpointURI = "$BaseURI?continuationToken=$encodedToken"
            }
        }
        Write-Message -Message "Calling API: $apiEndpointURI" -Level Debug

        $invokeParams = @{
            Headers                 = $Headers
            Uri                     = $apiEndpointURI
            Method                  = $Method
            ErrorAction             = 'Stop'
            SkipHttpErrorCheck      = $true
            ResponseHeadersVariable = 'responseHeader'
            StatusCodeVariable      = 'statusCode'
            # TimeoutSec              = $timeoutSec
        }

        if ($method -in @('Post', 'Put', 'Patch') -and $body) {
            $invokeParams.Body = $body
            $invokeParams.ContentType = $contentType
        }

        $response = Invoke-RestMethod @invokeParams
        switch ($statusCode) {

            200 {
                Write-Message -Message "API call succeeded." -Level Debug
                # Step 5: Handle and log the response
                if ($response) {
                    if ($response.PSObject.Properties.Name -contains 'value') {
                        $results += $response.value
                    } elseif ($response.PSObject.Properties.Name -contains 'accessEntities') {
                        $results += $response.accessEntities
                    } else {
                        $results += $response
                    }
                    $continuationToken = $null
                    if ($response.PSObject.Properties.Match("continuationToken")) {
                        $continuationToken = $response.continuationToken
                    }
                } else {
                    Write-Message -Message "No data in response" -Level Debug
                    $continuationToken = $null
                }
            }
            201 {
                Write-Message -Message "Resource created successfully." -Level Info
                return $response
            }
            202 {
                # Step 6: Handle long-running operations
                Write-Message -Message "Request accepted. Provisioning in progress." -Level Info
                [string]$operationId = $responseHeader["x-ms-operation-id"]
                [string]$location = $responseHeader["Location"]
                # Need to implement a retry mechanism for long running operations
                # [string]$retryAfter = $responseHeader["Retry-After"]
                Write-Message -Message "Operation ID: '$operationId', Location: '$location'" -Level Debug
                Write-Message -Message "Getting Long Running Operation status" -Level Debug

                $operationStatus = Get-FabricLongRunningOperation -operationId $operationId -location $location
                Write-Message -Message "Long Running Operation status: $operationStatus" -Level Debug

                # Handle operation result
                if ($operationStatus.status -eq "Succeeded") {
                    Write-Message -Message "Operation succeeded. Fetching result." -Level Debug

                    $operationResult = Get-FabricLongRunningOperationResult -operationId $operationId
                    Write-Message -Message "Long Running Operation result: $operationResult" -Level Debug
                    return $operationResult
                } else {
                    Write-Message -Message "Operation failed. Status: $($operationStatus)" -Level Error
                    return $operationStatus
                }
            }
            400 { $errorMsg = "Bad Request" }
            401 { $errorMsg = "Unauthorized" }
            403 { $errorMsg = "Forbidden" }
            404 { $errorMsg = "Not Found" }
            409 { $errorMsg = "Conflict" }
            429 { $errorMsg = "Too Many Requests" }
            500 { $errorMsg = "Internal Server Error" }
            default { $errorMsg = "Unexpected response code: $statusCode" }
        }

        if ($statusCode -notin 200, 201, 202) {
            Write-Message -Message "$errorMsg : $($response.message)" -Level Error
            Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
            Write-Message -Message "Error Code: $($response.errorCode)" -Level Error
            throw "API request failed with status code $statusCode."
        }
    } while ($null -ne $continuationToken)

    return $results
}
