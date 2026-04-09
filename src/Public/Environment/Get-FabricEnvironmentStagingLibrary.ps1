function Get-FabricEnvironmentStagingLibrary {
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
    Retrieves the staging libraries for the specified environment in the given workspace.

    ```powershell
    Get-FabricEnvironmentStagingLibrary -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"
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
        Uri            = "workspaces/$WorkspaceId/environments/$EnvironmentId/staging/libraries"
        Method         = 'Get'
        TypeName       = 'Environment'
        ObjectIdOrName = $EnvironmentId
        HandleResponse = $true
    }

    $response = Invoke-FabricRestMethod @apiParams
    $response.customLibraries
}
