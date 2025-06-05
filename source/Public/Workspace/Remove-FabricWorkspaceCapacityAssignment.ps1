<#
.SYNOPSIS
Unassigns a Fabric workspace from its capacity.

.DESCRIPTION
The `Remove-FabricWorkspaceCapacityAssignment` function sends a POST request to unassign a workspace from its assigned capacity.

.PARAMETER WorkspaceId
The unique identifier of the workspace to be unassigned from its capacity.

.EXAMPLE
Remove-FabricWorkspaceCapacityAssignment -WorkspaceId "workspace123"

Unassigns the workspace with ID "workspace123" from its capacity.

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Test-TokenExpired` to ensure token validity before making the API request.

Author: Tiago Balabuch
#>

function Remove-FabricWorkspaceCapacityAssignment
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [Alias("Unassign-FabricWorkspaceCapacity")]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId
    )
    try
    {
        # Step 1: Ensure token validity
        Test-TokenExpired

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/unassignFromCapacity" -f $FabricConfig.BaseUrl, $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Message

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Unassign Workspace from Capacity"))
        {
            # Step 3: Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Post
        }
        # Step 4: Validate the response code
        if ($statusCode -ne 202)
        {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        Write-Message -Message "Workspace capacity has been successfully unassigned from workspace '$WorkspaceId'." -Level Info
    }
    catch
    {
        # Step 5: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to unassign workspace from capacity. Error: $errorDetails" -Level Error
    }
}
