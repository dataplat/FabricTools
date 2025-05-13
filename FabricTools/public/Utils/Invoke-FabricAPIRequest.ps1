function Invoke-FabricAPIRequest {
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
            }
            else {
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
                    }
                    elseif ($response.PSObject.Properties.Name -contains 'accessEntities') {
                        $results += $response.accessEntities
                    }
                    else {
                        $results += $response
                    }
                    $continuationToken = $response.PSObject.Properties.Match("continuationToken") ? $response.continuationToken : $null
                }
                else {
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
                }
                else {
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
