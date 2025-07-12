function Get-FabricLongRunningOperationResult {
    <#
.SYNOPSIS
Retrieves the result of a completed long-running operation from the Microsoft Fabric API.

.DESCRIPTION
The Get-FabricLongRunningOperationResult function queries the Microsoft Fabric API to fetch the result
of a specific long-running operation. This is typically used after confirming the operation has completed successfully.

.PARAMETER operationId
The unique identifier of the completed long-running operation whose result you want to retrieve.

.EXAMPLE
    This command fetches the result of the operation with the specified operationId. ```powershell ```

    ```powershell
    Get-FabricLongRunningOperationResult -operationId "12345-abcd-67890-efgh"
    ```

.NOTES
- Ensure the Fabric API headers (e.g., authorization tokens) are defined in $FabricConfig.FabricHeaders.
- This function does not handle polling. Ensure the operation is in a terminal state before calling this function.

Author: Tiago Balabuch

    #>
    param (
        [Parameter(Mandatory = $true)]
        [guid]$OperationId
    )

    Write-Message -Message "[Get-FabricLongRunningOperationResult]::Begin" -Level Debug
    Confirm-TokenState

    # Step 1: Construct the API URL
    $apiEndpointUrl = "{0}/operations/{1}/result" -f $FabricConfig.BaseUrl, $OperationId
    Write-Message -Message "[Get-FabricLongRunningOperationResult] API Endpoint: $apiEndpointUrl" -Level Debug

    try {
        # Step 2: Make the API request
        $response = Invoke-FabricRestMethod -Uri $apiEndpointUrl -Method Get

        # Step 3: Validate the response code
        if ($script:statusCode -ne 200) {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Debug
            Write-Message -Message "Error: $($response.message)" -Level Debug
            Write-Message -Message "Error Details: $($response.moreDetails)" -Level Debug
            Write-Message "Error Code: $($response.errorCode)" -Level Debug
        }

        return $response

    } catch {
        # Step 3: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "An error occurred while returning the operation result: $errorDetails" -Level Error
        throw
    }
}
