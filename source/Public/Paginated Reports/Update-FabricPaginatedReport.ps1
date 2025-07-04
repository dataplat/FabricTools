<#
.SYNOPSIS
    Updates an existing paginated report in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a PATCH request to the Microsoft Fabric API to update an existing paginated report
    in the specified workspace. It supports optional parameters for paginated report description.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the paginated report exists. This parameter is optional.

.PARAMETER PaginatedReportId
    The unique identifier of the paginated report to be updated. This parameter is mandatory.

.PARAMETER PaginatedReportName
    The new name of the paginated report. This parameter is mandatory.

.PARAMETER PaginatedReportDescription
    An optional new description for the paginated report.

.EXAMPLE
    Update-FabricPaginatedReport -WorkspaceId "workspace-12345" -PaginatedReportId "report-67890" -PaginatedReportName "Updated Paginated Report" -PaginatedReportDescription "Updated description"
    This example updates the paginated report with ID "report-67890" in the workspace with ID "workspace-12345" with a new name and description.

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch

#>
function Update-FabricPaginatedReport
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$PaginatedReportId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$PaginatedReportName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$PaginatedReportDescription
    )

    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/paginatedReports/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $PaginatedReportId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            displayName = $PaginatedReportName
        }

        if ($PaginatedReportDescription)
        {
            $body.description = $PaginatedReportDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($PaginatedReportName, "Update Paginated Report"))
        {

            # Step 4: Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Patch `
                -Body $bodyJson
        }
        # Step 5: Validate the response code
        if ($statusCode -ne 200)
        {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        # Step 6: Handle results
        Write-Message -Message "Paginated Report '$PaginatedReportName' updated successfully!" -Level Info
        return $response
    }
    catch
    {
        # Step 7: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update Paginated Report. Error: $errorDetails" -Level Error
    }
}
