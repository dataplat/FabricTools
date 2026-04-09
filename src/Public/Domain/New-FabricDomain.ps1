function New-FabricDomain
{
<#
.SYNOPSIS
Creates a new Fabric domain.

.DESCRIPTION
The `Add-FabricDomain` function creates a new domain in Microsoft Fabric by making a POST request to the relevant API endpoint.

.PARAMETER DomainName
The name of the domain to be created. Must only contain alphanumeric characters, underscores, and spaces.

.PARAMETER DomainDescription
A description of the domain to be created.

.PARAMETER ParentDomainId
(Optional) The ID of the parent domain, if applicable.

.EXAMPLE
    Creates a "Finance" domain under the parent domain with ID "12345".

    ```powershell
    Add-FabricDomain -DomainName "Finance" -DomainDescription "Finance data domain" -ParentDomainId "12345"
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DomainName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$DomainDescription,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$ParentDomainId
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

    if ($ParentDomainId)
    {
        $body.parentDomainId = $ParentDomainId
    }

    $bodyJson = $body | ConvertTo-Json -Depth 2
    Write-Message -Message "Request Body: $bodyJson" -Level Debug

    if ($PSCmdlet.ShouldProcess($DomainName, "Create Domain"))
    {
        $apiParams = @{
            Uri            = "admin/domains"
            Method         = 'Post'
            Body           = $bodyJson
            TypeName       = 'Domain'
            ObjectIdOrName = $DomainName
            HandleResponse = $true
        }

        $response = Invoke-FabricRestMethod @apiParams
        Write-Message -Message "Domain '$DomainName' created successfully!" -Level Info
        $response
    }
}
