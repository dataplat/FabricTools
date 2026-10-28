function Get-FabricLongRunningOperation {
    <#
.SYNOPSIS
Monitors the status of a long-running operation in Microsoft Fabric.

.DESCRIPTION
The Get-FabricLongRunningOperation function queries the Microsoft Fabric API to check the status of a
long-running operation. It periodically polls the operation until it reaches a terminal state (Succeeded or Failed).

.PARAMETER OperationId
The unique identifier of the long-running operation to be monitored.

.PARAMETER Location
The URL provided in the Location header of the initial request. This is used to check the status of the operation.

.PARAMETER RetryAfter
The interval (in seconds) to wait between polling the operation status. The default is 5 seconds.

.PARAMETER Timeout
The maximum time, in minutes, to wait for the operation. A value of 0 waits indefinitely.

.EXAMPLE
    This command polls the status of the operation with the given operationId every 10 seconds until it completes. ```powershell ```

    ```powershell
    Get-FabricLongRunningOperation -operationId "12345-abcd-67890-efgh" -retryAfter 10
    ```

.NOTES

Author: Tiago Balabuch

    #>
    param (
        [Parameter(Mandatory = $false)]
        [string]$OperationId,

        [Parameter(Mandatory = $false)]
        [string]$Location,

        [Parameter(Mandatory = $false)]
        [int]$RetryAfter = 5,

        [Parameter(Mandatory = $false)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Timeout = 0,

        [Parameter(DontShow)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$TimeoutSeconds = 0
    )

    Write-Message -Message "[Get-FabricLongRunningOperation]::Begin" -Level Debug
    Confirm-TokenState
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $timeoutBudgetSeconds = if ($TimeoutSeconds -gt 0) { $TimeoutSeconds } else { [long]$Timeout * 60 }

    # Construct the API URL
    if (-not $OperationId) {
        # Use the Location header to define the operationUrl, if OperationId is not provided
        $apiEndpointUrl = $Location
    } else {
        $apiEndpointUrl = "operations/{0}" -f $OperationId
    }

    # Validate that we have a valid endpoint URL
    if ([string]::IsNullOrEmpty($apiEndpointUrl)) {
        $errorMessage = "Cannot construct operation URL - both OperationId and Location are empty or null."
        Write-Message -Message "[Get-FabricLongRunningOperation] $errorMessage" -Level Error
        throw $errorMessage
    }

    Write-Message -Message "[Get-FabricLongRunningOperation] API Endpoint: $apiEndpointUrl" -Level Debug

    try {
        do {

            if ($timeoutBudgetSeconds -gt 0) {
                $remainingSeconds = $timeoutBudgetSeconds - $stopwatch.Elapsed.TotalSeconds
                if ($remainingSeconds -le 0) {
                    throw "Operation timed out after $Timeout minutes."
                }
            }

            $sleepSeconds = if ($RetryAfter) { $RetryAfter } else { 5 }
            if ($timeoutBudgetSeconds -gt 0) {
                $sleepSeconds = [Math]::Min($sleepSeconds, [Math]::Ceiling($remainingSeconds))
            }

            Write-Message -Message "Waiting $sleepSeconds seconds..." -Level Verbose
            Start-Sleep -Seconds $sleepSeconds

            if ($timeoutBudgetSeconds -gt 0 -and $stopwatch.Elapsed.TotalSeconds -ge $timeoutBudgetSeconds) {
                throw "Operation timed out after $Timeout minutes."
            }

            $apiParams = @{
                Uri    = $apiEndpointUrl
                Method = 'Get'
            }
            if ($timeoutBudgetSeconds -gt 0) {
                $remainingSeconds = $timeoutBudgetSeconds - $stopwatch.Elapsed.TotalSeconds
                if ($remainingSeconds -le 0) {
                    throw "Operation timed out after $Timeout minutes."
                }
                $apiParams.RequestTimeoutSeconds = [int][Math]::Min([Math]::Max(1, [Math]::Floor($remainingSeconds)), [int]::MaxValue)
            }

            # Make the API request
            $response = Invoke-FabricRestMethod @apiParams

            if ($timeoutBudgetSeconds -gt 0 -and $stopwatch.Elapsed.TotalSeconds -ge $timeoutBudgetSeconds) {
                throw "Operation timed out after $Timeout minutes."
            }

            # Parse the response
            $jsonOperation = $response | ConvertTo-Json
            $operation = $jsonOperation | ConvertFrom-Json

            # Log status for debugging
            Write-Message -Message "[Get-FabricLongRunningOperation] Operation Status: $($operation.status)" -Level Verbose

        } while ($operation.status -notin @("Succeeded", "Completed", "Failed"))

        # Return the operation result
        return $operation

    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "An error occurred while checking the operation: $errorDetails" -Level Error
        throw
    }
}
