<#
.SYNOPSIS
    Retrieves the definition of an Eventhouse from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function retrieves the definition of an Eventhouse from a specified workspace using the provided EventhouseId.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Eventhouse exists. This parameter is mandatory.

.PARAMETER EventhouseId
    The unique identifier of the Eventhouse to retrieve the definition for. This parameter is optional.

.PARAMETER EventhouseFormat
    The format in which to retrieve the Eventhouse definition. This parameter is optional.

.EXAMPLE
     Get-FabricEventhouseDefinition -WorkspaceId "workspace-12345" -EventhouseId "eventhouse-67890"
    This example retrieves the definition of the Eventhouse with ID "eventhouse-67890" in the workspace with ID "workspace-12345".

.EXAMPLE
     Get-FabricEventhouseDefinition -WorkspaceId "workspace-12345" -EventhouseId "eventhouse-67890" -EventhouseFormat "json"
    This example retrieves the definition of the Eventhouse with ID "eventhouse-67890" in the workspace with ID "workspace-12345" in JSON format.

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch

#>
function Get-FabricEventhouseDefinition {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$EventhouseId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EventhouseFormat
    )
    try {
        # Step 2: Ensure token validity
        Confirm-TokenState

        # Step 3: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/eventhouses/{2}/getDefinition" -f $FabricConfig.BaseUrl, $WorkspaceId, $EventhouseId

        if ($EventhouseFormat) {
            $apiEndpointUrl = "{0}?format={1}" -f $apiEndpointUrl, $EventhouseFormat
        }

        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 4: Make the API request
        $response = Invoke-FabricRestMethod `
            -Uri $apiEndpointUrl `
            -Method Post

        # Step 5: Validate the response code and handle the response
        switch ($statusCode) {
            200 {
                Write-Message -Message "Eventhouse '$EventhouseId' definition retrieved successfully!" -Level Debug
                return $response
            }
            202 {

                Write-Message -Message "Getting Eventhouse '$EventhouseId' definition request accepted. Retrieving in progress!" -Level Info

                [string]$operationId = $responseHeader["x-ms-operation-id"]
                [string]$location = $responseHeader["Location"]
                [string]$retryAfter = $responseHeader["Retry-After"]

                Write-Message -Message "Operation ID: '$operationId'" -Level Debug
                Write-Message -Message "Location: '$location'" -Level Debug
                Write-Message -Message "Retry-After: '$retryAfter'" -Level Debug
                Write-Message -Message "Getting Long Running Operation status" -Level Debug

                $operationStatus = Get-FabricLongRunningOperation -operationId $operationId -location $location
                Write-Message -Message "Long Running Operation status: $operationStatus" -Level Debug
                # Handle operation result
                if ($operationStatus.status -eq "Succeeded") {
                    Write-Message -Message "Operation Succeeded" -Level Debug
                    Write-Message -Message "Getting Long Running Operation result" -Level Debug

                    $operationResult = Get-FabricLongRunningOperationResult -operationId $operationId
                    Write-Message -Message "Long Running Operation status: $operationResult" -Level Debug

                    return $operationResult.definition.parts
                } else {
                    Write-Message -Message "Operation failed. Status: $($operationStatus)" -Level Debug
                    Write-Message -Message "Operation failed. Status: $($operationStatus)" -Level Error
                    return $operationStatus
                }
            }
            default {
                Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
                Write-Message -Message "Error: $($response.message)" -Level Error
                Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
                Write-Message "Error Code: $($response.errorCode)" -Level Error
                throw "API request failed with status code $statusCode."
            }
        }
    } catch {
        # Step 9: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Eventhouse. Error: $errorDetails" -Level Error
    }

}
