function Update-FabricReportDefinition
{
<#
.SYNOPSIS
    Updates the definition of an existing Report in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a PATCH request to the Microsoft Fabric API to update the definition of an existing Report
    in the specified workspace. It supports optional parameters for Report definition and platform-specific definition.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Report exists. This parameter is mandatory.

.PARAMETER ReportId
    The unique identifier of the Report to be updated. This parameter is mandatory.

.PARAMETER ReportPathDefinition
    A mandatory path to the Report definition file to upload.

.EXAMPLE
    This example updates the definition of the Report with ID "Report-67890" in the workspace with ID "workspace-12345" using the provided definition file.

    ```powershell
    Update-FabricReportDefinition -WorkspaceId "workspace-12345" -ReportId "Report-67890" -ReportPathDefinition "C:\Path\To\ReportDefinition.json"
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
        [string]$ReportPathDefinition
    )
    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/reports/$ReportId/updateDefinition"

        # Construct the request body
        $body = @{
            definition = @{
                parts = @()
            }
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
        # Check if any path is .platform
        foreach ($part in $jsonObjectParts.parts)
        {
            if ($part.path -eq ".platform")
            {
                $hasPlatformFile = $true
                Write-Message -Message "Platform File: $hasPlatformFile" -Level Debug
            }
        }

        if ($hasPlatformFile -eq $true)
        {
            $apiEndpointUrl = "$apiEndpointUrl?updateMetadata=true"
        }
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Update Report Definition"))
        {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Update definition for Report '$ReportId' created successfully!" -Level Info
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
