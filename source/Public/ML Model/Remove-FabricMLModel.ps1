<#
.SYNOPSIS
    Removes an ML Model from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a DELETE request to the Microsoft Fabric API to remove an ML Model
    from the specified workspace using the provided WorkspaceId and MLModelId.

.PARAMETER WorkspaceId
    The unique identifier of the workspace from which the ML Model will be removed.

.PARAMETER MLModelId
    The unique identifier of the ML Model to be removed.

.EXAMPLE
    Remove-FabricMLModel -WorkspaceId "workspace-12345" -MLModelId "model-67890"
    This example removes the ML Model with ID "model-67890" from the workspace with ID "workspace-12345".

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch

#>
function Remove-FabricMLModel
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$MLModelId
    )
    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/mlModels/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $MLModelId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Remove ML Model"))
        {
            # Step 3: Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Delete
        }
        # Step 4: Validate the response code
        if ($statusCode -ne 200)
        {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }
        Write-Message -Message "ML Model '$MLModelId' deleted successfully from workspace '$WorkspaceId'." -Level Info

    }
    catch
    {
        # Step 5: Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete ML Model '$MLModelId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
