function Remove-FabricDomainWorkspaceRoleAssignment {
<#
.SYNOPSIS
Bulk unassign roles to principals for workspaces in a Fabric domain.

.DESCRIPTION
The `AssignFabricDomainWorkspaceRoleAssignment` function performs bulk role assignments for principals in a specific Fabric domain. It sends a POST request to the relevant API endpoint.

.PARAMETER DomainId
The unique identifier of the Fabric domain where roles will be assigned.

.PARAMETER DomainRole
The role to assign to the principals. Must be one of the following:
- `Admins`
- `Contributors`

.PARAMETER PrincipalIds
An array of principals to assign roles to. Each principal must include:
- `id`: The identifier of the principal.
- `type`: The type of the principal (e.g., `User`, `Group`).

.EXAMPLE
    Unassign the `Admins` role to the specified principals in the domain with ID "12345".

    ```powershell
    Unassign-FabricDomainWorkspaceRoleAssignment -DomainId "12345" -DomainRole "Admins" -PrincipalIds @(@{id="user1"; type="User"}, @{id="group1"; type="Group"})
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [Alias("Unassign-FabricDomainWorkspaceRoleAssignment")]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$DomainId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Admins', 'Contributors')]
        [string]$DomainRole,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [array]$PrincipalIds # Array with 'id' and 'type'
    )

    # Validate PrincipalIds structure
    foreach ($principal in $PrincipalIds) {
        if (-not ($principal.id -and $principal.type)) {
            throw "Invalid principal detected: Each principal must include 'id' and 'type' properties. Found: $principal"
        }
    }

    # Ensure token validity
    Confirm-TokenState

    $body = @{
        type       = $DomainRole
        principals = $PrincipalIds
    }

    $bodyJson = $body | ConvertTo-Json -Depth 2
    Write-Message -Message "Request Body: $bodyJson" -Level Debug

    if ($PSCmdlet.ShouldProcess($DomainId, "Unassign Roles")) {
        $apiParams = @{
            Uri            = "admin/domains/$DomainId/roleAssignments/bulkUnassign"
            Method         = 'Post'
            Body           = $bodyJson
            TypeName       = 'Domain'
            ObjectIdOrName = $DomainId
            HandleResponse = $true
        }

        Invoke-FabricRestMethod @apiParams
        Write-Message -Message "Bulk role unassignment for domain '$DomainId' completed successfully!" -Level Info
    }
}
