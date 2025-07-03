<#
.SYNOPSIS
Unassigns a workspace from a deployment pipeline stage.

.DESCRIPTION
The `Unassign-FabricWorkspaceFromStage` function unassigns the workspace from the specified stage in the specified deployment pipeline.
This operation will fail if there's an active deployment operation.

.PARAMETER DeploymentPipelineId
Required. The ID of the deployment pipeline.

.PARAMETER StageId
Required. The ID of the deployment pipeline stage.

.EXAMPLE
Unassign-FabricWorkspaceFromStage -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824" -StageId "db1577e0-0132-4d6d-92b9-952c359988f2"

Unassigns the workspace from the specified deployment pipeline stage.

.NOTES
- Requires `$FabricConfig` global configuration, including `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Requires Pipeline.ReadWrite.All delegated scope.
- Requires admin deployment pipelines role.
- This operation will fail if there's an active deployment operation.
- This API is in preview.

Author: Kamil Nowinski
#>

function Unassign-FabricWorkspaceFromStage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Guid]$DeploymentPipelineId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Guid]$StageId
    )

    try {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "deploymentPipelines/$DeploymentPipelineId/stages/$StageId/unassignWorkspace"
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Make the API request and validate response
        $response = Invoke-FabricRestMethod -Uri $apiEndpointUrl -Method Post
        Test-FabricApiResponse -Response $response

        # Step 4: Return results
        Write-Message -Message "Successfully unassigned workspace from deployment pipeline stage." -Level Info
        return $response
    } catch {
        # Step 5: Error handling
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to unassign workspace from deployment pipeline stage. Error: $errorDetails" -Level Error
        return $null
    }
}
