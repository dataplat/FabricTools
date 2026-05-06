function Add-FabricWorkspaceRoleAssignment {
    <#
    .SYNOPSIS
        Assigns a role to a principal for a specified Fabric workspace.

    .DESCRIPTION
        The `Add-FabricWorkspaceRoleAssignments` function assigns a role (e.g., Admin, Contributor, Member, Viewer) to a principal (e.g., User, Group, ServicePrincipal) in a Fabric workspace by making a POST request to the API.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace.

    .PARAMETER PrincipalId
        The unique identifier of the principal (User, Group, etc.) to assign the role.

    .PARAMETER PrincipalType
        The type of the principal. Allowed values: Group, ServicePrincipal, ServicePrincipalProfile, User.

    .PARAMETER WorkspaceRole
        The role to assign to the principal. Allowed values: Admin, Contributor, Member, Viewer.

    .EXAMPLE
        Assigns the Admin role to the user with ID "principal123" in the workspace "workspace123".

        ```powershell
        Add-FabricWorkspaceRoleAssignment -WorkspaceId "workspace123" -PrincipalId "principal123" -PrincipalType "User" -WorkspaceRole "Admin"
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.

        Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$PrincipalId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Group', 'ServicePrincipal', 'ServicePrincipalProfile', 'User')]
        [string]$PrincipalType,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Admin', 'Contributor', 'Member', 'Viewer')]
        [string]$WorkspaceRole
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/roleAssignments"
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            principal = @{
                id   = $PrincipalId
                type = $PrincipalType
            }
            role      = $WorkspaceRole
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json -Depth 4
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        # Make the API request
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            Body           = $bodyJson
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams

        Write-Message -Message "Role '$WorkspaceRole' assigned to principal '$PrincipalId' successfully in workspace '$WorkspaceId'." -Level Info
        return $response

    } catch {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to assign role. Error: $errorDetails" -Level Error
    }
}
