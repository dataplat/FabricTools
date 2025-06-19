function Get-FabricLongRunningOperation {
    <#
.SYNOPSIS
Monitors the status of a long-running operation in Microsoft Fabric.

.DESCRIPTION
The Get-FabricLongRunningOperation function queries the Microsoft Fabric API to check the status of a
long-running operation. It periodically polls the operation until it reaches a terminal state (Succeeded or Failed).

.PARAMETER operationId
The unique identifier of the long-running operation to be monitored.

.PARAMETER location
The URL provided in the Location header of the initial request. This is used to check the status of the operation.

.PARAMETER retryAfter
The interval (in seconds) to wait between polling the operation status. The default is 5 seconds.

.EXAMPLE
Get-FabricLongRunningOperation -operationId "12345-abcd-67890-efgh" -retryAfter 10

This command polls the status of the operation with the given operationId every 10 seconds until it completes.

.NOTES

Author: Tiago Balabuch

    #>
    param (
        [Parameter(Mandatory = $false)]
        [string]$OperationId,

        [Parameter(Mandatory = $false)]
        [string]$Location,

        [Parameter(Mandatory = $false)]
        [int]$RetryAfter = 5
    )

    Write-Message -Message "[Get-FabricLongRunningOperation]::Begin" -Level Debug
    Confirm-TokenState

    # Step 1: Construct the API URL
    if (-not $OperationId) {
        # Use the Location header to define the operationUrl, if OperationId is not provided
        $apiEndpointUrl = $Location
    } else {
        $apiEndpointUrl = "operations/{0}" -f $OperationId
    }
    Write-Message -Message "[Get-FabricLongRunningOperation] API Endpoint: $apiEndpointUrl" -Level Debug

    try {
        do {

            # Step 2: Wait before the next request
            if ($RetryAfter) {
                Write-Message -Message "Waiting $RetryAfter seconds..." -Level Verbose
                Start-Sleep -Seconds $RetryAfter
            } else {
                Write-Message -Message "Waiting 5 seconds..." -Level Verbose
                Start-Sleep -Seconds 5  # Default retry interval if no Retry-After header
            }

            # Step 3: Make the API request
            $response = Invoke-FabricRestMethod -Uri $apiEndpointUrl -Method Get

            # Step 4: Parse the response
            $jsonOperation = $response | ConvertTo-Json
            $operation = $jsonOperation | ConvertFrom-Json

            # Log status for debugging
            Write-Message -Message "[Get-FabricLongRunningOperation] Operation Status: $($operation.status)" -Level Verbose

        } while ($operation.status -notin @("Succeeded", "Completed", "Failed"))

        # Step 5: Return the operation result
        return $operation

    } catch {
        # Step 6: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "An error occurred while checking the operation: $errorDetails" -Level Error
        throw
    }
}
