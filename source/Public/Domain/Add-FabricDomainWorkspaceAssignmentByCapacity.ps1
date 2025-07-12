<#
.SYNOPSIS
Assigns workspaces to a Fabric domain based on specified capacities.

.DESCRIPTION
The `Add-FabricDomainWorkspaceAssignmentByCapacity` function assigns workspaces to a Fabric domain using a list of capacity IDs by making a POST request to the relevant API endpoint.

.PARAMETER DomainId
The unique identifier of the Fabric domain to which the workspaces will be assigned.

.PARAMETER CapacitiesIds
An array of capacity IDs used to assign workspaces to the domain.

.EXAMPLE
    Assigns workspaces to the domain with ID "12345" based on the specified capacities.

    ```powershell
    Add-FabricDomainWorkspaceAssignmentByCapacity -DomainId "12345" -CapacitiesIds @("capacity1", "capacity2")
    ```

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch
#>

function Add-FabricDomainWorkspaceAssignmentByCapacity {
    [CmdletBinding()]
    [Alias("Assign-FabricDomainWorkspaceByCapacity")]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$DomainId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid[]]$CapacitiesIds
    )

    try {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/admin/domains/{1}/assignWorkspacesByCapacities" -f $FabricConfig.BaseUrl, $DomainId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            capacitiesIds = $CapacitiesIds
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json -Depth 2
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        # Step 4: Make the API request
        $response = Invoke-FabricRestMethod `
            -Uri $apiEndpointUrl `
            -Method Post `
            -Body $bodyJson

        # Step 5: Handle and log the response
        switch ($statusCode) {
            201 {
                Write-Message -Message "Assigning domain workspaces by capacity completed successfully!" -Level Info
                return $response
            }
            202 {
                Write-Message -Message "Assigning domain workspaces by capacity is in progress for domain '$DomainId'." -Level Info
                [string]$operationId = $responseHeader["x-ms-operation-id"]

                [string]$operationId = $responseHeader["x-ms-operation-id"]
                [string]$location = $responseHeader["Location"]
                [string]$retryAfter = $responseHeader["Retry-After"]

                Write-Message -Message "Operation ID: '$operationId'" -Level Debug
                Write-Message -Message "Location: '$location'" -Level Debug
                Write-Message -Message "Retry-After: '$retryAfter'" -Level Debug
                Write-Message -Message "Getting Long Running Operation status" -Level Debug

                $operationStatus = Get-FabricLongRunningOperation -operationId $operationId
                Write-Message -Message "Long Running Operation status: $operationStatus" -Level Debug
                # Handle operation result
                if ($operationStatus.status -eq "Succeeded") {
                    Write-Message -Message "Operation Succeeded" -Level Debug
                    return $operationStatus
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
    } catch {
        # Step 6: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Error occurred while assigning workspaces by capacity for domain '$DomainId'. Details: $errorDetails" -Level Error
    }
}
