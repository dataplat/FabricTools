function Add-FabricWorkspaceCapacity {
    <#
    .SYNOPSIS
    Assigns a Fabric workspace to a specified capacity.

    .DESCRIPTION
    The `Add-FabricWorkspaceCapacity` function sends a POST request to assign a workspace to a specific capacity.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace to be assigned.

    .PARAMETER CapacityId
    The unique identifier of the capacity to which the workspace should be assigned.

    .EXAMPLE
        Assigns the workspace with ID "workspace123" to the capacity "capacity456".

        ```powershell
        Add-FabricWorkspaceCapacity -WorkspaceId "workspace123" -CapacityId "capacity456"
        ```

    .NOTES
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding()]
    [Alias("Assign-FabricWorkspaceCapacity")]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$CapacityId
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/assignToCapacity"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            capacityId = $CapacityId
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json -Depth 4
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        # Invoke Fabric API request
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            Body           = $bodyJson
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams
        Write-Message -Message "Successfully assigned workspace with ID '$WorkspaceId' to capacity with ID '$CapacityId'." -Level Info
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to assign workspace with ID '$WorkspaceId' to capacity with ID '$CapacityId'. Error: $errorDetails" -Level Error
    }
}
