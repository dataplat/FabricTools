function Add-FabricWorkspaceCapacityAssignment {
    <#
    .SYNOPSIS
    Assigns a Fabric workspace to a specified capacity.

    .DESCRIPTION
    The `Add-FabricWorkspaceCapacityAssignment` function sends a POST request to assign a workspace to a specific capacity.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace to be assigned.

    .PARAMETER CapacityId
    The unique identifier of the capacity to which the workspace should be assigned.

    .EXAMPLE
        Assigns the workspace with ID "workspace123" to the capacity "capacity456".

        ```powershell
        Add-FabricWorkspaceCapacityAssignment -WorkspaceId "workspace123" -CapacityId "capacity456"
        ```

    .NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch
    #>
    [CmdletBinding()]
    [Alias("Assign-FabricWorkspaceCapacity")]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$CapacityId
    )

    try {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/assignToCapacity" -f $FabricConfig.BaseUrl, $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            capacityId = $CapacityId
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json -Depth 4
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        # Step 4: Make the API request
        $response = Invoke-FabricRestMethod `
            -Uri $apiEndpointUrl `
            -Method Post `
            -Body $bodyJson

        # Step 5: Validate the response code
        if ($statusCode -ne 202) {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }
        Write-Message -Message "Successfully assigned workspace with ID '$WorkspaceId' to capacity with ID '$CapacityId'." -Level Info
    } catch {
        # Step 6: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to assign workspace with ID '$WorkspaceId' to capacity with ID '$CapacityId'. Error: $errorDetails" -Level Error
    }
}
