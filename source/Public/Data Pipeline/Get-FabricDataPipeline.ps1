function Get-FabricDataPipeline {
    <#
.SYNOPSIS
    Retrieves data pipelines from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function retrieves all data pipelines from a specified workspace using either the provided Data PipelineId or Data PipelineName.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Data Pipeline exists. This parameter is mandatory.

.PARAMETER DataPipelineId
    The unique identifier of the Data Pipeline to retrieve. This parameter is optional.

.PARAMETER DataPipelineName
    The name of the Data Pipeline to retrieve. This parameter is optional.

.EXAMPLE
    Get-FabricDataPipeline -WorkspaceId "workspace-12345" -Data PipelineId "Data Pipeline-67890"
    This example retrieves the Data Pipeline details for the Data Pipeline with ID "Data Pipeline-67890" in the workspace with ID "workspace-12345".

.EXAMPLE
    Get-FabricDataPipeline -WorkspaceId "workspace-12345" -Data PipelineName "My Data Pipeline"
    This example retrieves the Data Pipeline details for the Data Pipeline named "My Data Pipeline" in the workspace with ID "workspace-12345".

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$DataPipelineId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$DataPipelineName
    )

    try {
        # Step 1: Handle ambiguous input
        if ($DataPipelineId -and $DataPipelineName) {
            Write-Message -Message "Both 'DataPipelineId' and 'DataPipelineName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointURI = ("workspaces/{0}/dataPipelines" -f $WorkspaceId)

        # Invoke the Fabric API to retrieve data pipeline details
        $DataPipelines = (Invoke-FabricRestMethod -uri $apiEndpointURI -Method Get).Value

        # Filter results based on provided parameters
        $response = if ($DataPipelineId) {
            $DataPipelines | Where-Object { $_.Id -eq $DataPipelineId }
        } elseif ($DataPipelineName) {
            $DataPipelines | Where-Object { $_.DisplayName -eq $DataPipelineName }
        } else {
            # Return all DataPipelines if no filter is provided
            Write-Message -Message "No filter provided. Returning all DataPipelines." -Level Debug
            $DataPipelines
        }

        # Handle results
        if ($response) {
            Write-Message -Message "DataPipeline found matching the specified criteria." -Level Debug
            return $response
        } else {
            Write-Message -Message "No DataPipeline found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve DataPipeline. Error: $errorDetails" -Level Error
    }

}
