function Remove-FabricWorkspaceRoleAssignment
{
    <#
    .SYNOPSIS
        Removes a role assignment from a Fabric workspace.

    .DESCRIPTION
        The `Remove-FabricWorkspaceRoleAssignment` function deletes a specific role assignment from a Fabric workspace by making a DELETE request to the API.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace.

    .PARAMETER WorkspaceRoleAssignmentId
        The unique identifier of the role assignment to be removed.

    .EXAMPLE
        Removes the role assignment with the ID "role123" from the workspace "workspace123".

        ```powershell
        Remove-FabricWorkspaceRoleAssignment -WorkspaceId "workspace123" -WorkspaceRoleAssignmentId "role123"
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.

        Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceRoleAssignmentId
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/roleAssignments/$WorkspaceRoleAssignmentId"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Delete Role Assignment"))
        {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Delete'
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Role assignment '$WorkspaceRoleAssignmentId' successfully removed from workspace '$WorkspaceId'." -Level Info
        }
    }
    catch
    {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to remove role assignments for WorkspaceId '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
