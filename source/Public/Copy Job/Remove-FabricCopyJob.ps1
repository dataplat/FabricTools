<#
.SYNOPSIS
    Deletes a Copy Job from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function performs a DELETE operation on the Microsoft Fabric API to remove a Copy Job
    from the specified workspace using the provided WorkspaceId and CopyJobId parameters.

.PARAMETER WorkspaceId
    The unique identifier of the workspace containing the Copy Job to be deleted.

.PARAMETER CopyJobId
    The unique identifier of the Copy Job to delete.

.EXAMPLE
    Deletes the Copy Job with ID "copyjob-67890" from the workspace with ID "workspace-12345".

    ```powershell
    Remove-FabricCopyJob -WorkspaceId "workspace-12345" -CopyJobId "copyjob-67890"
    ```

.NOTES
    - Requires the `$FabricConfig` global configuration, which must include `BaseUrl` and `FabricHeaders`.
    - Ensures token validity by invoking `Confirm-TokenState` before making the API request.

    Author: Tiago Balabuch
#>
function Remove-FabricCopyJob {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$CopyJobId
    )
    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URI
        $apiEndpointURI = "workspaces/{0}/copyJobs/{1}" -f $WorkspaceId, $CopyJobId
        Write-Message -Message "API Endpoint: $apiEndpointURI" -Level Debug

        if($PSCmdlet.ShouldProcess($apiEndpointURI, "Delete Copy Job")) {

        # Make the API request
        $apiParams = @{
            Uri = $apiEndpointURI
            Method = 'DELETE'
        }
        $response = Invoke-FabricRestMethod @apiParams
    }
    Write-Message -Message "Copy Job '$CopyJobId' deleted successfully from workspace '$WorkspaceId'." -Level Info
    return $response

} catch {
    # Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete Copy Job '$CopyJobId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
