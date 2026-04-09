function Update-FabricDomain
{
<#
.SYNOPSIS
Updates a Fabric domain by its ID.

.DESCRIPTION
The `Update-FabricDomain` function modifies a specified domain in Microsoft Fabric using the provided parameters.

.PARAMETER DomainId
The unique identifier of the domain to be updated.

.PARAMETER DomainName
The new name for the domain. Must be alphanumeric.

.PARAMETER DomainDescription
(Optional) A new description for the domain.

.PARAMETER DomainContributorsScope
(Optional) The contributors' scope for the domain. Accepted values: 'AdminsOnly', 'AllTenant', 'SpecificUsersAndGroups'.

.EXAMPLE
    Updates the domain with ID "12345" with a new name, description, and contributors' scope.

    ```powershell
    Update-FabricDomain -DomainId "12345" -DomainName "NewDomain" -DomainDescription "Updated description" -DomainContributorsScope "AdminsOnly"
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$DomainId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DomainName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$DomainDescription,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('AdminsOnly', 'AllTenant', 'SpecificUsersAndGroups')]
        [string]$DomainContributorsScope
    )

    # Ensure token validity
    Confirm-TokenState

    # Construct the request body
    $body = @{
        displayName = $DomainName
    }

    if ($DomainDescription)
    {
        $body.description = $DomainDescription
    }

    if ($DomainContributorsScope)
    {
        $body.contributorsScope = $DomainContributorsScope
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10
    Write-Message -Message "Request Body: $bodyJson" -Level Debug

    if ($PSCmdlet.ShouldProcess($DomainName, "Update Domain"))
    {
        $apiParams = @{
            Uri            = "admin/domains/$DomainId"
            Method         = 'Patch'
            Body           = $bodyJson
            TypeName       = 'Domain'
            ObjectIdOrName = $DomainName
            HandleResponse = $true
        }

        $response = Invoke-FabricRestMethod @apiParams
        Write-Message -Message "Domain '$DomainName' updated successfully!" -Level Info
        $response
    }
}
