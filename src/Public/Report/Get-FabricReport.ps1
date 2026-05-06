function Get-FabricReport {
<#
.SYNOPSIS
    Retrieves Report details from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function retrieves Report details from a specified workspace using either the provided ReportId or ReportName.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Report exists. This parameter is mandatory.

.PARAMETER ReportId
    The unique identifier of the Report to retrieve. This parameter is optional.

.PARAMETER ReportName
    The name of the Report to retrieve. This parameter is optional.

.EXAMPLE
    This example retrieves the Report details for the Report with ID "Report-67890" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricReport -WorkspaceId "workspace-12345" -ReportId "Report-67890"
    ```

.EXAMPLE
    This example retrieves the Report details for the Report named "My Report" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricReport -WorkspaceId "workspace-12345" -ReportName "My Report"
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
        [string]$ReportName
    )
    try {

        # Handle ambiguous input
        if ($ReportId -and $ReportName) {
            Write-Message -Message "Both 'ReportId' and 'ReportName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/reports"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Invoke the Fabric API to retrieve Reports
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            ExtractValue   = 'True'
            HandleResponse = $true
        }
        $Reports = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $Report = if ($ReportId) {
            $Reports | Where-Object { $_.Id -eq $ReportId }
        } elseif ($ReportName) {
            $Reports | Where-Object { $_.DisplayName -eq $ReportName }
        } else {
            # Return all Reports if no filter is provided
            Write-Message -Message "No filter provided. Returning all Reports." -Level Debug
            $Reports
        }

        # Handle results
        if ($Report) {
            Write-Message -Message "Report found in the Workspace '$WorkspaceId'." -Level Debug
            return $Report
        } else {
            Write-Message -Message "No Report found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Report. Error: $errorDetails" -Level Error
    }

}
