function Remove-FabricDomain
{
<#
.SYNOPSIS
Deletes a Fabric domain by its ID.

.DESCRIPTION
The `Remove-FabricDomain` function removes a specified domain from Microsoft Fabric by making a DELETE request to the relevant API endpoint.

.PARAMETER DomainId
The unique identifier of the domain to be deleted.

.EXAMPLE
    Deletes the domain with ID "12345".

    ```powershell
    Remove-FabricDomain -DomainId "12345"
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$DomainId
    )

    # Ensure token validity
    Confirm-TokenState

    if ($PSCmdlet.ShouldProcess($DomainId, "Remove Domain"))
    {
        $apiParams = @{
            Uri            = "admin/domains/$DomainId"
            Method         = 'Delete'
            TypeName       = 'Domain'
            ObjectIdOrName = $DomainId
            HandleResponse = $true
        }

        Invoke-FabricRestMethod @apiParams
        Write-Message -Message "Domain '$DomainId' deleted successfully!" -Level Info
    }
}
