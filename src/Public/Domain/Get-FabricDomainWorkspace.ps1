function Get-FabricDomainWorkspace {
<#
.SYNOPSIS
Retrieves the workspaces associated with a specific domain in Microsoft Fabric.

.DESCRIPTION
The `Get-FabricDomainWorkspace` function fetches the workspaces for the given domain ID.

.PARAMETER DomainId
The ID of the domain for which to retrieve workspaces.

.EXAMPLE
    Fetches workspaces for the domain with ID "12345".

    ```powershell
    Get-FabricDomainWorkspace -DomainId "12345"
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$DomainId
    )

    # Ensure token validity
    Confirm-TokenState

    $apiParams = @{
        Uri            = "admin/domains/$DomainId/workspaces"
        Method         = 'Get'
        TypeName       = 'Domain'
        ObjectIdOrName = $DomainId
        HandleResponse = $true
        ExtractValue   = 'True'
    }

    @(Invoke-FabricRestMethod @apiParams)
}
