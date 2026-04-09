function Get-FabricEnvironmentStagingSparkCompute {
    <#
.SYNOPSIS
Retrieves staging Spark compute details for a specific environment in a Microsoft Fabric workspace.

.DESCRIPTION
The Get-FabricEnvironmentStagingSparkCompute function interacts with the Microsoft Fabric API to fetch information
about staging Spark compute configurations for a specified environment. It ensures token validity and handles API errors gracefully.

.PARAMETER WorkspaceId
The unique identifier of the workspace containing the target environment.

.PARAMETER EnvironmentId
The unique identifier of the environment for which staging Spark compute details are being retrieved.

.EXAMPLE
    Retrieves the staging Spark compute configurations for the specified environment in the given workspace.

    ```powershell
    Get-FabricEnvironmentStagingSparkCompute -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"
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
        Uri            = "workspaces/$WorkspaceId/environments/$EnvironmentId/staging/sparkcompute"
        Method         = 'Get'
        TypeName       = 'Environment'
        ObjectIdOrName = $EnvironmentId
        HandleResponse = $true
    }

    Invoke-FabricRestMethod @apiParams
}
