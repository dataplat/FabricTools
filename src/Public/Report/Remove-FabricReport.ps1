function Remove-FabricReport
{
<#
.SYNOPSIS
    Removes an Report from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a DELETE request to the Microsoft Fabric API to remove an Report
    from the specified workspace using the provided WorkspaceId and ReportId.

.PARAMETER WorkspaceId
    The unique identifier of the workspace from which the Report will be removed.

.PARAMETER ReportId
    The unique identifier of the Report to be removed.

.EXAMPLE
    This example removes the Report with ID "Report-67890" from the workspace with ID "workspace-12345".

    ```powershell
    Remove-FabricReport -WorkspaceId "workspace-12345" -ReportId "Report-67890"
    ```

.NOTES
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$ReportId
    )
    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/reports/$ReportId"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Remove Report"))
        {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Delete'
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Report '$ReportId' deleted successfully from workspace '$WorkspaceId'." -Level Info
        }
    }
    catch
    {
        # Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete Report '$ReportId'. Error: $errorDetails" -Level Error
    }
}
