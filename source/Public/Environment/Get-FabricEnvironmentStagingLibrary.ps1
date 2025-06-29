<#
.SYNOPSIS
Retrieves the staging library details for a specific environment in a Microsoft Fabric workspace.

.DESCRIPTION
The Get-FabricEnvironmentStagingLibrary function interacts with the Microsoft Fabric API to fetch information
about staging libraries associated with a specified environment. It ensures token validity and handles API errors gracefully.

.PARAMETER WorkspaceId
The unique identifier of the workspace containing the target environment.

.PARAMETER EnvironmentId
The unique identifier of the environment for which staging library details are being retrieved.

.EXAMPLE
Get-FabricEnvironmentStagingLibrary -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"

Retrieves the staging libraries for the specified environment in the given workspace.

.NOTES
- Requires the `$FabricConfig` global object, including `BaseUrl` and `FabricHeaders`.
- Uses `Confirm-TokenState` to validate the token before making API calls.

Author: Tiago Balabuch
#>
function Get-FabricEnvironmentStagingLibrary {
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
        $apiEndpointUrl = "{0}/workspaces/{1}/environments/{2}/staging/libraries" -f $FabricConfig.BaseUrl, $WorkspaceId, $EnvironmentId
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
        return $response.customLibraries
    } catch {
        # Step 6: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve environment spark compute. Error: $errorDetails" -Level Error
    }

}
