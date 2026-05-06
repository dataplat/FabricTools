function Update-FabricReport
{
<#
.SYNOPSIS
    Updates an existing Report in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a PATCH request to the Microsoft Fabric API to update an existing Report
    in the specified workspace. It supports optional parameters for Report description.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Report exists. This parameter is optional.

.PARAMETER ReportId
    The unique identifier of the Report to be updated. This parameter is mandatory.

.PARAMETER ReportName
    The new name of the Report. This parameter is mandatory.

.PARAMETER ReportDescription
    An optional new description for the Report.

.EXAMPLE
    This example updates the Report with ID "Report-67890" in the workspace with ID "workspace-12345" with a new name and description.

    ```powershell
    Update-FabricReport -WorkspaceId "workspace-12345" -ReportId "Report-67890" -ReportName "Updated Report" -ReportDescription "Updated description"
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
        [guid]$ReportId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ReportName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ReportDescription
    )
    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/reports/$ReportId"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $ReportName
        }

        if ($ReportDescription)
        {
            $body.description = $ReportDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($ReportName, "Update Report"))
        {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Patch'
                Body           = $bodyJson
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Report '$ReportName' updated successfully!" -Level Info
            return $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update Report. Error: $errorDetails" -Level Error
    }
}
