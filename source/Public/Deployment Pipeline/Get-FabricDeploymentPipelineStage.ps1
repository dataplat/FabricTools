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
    Retrieves details of a specific deployment pipeline stage, including its workspace assignment and settings.

    ```powershell
    Get-FabricDeploymentPipelineStage -DeploymentPipelineId "GUID-GUID-GUID-GUID" -StageId "GUID-GUID-GUID-GUID"
    ```

.EXAMPLE
    Retrieves a list of all stages in the specified deployment pipeline.

    ```powershell
    Get-FabricDeploymentPipelineStage -DeploymentPipelineId "GUID-GUID-GUID-GUID"
    ```

.NOTES
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
        $response = Invoke-FabricRestMethod -Uri $apiEndpointUrl -Method Get

        # Step 4: Validate response
        Test-FabricApiResponse -response $response -ObjectIdOrName $DeploymentPipelineId -typeName "deployment pipeline stage"

        # Step 5: Handle results
        $response

    } catch {
        # Step 6: Error handling
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve deployment pipeline stage(s). Error: $errorDetails" -Level Error
    }
}
