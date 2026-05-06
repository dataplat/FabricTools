function Remove-FabricWorkspaceCapacity
{
    <#
    .SYNOPSIS
        Unassigns a Fabric workspace from its capacity.

    .DESCRIPTION
        The `Remove-FabricWorkspaceCapacity` function sends a POST request to unassign a workspace from its assigned capacity.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace to be unassigned from its capacity.

    .EXAMPLE
        Unassign the workspace with ID "workspace123" from its capacity.

        ```powershell
        Remove-FabricWorkspaceCapacity -WorkspaceId "workspace123"
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.

        Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [Alias("Unassign-FabricWorkspaceCapacity")]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [guid]$WorkspaceId
    )
    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/unassignFromCapacity"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Unassign Workspace from Capacity"))
        {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Workspace capacity has been successfully unassigned from workspace '$WorkspaceId'." -Level Info
        }
    }
    catch
    {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to unassign workspace from capacity. Error: $errorDetails" -Level Error
    }
}
