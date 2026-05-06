function Stop-FabricEnvironmentPublish
{
<#
.SYNOPSIS
Cancels the publish operation for a specified environment in Microsoft Fabric.

.DESCRIPTION
This function sends a cancel publish request to the Microsoft Fabric API for a given environment.
It ensures that the token is valid before making the request and handles both successful and error responses.

.PARAMETER WorkspaceId
The unique identifier of the workspace where the environment exists.

.PARAMETER EnvironmentId
The unique identifier of the environment for which the publish operation is to be canceled.

.EXAMPLE
    Cancels the publish operation for the specified environment.

    ```powershell
    Stop-FabricEnvironmentPublish -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"
    ```

.NOTES
- Validates token expiration before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding(SupportsShouldProcess)]
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
        $apiEndpointUrl = "workspaces/{0}/environments/{1}/staging/cancelPublish" -f $WorkspaceId, $EnvironmentId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Cancel Publish"))
        {
            # Make the API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                TypeName       = 'Environment'
                ObjectIdOrName = $EnvironmentId
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Publication for environment '$EnvironmentId' has been successfully canceled." -Level Info
        }

    }
    catch
    {
        # Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to cancel publication for environment '$EnvironmentId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
