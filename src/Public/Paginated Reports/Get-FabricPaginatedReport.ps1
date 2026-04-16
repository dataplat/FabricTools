function Get-FabricPaginatedReport {
<#
.SYNOPSIS
    Retrieves paginated report details from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function retrieves paginated report details from a specified workspace using either the provided PaginatedReportId or PaginatedReportName.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the paginated reports exist. This parameter is mandatory.

.PARAMETER PaginatedReportId
    The unique identifier of the paginated report to retrieve. This parameter is optional.

.PARAMETER PaginatedReportName
    The name of the paginated report to retrieve. This parameter is optional.

.EXAMPLE
    This example retrieves the paginated report details for the report with ID "report-67890" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricPaginatedReports -WorkspaceId "workspace-12345" -PaginatedReportId "report-67890"
    ```

.EXAMPLE
    This example retrieves the paginated report details for the report named "My Paginated Report" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricPaginatedReports -WorkspaceId "workspace-12345" -PaginatedReportName "My Paginated Report"
    ```

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
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
        [guid]$PaginatedReportId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$PaginatedReportName
    )

    try {
        # Handle ambiguous input
        if ($PaginatedReportId -and $PaginatedReportName) {
            Write-Message -Message "Both 'PaginatedReportId' and 'PaginatedReportName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        $apiEndpointUrl = "{0}/workspaces/{1}/paginatedReports" -f $FabricConfig.BaseUrl, $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            TypeName       = 'Paginated Report'
            HandleResponse = $true
            ExtractValue   = 'True'
        }
        $PaginatedReports = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $PaginatedReport = if ($PaginatedReportId) {
            $PaginatedReports | Where-Object { $_.Id -eq $PaginatedReportId }
        } elseif ($PaginatedReportName) {
            $PaginatedReports | Where-Object { $_.DisplayName -eq $PaginatedReportName }
        } else {
            Write-Message -Message "No filter provided. Returning all Paginated Reports." -Level Debug
            $PaginatedReports
        }

        # Handle results
        if ($PaginatedReport) {
            Write-Message -Message "Paginated Report found matching the specified criteria." -Level Debug
            return $PaginatedReport
        } else {
            Write-Message -Message "No Paginated Report found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Paginated Report. Error: $errorDetails" -Level Error
    }
}
