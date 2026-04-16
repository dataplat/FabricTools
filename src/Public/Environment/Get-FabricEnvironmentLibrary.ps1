function Get-FabricEnvironmentLibrary {
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
    Retrieves the libraries associated with the specified environment in the given workspace.

    ```powershell
    Get-FabricEnvironmentLibrary -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"
    ```

.NOTES
- Uses `Confirm-TokenState` to validate the token before making API calls.

Author: Tiago Balabuch, Kamil Nowinski
#>
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
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/{0}/environments/{1}/libraries" -f $WorkspaceId, $EnvironmentId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Make the API request
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            TypeName       = 'Environment'
            ObjectIdOrName = $EnvironmentId
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams

        # Handle results
        return $response
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve environment libraries. Error: $errorDetails" -Level Error
    }

}
