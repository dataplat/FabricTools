function Get-FabricEnvironment {

    <#
.SYNOPSIS
Retrieves an environment or a list of environments from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Get-FabricEnvironment` function sends a GET request to the Fabric API to retrieve environment details for a given workspace. It can filter the results by `EnvironmentName`.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace to query environments.

.PARAMETER EnvironmentId
(Optional) The ID of a specific environment to retrieve.

.PARAMETER EnvironmentName
(Optional) The name of the specific environment to retrieve.

.EXAMPLE
    Retrieves the "Development" environment from workspace "12345".

    ```powershell
    Get-FabricEnvironment -WorkspaceId "12345" -EnvironmentName "Development"
    ```

.EXAMPLE
    Retrieves all environments in workspace "12345".

    ```powershell
    Get-FabricEnvironment -WorkspaceId "12345"
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Returns the matching environment details or all environments if no filter is provided.

Author: Tiago Balabuch, Kamil Nowinski

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$EnvironmentId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EnvironmentName
    )

    # Handle ambiguous input
    if ($EnvironmentId -and $EnvironmentName) {
        Write-Message -Message "Both 'EnvironmentId' and 'EnvironmentName' were provided. Please specify only one." -Level Error
        return $null
    }

    # Ensure token validity
    Confirm-TokenState

    $apiParams = @{
        Uri            = "workspaces/$WorkspaceId/environments"
        Method         = 'Get'
        TypeName       = 'Environment'
        ObjectIdOrName = $EnvironmentName
        HandleResponse = $true
        ExtractValue   = 'True'
    }

    $environments = @(Invoke-FabricRestMethod @apiParams)

    if ($EnvironmentId) {
        $environments | Where-Object { $_.Id -eq $EnvironmentId }
    } elseif ($EnvironmentName) {
        $environments | Where-Object { $_.DisplayName -eq $EnvironmentName }
    } else {
        $environments
    }
}
