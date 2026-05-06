function Remove-FabricKQLQueryset
{
<#
.SYNOPSIS
Deletes an KQLQueryset from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Remove-FabricKQLQueryset` function sends a DELETE request to the Fabric API to remove a specified KQLQueryset from a given workspace.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace containing the KQLQueryset to delete.

.PARAMETER KQLQuerysetId
(Mandatory) The ID of the KQLQueryset to be deleted.

.EXAMPLE
    Deletes the KQLQueryset with ID "67890" from workspace "12345".

    ```powershell
    Remove-FabricKQLQueryset -WorkspaceId "12345" -KQLQuerysetId "67890"
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
        [guid]$KQLQuerysetId
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/kqlQuerysets/$KQLQuerysetId"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Remove KQLQueryset")) {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Delete'
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "KQLQueryset '$KQLQuerysetId' deleted successfully from workspace '$WorkspaceId'." -Level Info
        }

    }
    catch
    {
        # Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete KQLQueryset '$KQLQuerysetId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
