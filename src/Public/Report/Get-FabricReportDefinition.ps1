function Get-FabricReportDefinition {
<#
.SYNOPSIS
    Retrieves the definition of an Report from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function retrieves the definition of an Report from a specified workspace using the provided ReportId.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Report exists. This parameter is mandatory.

.PARAMETER ReportId
    The unique identifier of the Report to retrieve the definition for. This parameter is optional.

.PARAMETER ReportFormat
    The format in which to retrieve the Report definition. This parameter is optional.

.EXAMPLE
    This example retrieves the definition of the Report with ID "Report-67890" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricReportDefinition -WorkspaceId "workspace-12345" -ReportId "Report-67890"
    ```

.EXAMPLE
    This example retrieves the definition of the Report with ID "Report-67890" in the workspace with ID "workspace-12345" in JSON format.

    ```powershell
    Get-FabricReportDefinition -WorkspaceId "workspace-12345" -ReportId "Report-67890" -ReportFormat "json"
    ```

.NOTES
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$ReportId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ReportFormat
    )
    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/reports/$ReportId/getDefinition"

        if ($ReportFormat) {
            $apiEndpointUrl = "$apiEndpointUrl?format=$ReportFormat"
        }

        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Invoke Fabric API request
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams
        Write-Message -Message "Report '$ReportId' definition retrieved successfully!" -Level Debug
        return $response
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Report. Error: $errorDetails" -Level Error
    }

}
