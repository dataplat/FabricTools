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
        - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.

        Author: Tiago Balabuch
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
        $apiEndpointUrl = "{0}/workspaces/{1}/roleAssignments" -f $FabricConfig.BaseUrl, $WorkspaceId
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
        $response = Invoke-FabricRestMethod `
            -Uri $apiEndpointUrl `
            -Method Post `
            -Body $bodyJson

        # Validate the response code
        if ($statusCode -ne 201) {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        # Handle empty response
        if (-not $response) {
            Write-Message -Message "No data returned from the API." -Level Warning
            return $null
        }

        Write-Message -Message "Role '$WorkspaceRole' assigned to principal '$PrincipalId' successfully in workspace '$WorkspaceId'." -Level Info
        return $response

    } catch {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to assign role. Error: $errorDetails" -Level Error
    }
}
