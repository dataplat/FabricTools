function Remove-FabricEventstream
{
    <#
.SYNOPSIS
Deletes an Eventstream from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Remove-FabricEventstream` function sends a DELETE request to the Fabric API to remove a specified Eventstream from a given workspace.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace containing the Eventstream to delete.

.PARAMETER EventstreamId
(Mandatory) The ID of the Eventstream to be deleted.

.PARAMETER EventstreamName
    The name of the Eventstream to delete. The value for Eventstream is a string.
    An example of a string is 'MyEventstream'.
    The name of the Eventstream to delete. The value for Eventstream is a string.

.EXAMPLE
Remove-FabricEventstream -WorkspaceId "12345" -EventstreamId "67890"

Deletes the Eventstream with ID "67890" from workspace "12345".

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Validates token expiration before making the API request.

Author: Tiago Balabuch

    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$EventstreamId
        #TODO Add EventstreamName parameter to validate the name of the Eventstream to delete.
    )

    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/eventstreams/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $EventstreamId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Remove Eventstream"))
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
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }
        Write-Message -Message "Eventstream '$EventstreamId' deleted successfully from workspace '$WorkspaceId'." -Level Info

    }
    catch
    {
        # Step 5: Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete Eventstream '$EventstreamId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
