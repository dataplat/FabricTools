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
Stop-FabricEnvironmentPublish -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"

Cancels the publish operation for the specified environment.

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Validates token expiration before making the API request.

Author: Tiago Balabuch

#>
function Stop-FabricEnvironmentPublish
{
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
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/environments/{2}/staging/cancelPublish" -f $FabricConfig.BaseUrl, $WorkspaceId, $EnvironmentId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Cancel Publish"))
        {
            # Step 3: Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Post `
                -Body $bodyJson
        }

        # Step 4: Validate the response code
        if ($statusCode -ne 200)
        {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }
        Write-Message -Message "Publication for environment '$EnvironmentId' has been successfully canceled." -Level Info

    }
    catch
    {
        # Step 5: Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to cancel publication for environment '$EnvironmentId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
