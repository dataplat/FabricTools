function Test-FabricApiResponse {

    <#
.SYNOPSIS
    Tests the response from a Fabric API call and handles long-running operations.

.DESCRIPTION
    Tests the response from a Fabric API call and handles long-running operations. It checks the status code and processes the response accordingly.

.PARAMETER Response
    The response body from the API call.

.PARAMETER Name
    The name of the resource being operated.

.PARAMETER TypeName
    The type of resource being operated (default: 'Fabric Item').

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

    Author: Kamil Nowinski

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        $Response,

        [Parameter(Mandatory = $false)]
        [string] $ObjectIdOrName,

        [Parameter(Mandatory = $false)]
        [string] $TypeName = 'Fabric Item',

        [Parameter(Mandatory = $false)]
        [switch] $NoWait = $false
    )

    $responseHeader = $script:responseHeader
    $statusCode = $script:statusCode

    $verb = (Get-PSCallStack)[1].Command.Split('-')[0]
    Write-Message -Message "Testing API response for '$verb' operation. StatusCode: $statusCode." -Level Debug

    switch ($statusCode) {
        200 {
            return $null
        }
        201 {
            switch ($verb) {
                'New'    { $msg = "$TypeName '$ObjectIdOrName' created successfully!" }
                'Update' { $msg = "$TypeName '$ObjectIdOrName' updated successfully!" }
                'Remove' { $msg = "$TypeName '$ObjectIdOrName' deleted successfully!" }
                default  { $msg = "Received $statusCode status code for $verb operation on $TypeName '$ObjectIdOrName'" }
            }
            Write-Message -Message $msg -Level Info
            return $Response
        }
        202 {
            Write-Message -Message "$verb Request for $TypeName '$ObjectIdOrName' accepted. Provisioning in progress!" -Level Info
            [string]$operationId = $responseHeader["x-ms-operation-id"]

            if ($NoWait) {
                Write-Message -Message "NoWait parameter is set. Operation ID: $operationId" -Level Info
                Write-Message -Message "Run to check the progress: Get-FabricLongRunningOperationResult -operationId '$operationId'" -Level Verbose
                return $responseHeader
            }

            Write-Message -Message "[Test-FabricApiResponse] Operation ID: '$operationId'" -Level Debug
            Write-Message -Message "[Test-FabricApiResponse] Getting Long Running Operation status" -Level Debug

            $operationStatus = Get-FabricLongRunningOperation -operationId $operationId
            Write-Message -Message "[Test-FabricApiResponse] Long Running Operation status: $operationStatus" -Level Debug
            # Handle operation result
            if ($operationStatus.status -eq "Succeeded") {
                Write-Message -Message "Operation Succeeded" -Level Debug
                Write-Message -Message "Getting Long Running Operation result" -Level Debug

                $operationResult = Get-FabricLongRunningOperationResult -operationId $operationId
                Write-Message -Message "Long Running Operation status: $operationResult" -Level Debug

                return $operationResult
            } else {
                Write-Message -Message "Operation failed. Status: $($operationStatus)" -Level Debug
                Write-Message -Message "Operation failed. Status: $($operationStatus)" -Level Error
                return $operationStatus
            }
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

}
