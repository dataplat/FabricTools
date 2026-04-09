function Add-FabricDomainWorkspaceAssignmentById {
<#
.SYNOPSIS
Assigns workspaces to a specified domain in Microsoft Fabric by their IDs.

.DESCRIPTION
The `Add-FabricDomainWorkspaceAssignmentById` function sends a request to assign multiple workspaces to a specified domain using the provided domain ID and an array of workspace IDs.

.PARAMETER DomainId
The ID of the domain to which workspaces will be assigned. This parameter is mandatory.

.PARAMETER WorkspaceIds
An array of workspace IDs to be assigned to the domain. This parameter is mandatory.

.EXAMPLE
    Assigns the workspaces with IDs "ws1", "ws2", and "ws3" to the domain with ID "12345".

    ```powershell
    Add-FabricDomainWorkspaceAssignmentById -DomainId "12345" -WorkspaceIds @("ws1", "ws2", "ws3")
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski
#>
    [CmdletBinding()]
    [Alias("Assign-FabricDomainWorkspaceById")]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$DomainId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid[]]$WorkspaceIds
    )

    # Ensure token validity
    Confirm-TokenState

    $body = @{
        workspacesIds = $WorkspaceIds
    }

    $bodyJson = $body | ConvertTo-Json -Depth 2
    Write-Message -Message "Request Body: $bodyJson" -Level Debug

    $apiParams = @{
        Uri            = "admin/domains/$DomainId/assignWorkspaces"
        Method         = 'Post'
        Body           = $bodyJson
        TypeName       = 'Domain'
        ObjectIdOrName = $DomainId
        HandleResponse = $true
    }

    Invoke-FabricRestMethod @apiParams
    Write-Message -Message "Successfully assigned workspaces to the domain with ID '$DomainId'." -Level Info
}
