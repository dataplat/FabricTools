<#
.SYNOPSIS
    Removes a DataPipeline from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a DELETE request to the Microsoft Fabric API to remove a DataPipeline
    from the specified workspace using the provided WorkspaceId and DataPipelineId.

.PARAMETER WorkspaceId
    The unique identifier of the workspace from which the DataPipeline will be removed.

.PARAMETER DataPipelineId
    The unique identifier of the DataPipeline to be removed.

.EXAMPLE
     Remove-FabricDataPipeline -WorkspaceId "workspace-12345" -DataPipelineId "pipeline-67890"
    This example removes the DataPipeline with ID "pipeline-67890" from the workspace with ID "workspace-12345".

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Test-TokenExpired` to ensure token validity before making the API request.

    Author: Tiago Balabuch
#>

function Remove-FabricDataPipeline {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DataPipelineId
    )
    try {
        # Ensure token validity
        Write-Message -Message "Validating token..." -Level Debug
        Test-TokenExpired
        Write-Message -Message "Token validation completed." -Level Debug

        #  Construct the API URI
        $apiEndpointURI = "{0}/workspaces/{1}/dataPipelines/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $DataPipelineId
        Write-Message -Message "API Endpoint: $apiEndpointURI" -Level Debug

        # Make the API request
        $response = Invoke-FabricAPIRequest `
            -Headers $FabricConfig.FabricHeaders `
            -BaseURI $apiEndpointURI `
            -Method Delete
        Write-Message -Message "DataPipeline '$DataPipelineId' deleted successfully from workspace '$WorkspaceId'." -Level Info
        return $response
    } catch {
        # Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete DataPipeline '$DataPipelineId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}