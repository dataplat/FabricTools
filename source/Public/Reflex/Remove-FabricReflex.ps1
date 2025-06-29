<#
.SYNOPSIS
    Removes an Reflex from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a DELETE request to the Microsoft Fabric API to remove an Reflex
    from the specified workspace using the provided WorkspaceId and ReflexId.

.PARAMETER WorkspaceId
    The unique identifier of the workspace from which the Reflex will be removed.

.PARAMETER ReflexId
    The unique identifier of the Reflex to be removed.

.EXAMPLE
    Remove-FabricReflex -WorkspaceId "workspace-12345" -ReflexId "Reflex-67890"
    This example removes the Reflex with ID "Reflex-67890" from the workspace with ID "workspace-12345".

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch

#>
function Remove-FabricReflex
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$ReflexId
    )
    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/reflexes/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $ReflexId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Remove Reflex"))
        {
            # Step 3: Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Delete
        }

        # Step 4: Handle response
        if ($statusCode -ne 200)
        {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        Write-Message -Message "Reflex '$ReflexId' deleted successfully from workspace '$WorkspaceId'." -Level Info
    }
    catch
    {
        # Step 5: Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete Reflex '$ReflexId'. Error: $errorDetails" -Level Error
    }
}
