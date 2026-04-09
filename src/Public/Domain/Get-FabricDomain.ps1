function Get-FabricDomain {
<#
.SYNOPSIS
Retrieves domain information from Microsoft Fabric, optionally filtering by domain ID, domain name, or only non-empty domains.

.DESCRIPTION
The `Get-FabricDomain` function allows retrieval of domains in Microsoft Fabric, with optional filtering by domain ID or name. Additionally, it can filter to return only non-empty domains.

.PARAMETER DomainId
(Optional) The ID of the domain to retrieve.

.PARAMETER DomainName
(Optional) The display name of the domain to retrieve.

.PARAMETER NonEmptyDomainsOnly
(Optional) If set to `$true`, only domains containing workspaces will be returned.

.EXAMPLE
    Fetches the domain with ID "12345".

    ```powershell
    Get-FabricDomain -DomainId "12345"
    ```

.EXAMPLE
    Fetches the domain with the display name "Finance".

    ```powershell
    Get-FabricDomain -DomainName "Finance"
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$DomainId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$DomainName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]$NonEmptyDomainsOnly = $false
    )

    # Handle ambiguous input
    if ($DomainId -and $DomainName) {
        Write-Message -Message "Both 'DomainId' and 'DomainName' were provided. Please specify only one." -Level Error
        return @()
    }

    # Ensure token validity
    Confirm-TokenState

    $uri = "admin/domains"
    if ($NonEmptyDomainsOnly) {
        $uri = "$uri?nonEmptyOnly=true"
    }

    $apiParams = @{
        Uri            = $uri
        Method         = 'Get'
        TypeName       = 'Domain'
        ObjectIdOrName = $DomainName
        HandleResponse = $true
    }

    $response = Invoke-FabricRestMethod @apiParams

    if ($DomainId) {
        $response.domains | Where-Object { $_.Id -eq $DomainId }
    } elseif ($DomainName) {
        $response.domains | Where-Object { $_.DisplayName -eq $DomainName }
    } else {
        $response.domains
    }
}
