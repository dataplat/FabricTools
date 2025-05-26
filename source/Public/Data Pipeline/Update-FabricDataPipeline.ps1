<#
.SYNOPSIS
    Updates an existing DataPipeline in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a PATCH request to the Microsoft Fabric API to update an existing DataPipeline
    in the specified workspace. It supports optional parameters for DataPipeline description.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the DataPipeline exists. This parameter is optional.

.PARAMETER DataPipelineId
    The unique identifier of the DataPipeline to be updated. This parameter is mandatory.

.PARAMETER DataPipelineName
    The new name of the DataPipeline. This parameter is mandatory.

.PARAMETER DataPipelineDescription
    An optional new description for the DataPipeline.

.EXAMPLE
     Update-FabricDataPipeline -WorkspaceId "workspace-12345" -DataPipelineId "pipeline-67890" -DataPipelineName "Updated DataPipeline" -DataPipelineDescription "Updated description"
    This example updates the DataPipeline with ID "pipeline-67890" in the workspace with ID "workspace-12345" with a new name and description.

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Test-TokenExpired` to ensure token validity before making the API request.

    Author: Tiago Balabuch
#>
function Update-FabricDataPipeline
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DataPipelineId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DataPipelineName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$DataPipelineDescription
    )

    try
    {
        # Ensure token validity
        Write-Message -Message "Validating token..." -Level Debug
        Test-TokenExpired
        Write-Message -Message "Token validation completed." -Level Debug

        # Construct the API URL
        $apiEndpointURI = "{0}/workspaces/{1}/dataPipelines/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $DataPipelineId
        Write-Message -Message "API Endpoint: $apiEndpointURI" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $DataPipelineName
        }

        if ($DataPipelineDescription)
        {
            $body.description = $DataPipelineDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointURI, "Update DataPipeline"))
        {

            # Make the API request
            $response = Invoke-FabricAPIRequest `
                -Headers $FabricConfig.FabricHeaders `
                -BaseURI $apiEndpointURI `
                -method Patch `
                -body $bodyJson
        }

        Write-Message -Message "DataPipeline '$DataPipelineName' updated successfully!" -Level Info
        return $response
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update DataPipeline. Error: $errorDetails" -Level Error
    }
}
