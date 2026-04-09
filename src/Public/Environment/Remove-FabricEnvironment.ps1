function Remove-FabricEnvironment
{
<#
.SYNOPSIS
Deletes an environment from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Remove-FabricEnvironment` function sends a DELETE request to the Fabric API to remove a specified environment from a given workspace.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace containing the environment to delete.

.PARAMETER EnvironmentId
(Mandatory) The ID of the environment to be deleted.

.EXAMPLE
    Deletes the environment with ID "67890" from workspace "12345".

    ```powershell
    Remove-FabricEnvironment -WorkspaceId "12345" -EnvironmentId "67890"
    ```

.NOTES
- Validates token expiration before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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

    if ($PSCmdlet.ShouldProcess($EnvironmentId, "Remove Environment"))
    {
        $apiParams = @{
            Uri            = "workspaces/$WorkspaceId/environments/$EnvironmentId"
            Method         = 'Delete'
            TypeName       = 'Environment'
            ObjectIdOrName = $EnvironmentId
            HandleResponse = $true
        }

        Invoke-FabricRestMethod @apiParams
        Write-Message -Message "Environment '$EnvironmentId' deleted successfully from workspace '$WorkspaceId'." -Level Info
    }
}
