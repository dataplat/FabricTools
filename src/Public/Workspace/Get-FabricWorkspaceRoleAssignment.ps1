function Get-FabricWorkspaceRoleAssignment {
    <#
    .SYNOPSIS
        Retrieves role assignments for a specified Fabric workspace.

    .DESCRIPTION
        The `Get-FabricWorkspaceRoleAssignments` function fetches the role assignments associated with a Fabric workspace by making a GET request to the API. If `WorkspaceRoleAssignmentId` is provided, it retrieves the specific role assignment.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace to fetch role assignments for.

    .PARAMETER WorkspaceRoleAssignmentId
        (Optional) The unique identifier of a specific role assignment to retrieve.

    .EXAMPLE
        Fetches all role assignments for the workspace with the ID "workspace123".

        ```powershell
        Get-FabricWorkspaceRoleAssignments -WorkspaceId "workspace123"
        ```

    .EXAMPLE
        Fetches the role assignment with the ID "role123" for the workspace "workspace123".

        ```powershell
        Get-FabricWorkspaceRoleAssignments -WorkspaceId "workspace123" -WorkspaceRoleAssignmentId "role123"
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.

        Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceRoleAssignmentId
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/roleAssignments"
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Make the API request
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            ExtractValue   = 'True'
            HandleResponse = $true
        }
        $workspaceRoles = @(Invoke-FabricRestMethod @apiParams)
        # Filter results based on provided parameters
        $roleAssignments = if ($WorkspaceRoleAssignmentId) {
            $workspaceRoles | Where-Object { $_.Id -eq $WorkspaceRoleAssignmentId }
        } else {
            $workspaceRoles
        }

        # Handle results
        if ($roleAssignments) {
            Write-Message -Message "Found $($roleAssignments.Count) role assignments for WorkspaceId '$WorkspaceId'." -Level Debug
            # Transform data into custom objects
            $results = foreach ($obj in $roleAssignments) {
                [PSCustomObject]@{
                    ID                = $obj.id
                    PrincipalId       = $obj.principal.id
                    DisplayName       = $obj.principal.displayName
                    Type              = $obj.principal.type
                    UserPrincipalName = $obj.principal.userDetails.userPrincipalName
                    aadAppId          = $obj.principal.servicePrincipalDetails.aadAppId
                    Role              = $obj.role
                }
            }
            return $results
        } else {
            if ($WorkspaceRoleAssignmentId) {
                Write-Message -Message "No role assignment found with ID '$WorkspaceRoleAssignmentId' for WorkspaceId '$WorkspaceId'." -Level Warning
            } else {
                Write-Message -Message "No role assignments found for WorkspaceId '$WorkspaceId'." -Level Warning
            }
            return @()
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve role assignments for WorkspaceId '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
