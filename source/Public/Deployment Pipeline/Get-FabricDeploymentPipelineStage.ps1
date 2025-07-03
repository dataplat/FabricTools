<#
.SYNOPSIS
Retrieves details of deployment pipeline stages.

.DESCRIPTION
The `Get-FabricDeploymentPipelineStage` function fetches information about stages in a deployment pipeline.
When a StageId is provided, it returns details for that specific stage. When no StageId is provided,
it returns a list of all stages in the pipeline.

.PARAMETER DeploymentPipelineId
Required. The ID of the deployment pipeline.

.PARAMETER StageId
Optional. The ID of the specific stage to retrieve. If not provided, returns all stages in the pipeline.

.EXAMPLE
Get-FabricDeploymentPipelineStage -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824" -StageId "2e6f0272-e809-410a-be63-50e1d97ba75a"

Retrieves details of a specific deployment pipeline stage, including its workspace assignment and settings.

.EXAMPLE
Get-FabricDeploymentPipelineStage -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824"

Retrieves a list of all stages in the specified deployment pipeline.

.NOTES
- Requires `$FabricConfig` global configuration, including `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Returns detailed stage information including:
  - Stage ID and display name
  - Description
  - Order in the pipeline
  - Workspace assignment (if any)
  - Public/private visibility setting
- Requires Pipeline.Read.All or Pipeline.ReadWrite.All delegated scopes.

Author: Kamil Nowinski
#>

function Get-FabricDeploymentPipelineStage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]$DeploymentPipelineId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$StageId
    )

    try {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        if ($StageId) {
            $apiEndpointUrl = "deploymentPipelines/$DeploymentPipelineId/stages/$StageId"
        } else {
            $apiEndpointUrl = "deploymentPipelines/$DeploymentPipelineId/stages"
        }
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Make the API request
        $response = Invoke-FabricRestMethod `
            -Uri $apiEndpointUrl `
            -Method Get

        # Step 4: Validate response
        Test-FabricApiResponse -response $response -ObjectIdOrName $DeploymentPipelineId -typeName "deployment pipeline stage"

        # Step 5: Handle results
        if ($response) {
            Write-Message -Message "Successfully retrieved deployment pipeline stage details." -Level Debug
            return $response
        } else {
            Write-Message -Message "No deployment pipeline stages found." -Level Warning
            return $null
        }
    } catch {
        # Step 6: Error handling
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve deployment pipeline stage(s). Error: $errorDetails" -Level Error
        return $null
    }
}
