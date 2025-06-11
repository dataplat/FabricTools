function Test-FabricApiResponse {
<#
.SYNOPSIS
Tests the response from a Fabric API call and handles long-running operations.
.DESCRIPTION
Tests the response from a Fabric API call and handles long-running operations. It checks the status code and processes the response accordingly.
.PARAMETER statusCode
The HTTP status code returned from the API call.
.PARAMETER response
The response body from the API call.
.PARAMETER responseHeader
The response headers from the API call.
.PARAMETER Name
The name of the resource being created or updated.
.PARAMETER typeName
The type of resource being created or updated (default: 'Fabric Item').

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
        [Parameter(Mandatory = $true)]
        $statusCode,
        [Parameter(Mandatory = $false)]
        $response,
        [Parameter(Mandatory = $false)]
        $responseHeader,
        [Parameter(Mandatory = $false)]
        $Name,
        [Parameter(Mandatory = $false)]
        $typeName = 'Fabric Item'
    )

    switch ($statusCode) {
        201 {
            Write-Message -Message "$typeName '$Name' created successfully!" -Level Info
            return $response
        }
        202 {
            Write-Message -Message "$typeName '$Name' creation accepted. Provisioning in progress!" -Level Info

            [string]$operationId = $responseHeader["x-ms-operation-id"]
            Write-Message -Message "Operation ID: '$operationId'" -Level Debug
            Write-Message -Message "Getting Long Running Operation status" -Level Debug

            $operationStatus = Get-FabricLongRunningOperation -operationId $operationId
            Write-Message -Message "Long Running Operation status: $operationStatus" -Level Debug
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
            Write-Message -Message "Unexpected response code: $statusCode" -Level Error
            Write-Message -Message "Error details: $($response.message)" -Level Error
            throw "API request failed with status code $statusCode."
        }
    }

}
