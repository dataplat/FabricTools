function Test-FabricApiResponse {

    <#
.SYNOPSIS
    Tests the response from a Fabric API call and handles long-running operations.

.DESCRIPTION
    Tests the response from a Fabric API call and handles long-running operations. It checks the status code and processes the response accordingly.

.PARAMETER Response
    The response body from the API call.

.PARAMETER ResponseHeader
    The response headers from the API call. This is used to retrieve operation IDs and other metadata.

.PARAMETER StatusCode
    The HTTP status code returned by the API call. This is used to determine how to handle the response.

.PARAMETER Operation
    The operation being performed by parent function (e.g., 'New', 'Update', 'Remove', 'Get'). It helps in logging appropriate messages.
    This parameter is optional and can be used to customize the logging message based on the operation type.

.PARAMETER ObjectIdOrName
    The name or ID of the resource being operated.

.PARAMETER TypeName
    The type of resource being operated (default: 'Fabric Item').

.PARAMETER SuccessMessage
    A custom success message to log upon successful completion of the operation. This overrides the default message based on Operation, TypeName, ObjectIdOrName.
    This parameter is optional and can be used to provide a specific success message for the operation.

.PARAMETER NoWait
    If specified, the function will not wait for the operation to complete and will return immediately.

.EXAMPLE
    Test-FabricApiResponse -statusCode 201 -response $response -responseHeader $header -Name "MyResource" -typeName "Fabric Item"

    Handles the response from a Fabric API call with a 201 status code, indicating successful creation of a resource.

.EXAMPLE
    Test-FabricApiResponse -statusCode 202 -response $response -responseHeader $header -Name "MyResource" -typeName "Fabric Item"

    Handles the response from a Fabric API call with a 202 status code, indicating that the request has been accepted for processing.

.NOTES
    - This function is designed to be used within the context of a Fabric API client.
    - It requires the `Write-Message` function to log messages at different levels (Info, Debug, Error).
    - The function handles long-running operations by checking the status of the operation and retrieving the result if it has succeeded.
    - Supports handling of API rate limiting (HTTP 429) by waiting for the specified retry duration before returning a command to repeat the request.

    Author: Kamil Nowinski

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]     # Response is $null when Response Code is 202
        $Response,

        [Parameter(Mandatory = $true)]
        $ResponseHeader,

        [Parameter(Mandatory = $true)]
        $StatusCode,

        [Parameter(Mandatory = $false)]
        $Operation,

        [Parameter(Mandatory = $false)]
        [string] $ObjectIdOrName,

        [Parameter(Mandatory = $false)]
        [string] $TypeName = 'Fabric Item',

        [Parameter(Mandatory = $false)]
        [string] $SuccessMessage,

        [Parameter(Mandatory = $false)]
        [switch] $NoWait = $false
    )

    Write-Message -Message "::Begin" -Level Debug

    #$responseHeader = $script:responseHeader
    #$statusCode = $script:statusCode
    $result = $null
    Write-Message -Message "Testing API response for '$Operation' operation. StatusCode: $statusCode." -Level Debug

    switch ($statusCode) {
        200 {
            if ($Operation -eq 'Get') {
                $result = $Response
            }
        }
        201 {
            $result = $Response
        }
        202 {
            Write-Message -Message "$Operation Request for $TypeName '$ObjectIdOrName' accepted. Provisioning in progress!" -Level Info
            [string]$operationId = $responseHeader["x-ms-operation-id"]

            if ($NoWait) {
                Write-Message -Message "NoWait parameter is set. Operation ID: $operationId" -Level Debug
                Write-Message -Message "Run to check the progress: Get-FabricLongRunningOperationResult -operationId '$operationId'" -Level Verbose
                return [PSCustomObject]@{
                    Location     = $responseHeader["Location"]
                    RetryAfter   = $responseHeader["Retry-After"]
                    OperationId  = $responseHeader["x-ms-operation-id"]
                }
            }

            Write-Message -Message "Operation ID: '$operationId'" -Level Debug
            Write-Message -Message "Getting Long Running Operation status" -Level Debug

            $operationStatus = Get-FabricLongRunningOperation -operationId $operationId
            Write-Message -Message "Long Running Operation status: $operationStatus" -Level Debug
            # Handle operation result
            if ($operationStatus.status -eq "Succeeded") {
                Write-Message -Message "Operation Succeeded" -Level Debug
                Write-Message -Message "Getting Long Running Operation result" -Level Verbose

                $operationResult = Get-FabricLongRunningOperationResult -operationId $operationId
                #Write-Message -Message "Long Running Operation status: $operationResult" -Level Debug

                return $operationResult
            } else {
                #Write-Message -Message "Operation failed. Status: $($operationStatus)" -Level Debug
                Write-Message -Message "Operation failed. Status: $($operationStatus)" -Level Error
                return $operationStatus
            }
        }
        429 {
            Write-Message -Message "API rate limit exceeded. Status Code: $statusCode ($($Response.errorCode))" -Level Warning
            Write-Message -Message "$($Response.message). Waiting $($responseHeader['Retry-After']) seconds..." -Level Warning
            $retryAfter = $responseHeader['Retry-After']
            $retryAfterStr = $retryAfter[0].ToString()
            $retryAfterInt = [int]$retryAfterStr
            Start-Sleep -Seconds $retryAfterInt
            return "Command:Repeat"
        }
        default {
            Write-Message -Message "Test-FabricApiResponse::default" -Level Debug
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            if ($response.moreDetails) {
                Write-Message -Message "More Details: $($response.moreDetails)" -Level Error
            }
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            throw "API request failed with status code $statusCode."
        }
    }

    # if (FeatureFlag.IsEnabled('FabricToolsVerboseLogging')) {    # This is placeholder for verbose logging feature flag being implemented soon
    $TypeName= $TypeName.Substring(0, 1).ToUpper() + $TypeName.Substring(1)

    if ($SuccessMessage) {
        $Operation = "Custom"
    }

    # Try to get Name of Id from the response when new item is created
    if ($Operation -eq 'New' -and -not $ObjectIdOrName) {
        $ObjectIdOrName = $Response.DisplayName ? $Response.DisplayName : $Response.id
    }
    switch ($Operation) {
        'New'    { $msg = "$TypeName '$ObjectIdOrName' created successfully."; $level = 'Info' }
        'Update' { $msg = "$TypeName '$ObjectIdOrName' updated successfully."; $level = 'Info' }
        'Remove' { $msg = "$TypeName '$ObjectIdOrName' deleted successfully."; $level = 'Info' }
        'Get'    { $msg = "Successfully retrieved $TypeName details.";         $level = 'Debug' }
        'Custom' { $msg = "$SuccessMessage";                                   $level = 'Info' }
        default  { $msg = "Received $statusCode status code for $Operation operation on $TypeName '$ObjectIdOrName'."; $level = 'Info' }
    }
    Write-Message -Message $msg -Level $level
    # }

    Write-Message -Message "::End" -Level Debug

    $result
}
