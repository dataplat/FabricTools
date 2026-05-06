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
    Deletes the Eventstream with ID "67890" from workspace "12345".

    ```powershell
    Remove-FabricEventstream -WorkspaceId "12345" -EventstreamId "67890"
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

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
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/eventstreams/$EventstreamId"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Remove Eventstream")) {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Delete'
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Eventstream '$EventstreamId' deleted successfully from workspace '$WorkspaceId'." -Level Info
        }

    }
    catch
    {
        # Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete Eventstream '$EventstreamId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
