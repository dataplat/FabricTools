function Update-FabricWorkspaceRoleAssignment
{
    <#
    .SYNOPSIS
        Updates the role assignment for a specific principal in a Fabric workspace.

    .DESCRIPTION
        The `Update-FabricWorkspaceRoleAssignment` function updates the role assigned to a principal in a workspace by making a PATCH request to the API.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace where the role assignment exists.

    .PARAMETER WorkspaceRoleAssignmentId
        The unique identifier of the role assignment to be updated.

    .PARAMETER WorkspaceRole
        The new role to assign to the principal. Must be one of the following:
        - Admin
        - Contributor
        - Member
        - Viewer

    .EXAMPLE
        Updates the role assignment to "Admin" for the specified workspace and role assignment.

        ```powershell
        Update-FabricWorkspaceRoleAssignment -WorkspaceId "workspace123" -WorkspaceRoleAssignmentId "assignment456" -WorkspaceRole "Admin"
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.

        Author: Tiago Balabuch, Kamil Nowinski
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceRoleAssignmentId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Admin', 'Contributor', 'Member', 'Viewer')]
        [string]$WorkspaceRole
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/roleAssignments/$WorkspaceRoleAssignmentId"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            role = $WorkspaceRole
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json -Depth 4 -Compress
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Update Role Assignment"))
        {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Patch'
                Body           = $bodyJson
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            # Handle empty response
            if (-not $response)
            {
                Write-Message -Message "No data returned from the API." -Level Warning
                return $null
            }

            Write-Message -Message "Role assignment $WorkspaceRoleAssignmentId updated successfully in workspace '$WorkspaceId'." -Level Info
            return $response
        }

    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update role assignment. Error: $errorDetails" -Level Error
    }
}
