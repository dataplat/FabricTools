function Publish-FabricEnvironment {
<#
.SYNOPSIS
Publishes a staging environment in a specified Microsoft Fabric workspace.

.DESCRIPTION
This function interacts with the Microsoft Fabric API to initiate the publishing process for a staging environment.
It validates the authentication token, constructs the API request, and handles both immediate and long-running operations.


.PARAMETER WorkspaceId
The unique identifier of the workspace containing the staging environment.

.PARAMETER EnvironmentId
The unique identifier of the staging environment to be published.

.EXAMPLE
    Initiates the publishing process for the specified staging environment.

    ```powershell
    Publish-FabricEnvironment -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"
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
        $apiEndpointUrl = "workspaces/{0}/environments/{1}/staging/publish" -f $WorkspaceId, $EnvironmentId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Make the API request
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            TypeName       = 'Environment'
            ObjectIdOrName = $EnvironmentId
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams

        Write-Message -Message "Publish operation request has been submitted successfully for the environment '$EnvironmentId'!" -Level Info
        return $response
    } catch {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create environment. Error: $errorDetails" -Level Error
    }
}
