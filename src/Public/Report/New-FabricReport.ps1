function New-FabricReport
{
<#
.SYNOPSIS
    Creates a new Report in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a POST request to the Microsoft Fabric API to create a new Report
    in the specified workspace. It supports optional parameters for Report description and path definitions.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Report will be created. This parameter is mandatory.

.PARAMETER ReportName
    The name of the Report to be created. This parameter is mandatory.

.PARAMETER ReportDescription
    An optional description for the Report.

.PARAMETER ReportPathDefinition
    An optional path to the folder that contains Report definition files to upload.


.EXAMPLE
    This example creates a new Report named "New Report" in the workspace with ID "workspace-12345" with the provided description.

    ```powershell
    New-FabricReport -WorkspaceId "workspace-12345" -ReportName "New Report" -ReportDescription "Description of the new Report"
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
        [string]$ReportName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ReportDescription,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ReportPathDefinition
    )
    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/reports"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $ReportName
        }

        if ($ReportDescription)
        {
            $body.description = $ReportDescription
        }
        if ($ReportPathDefinition)
        {
            if (-not $body.definition)
            {
                $body.definition = @{
                    parts = @()
                }
            }
            $jsonObjectParts = Get-FileDefinitionParts -sourceDirectory $ReportPathDefinition
            # Add new part to the parts array
            $body.definition.parts = $jsonObjectParts.parts
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($ReportName, "Create Report")){
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Report '$ReportName' created successfully!" -Level Info
            return $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create Report. Error: $errorDetails" -Level Error
    }
}
