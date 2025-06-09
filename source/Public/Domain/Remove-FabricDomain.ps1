<#
.SYNOPSIS
Deletes a Fabric domain by its ID.

.DESCRIPTION
The `Remove-FabricDomain` function removes a specified domain from Microsoft Fabric by making a DELETE request to the relevant API endpoint.

.PARAMETER DomainId
The unique identifier of the domain to be deleted.

.EXAMPLE
Remove-FabricDomain -DomainId "12345"

Deletes the domain with ID "12345".

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

#>

function Remove-FabricDomain
{
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DomainId
    )

    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/admin/domains/{1}" -f $FabricConfig.BaseUrl, $DomainId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Remove Domain"))
        {
            # Step 3: Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Delete
        }

        # Step 4: Validate the response code
        if ($statusCode -ne 200)
        {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        Write-Message -Message "Domain '$DomainId' deleted successfully!" -Level Info

    }
    catch
    {
        # Step 5: Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete domain '$DomainId'. Error: $errorDetails" -Level Error
    }
}
