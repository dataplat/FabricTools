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

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "admin/domains/{0}/workspaces" -f $DomainId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Make the API request
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            TypeName       = 'Domain'
            ObjectIdOrName = $DomainId
            HandleResponse = $true
            ExtractValue   = 'True'
        }
        $response = Invoke-FabricRestMethod @apiParams

        # Handle empty response
        if ($response.Count -eq 0) {
            Write-Message -Message "No workspace found for the '$DomainId'." -Level Warning
            return $null
        }
        return $response

    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve domain workspaces. Error: $errorDetails" -Level Error
    }
}
