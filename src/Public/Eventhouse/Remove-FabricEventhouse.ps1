function Remove-FabricEventhouse
{

    <#
.SYNOPSIS
    Removes an Eventhouse from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a DELETE request to the Microsoft Fabric API to remove an Eventhouse
    from the specified workspace using the provided WorkspaceId and EventhouseId.

.PARAMETER WorkspaceId
    The unique identifier of the workspace from which the Eventhouse will be removed.

.PARAMETER EventhouseId
    The unique identifier of the Eventhouse to be removed.

.EXAMPLE
    This example removes the Eventhouse with ID "eventhouse-67890" from the workspace with ID "workspace-12345".

    ```powershell
    Remove-FabricEventhouse -WorkspaceId "workspace-12345" -EventhouseId "eventhouse-67890"
    ```

.NOTES
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch, Kamil Nowinski

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$EventhouseId
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/{$WorkspaceId}/eventhouses/{$EventhouseId}"
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($EventhouseId, "Remove Eventhouse"))
        {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Delete'
                TypeName       = 'Eventhouse'
                ObjectIdOrName = $EventhouseId
                HandleResponse = $true
            }

            Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Eventhouse '$EventhouseId' deleted successfully from workspace '$WorkspaceId'." -Level Info
        }
    }
    catch {
        # Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete Eventhouse '$EventhouseId'. Error: $errorDetails" -Level Error
    }
}
