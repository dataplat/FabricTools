<#
.SYNOPSIS
Retrieves the list of libraries associated with a specific environment in a Microsoft Fabric workspace.

.DESCRIPTION
The Get-FabricEnvironmentLibrary function fetches library information for a given workspace and environment
using the Microsoft Fabric API. It ensures the authentication token is valid and validates the response
to handle errors gracefully.

.PARAMETER WorkspaceId
(Mandatory) The unique identifier of the workspace where the environment is located.

.PARAMETER EnvironmentId
The unique identifier of the environment whose libraries are being queried.

.EXAMPLE
Get-FabricEnvironmentLibrary -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"

Retrieves the libraries associated with the specified environment in the given workspace.

.NOTES
- Requires the `$FabricConfig` global object, including `BaseUrl` and `FabricHeaders`.
- Uses `Confirm-TokenState` to validate the token before making API calls.

Author: Tiago Balabuch
#>
function Get-FabricEnvironmentLibrary {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$EnvironmentId
    )

    try {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/environments/{2}/libraries" -f $FabricConfig.BaseUrl, $WorkspaceId, $EnvironmentId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Make the API request
        $response = Invoke-FabricRestMethod `
            -Uri $apiEndpointUrl `
            -Method Get

        # Step 4: Validate the response code
        if ($statusCode -ne 200) {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        # Step 5: Handle results
        return $response
    } catch {
        # Step 6: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve environment libraries. Error: $errorDetails" -Level Error
    }

}
