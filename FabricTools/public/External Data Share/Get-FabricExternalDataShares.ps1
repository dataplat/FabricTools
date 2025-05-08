<#
.SYNOPSIS
    Retrieves External Data Shares details from a specified Microsoft Fabric.

.DESCRIPTION
    This function retrieves External Data Shares details.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.EXAMPLE
     Get-FabricExternalDataShares 
    This example retrieves the External Data Shares details

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Test-TokenExpired` to ensure token validity before making the API request.

    Author: Tiago Balabuch
#>
function Get-FabricExternalDataShares {
    [CmdletBinding()]
    param ( )

    try {
        
         # Validate authentication token before proceeding
        Write-Message -Message "Validating token..." -Level Debug
        Test-TokenExpired
        Write-Message -Message "Token validation completed." -Level Debug

       # Construct the API endpoint URI for retrieving external data shares
        Write-Message -Message "Constructing API endpoint URI..." -Level Debug
        $apiEndpointURI = "{0}/admin/items/externalDataShares" -f $FabricConfig.BaseUrl, $WorkspaceId
        
        # Invoke the API request to retrieve external data shares
        $externalDataShares = Invoke-FabricAPIRequest `
            -BaseURI $apiEndpointURI `
            -Headers $FabricConfig.FabricHeaders `
            -Method Get 

        # Return the retrieved external data shares
        Write-Message -Message "Successfully retrieved external data shares." -Level Debug
        return $externalDataShares
    }
    catch {
        # Capture and log detailed error information if the API request fails
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve External Data Shares. Error: $errorDetails" -Level Error
    } 
 
}
