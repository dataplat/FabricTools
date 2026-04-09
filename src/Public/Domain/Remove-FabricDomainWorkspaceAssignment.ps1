function Remove-FabricDomainWorkspaceAssignment
{
<#
.SYNOPSIS
Unassign workspaces from a specified Fabric domain.

.DESCRIPTION
The `Unassign -FabricDomainWorkspace` function allows you to Unassign  specific workspaces from a given Fabric domain or unassign all workspaces if no workspace IDs are specified.
It makes a POST request to the relevant API endpoint for this operation.

.PARAMETER DomainId
The unique identifier of the Fabric domain.

.PARAMETER WorkspaceIds
(Optional) An array of workspace IDs to unassign. If not provided, all workspaces will be unassigned.

.EXAMPLE
    Unassigns all workspaces from the domain with ID "12345".

    ```powershell
    Remove-FabricDomainWorkspaceAssignment -DomainId "12345"
    ```

.EXAMPLE
    Unassigns the specified workspaces from the domain with ID "12345".

    ```powershell
    Remove-FabricDomainWorkspaceAssignment -DomainId "12345" -WorkspaceIds @("workspace1", "workspace2")
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [Alias("Unassign-FabricDomainWorkspace")]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$DomainId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid[]]$WorkspaceIds
    )

    # Ensure token validity
    Confirm-TokenState

    $endpointSuffix = if ($WorkspaceIds)
    {
        "unassignWorkspaces"
    }
    else
    {
        "unassignAllWorkspaces"
    }

    $bodyJson = if ($WorkspaceIds)
    {
        $body = @{ workspacesIds = $WorkspaceIds }
        $body | ConvertTo-Json -Depth 2
    }
    else
    {
        $null
    }

    Write-Message -Message "Request Body: $bodyJson" -Level Debug

    if ($PSCmdlet.ShouldProcess($DomainId, "Unassign Workspaces"))
    {
        $apiParams = @{
            Uri            = "admin/domains/$DomainId/$endpointSuffix"
            Method         = 'Post'
            TypeName       = 'Domain'
            ObjectIdOrName = $DomainId
            HandleResponse = $true
        }

        if ($bodyJson)
        {
            $apiParams.Body = $bodyJson
        }

        Invoke-FabricRestMethod @apiParams
        Write-Message -Message "Successfully unassigned workspaces to the domain with ID '$DomainId'." -Level Info
    }
}
