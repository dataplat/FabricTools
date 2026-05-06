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

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/{0}/environments/{1}" -f $WorkspaceId, $EnvironmentId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Remove Environment"))
        {
            # Make the API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Delete'
                TypeName       = 'Environment'
                ObjectIdOrName = $EnvironmentId
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
        }

        Write-Message -Message "Environment '$EnvironmentId' deleted successfully from workspace '$WorkspaceId'." -Level Info

    }
    catch
    {
        # Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete environment '$EnvironmentId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
