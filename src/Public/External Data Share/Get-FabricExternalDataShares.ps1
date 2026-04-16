function Get-FabricExternalDataShares {
<#
.SYNOPSIS
    Retrieves External Data Shares details from a specified Microsoft Fabric.

.DESCRIPTION
    This function retrieves External Data Shares details.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.EXAMPLE
    This example retrieves the External Data Shares details

    ```powershell
    Get-FabricExternalDataShares
    ```

.NOTES
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch, Kamil Nowinski
#>
    [CmdletBinding()]
    param ( )

    try {

        # Validate authentication token before proceeding
        Confirm-TokenState

        # Construct the API endpoint URL for retrieving external data shares
        $apiEndpointUrl = "admin/items/externalDataShares"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Invoke the Fabric API request to retrieve external data shares
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            HandleResponse = $true
        }
        $externalDataShares = Invoke-FabricRestMethod @apiParams

        # Return the retrieved external data shares
        Write-Message -Message "Successfully retrieved external data shares." -Level Debug
        return $externalDataShares
    } catch {
        # Capture and log detailed error information if the API request fails
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve External Data Shares. Error: $errorDetails" -Level Error
    }

}
