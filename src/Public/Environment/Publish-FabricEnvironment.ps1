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

    # Ensure token validity
    Confirm-TokenState

    $apiParams = @{
        Uri            = "workspaces/$WorkspaceId/environments/$EnvironmentId/staging/publish"
        Method         = 'Post'
        TypeName       = 'Environment'
        ObjectIdOrName = $EnvironmentId
        HandleResponse = $true
    }

    $response = Invoke-FabricRestMethod @apiParams
    Write-Message -Message "Publish operation request has been submitted successfully for the environment '$EnvironmentId'!" -Level Info
    $response
}
