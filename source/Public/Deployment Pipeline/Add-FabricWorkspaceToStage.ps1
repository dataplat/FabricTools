<#
.SYNOPSIS
Assigns a workspace to a deployment pipeline stage.

.DESCRIPTION
The `Add-FabricWorkspaceToStage` function assigns the specified workspace to the specified deployment pipeline stage.
This operation will fail if there's an active deployment operation.

.PARAMETER DeploymentPipelineId
Required. The ID of the deployment pipeline.

.PARAMETER StageId
Required. The ID of the deployment pipeline stage.

.PARAMETER WorkspaceId
Required. The ID of the workspace to assign to the stage.

.EXAMPLE
Add-FabricWorkspaceToStage -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824" -StageId "db1577e0-0132-4d6d-92b9-952c359988f2" -WorkspaceId "4de5bcc4-2c88-4efe-b827-4ee7b289b496"

Assigns the specified workspace to the deployment pipeline stage.

.NOTES
- Requires `$FabricConfig` global configuration, including `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Requires Pipeline.ReadWrite.All and Workspace.ReadWrite.All delegated scopes.
- Requires admin deployment pipelines role and admin workspace role.
- This operation will fail if:
  * There's an active deployment operation
  * The specified stage is already assigned to another workspace
  * The specified workspace is already assigned to another stage
  * The caller is not a workspace admin
- This API is in preview.

Author: Kamil Nowinski
#>

function Add-FabricWorkspaceToStage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]$DeploymentPipelineId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]$StageId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]$WorkspaceId
    )

    try {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "deploymentPipelines/$DeploymentPipelineId/stages/$StageId/assignWorkspace"
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
        $requestBody = @{
            workspaceId = $WorkspaceId
        }

        # Step 4: Make the API request and validate response
        $response = Invoke-FabricRestMethod -Uri $apiEndpointUrl -Method Post -Body $requestBody
        Test-FabricApiResponse -Response $response

        # Step 5: Return results
        Write-Message -Message "Successfully assigned workspace to deployment pipeline stage." -Level Info
        return $response
    } catch {
        # Step 6: Error handling
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to assign workspace to deployment pipeline stage. Error: $errorDetails" -Level Error
        return $null
    }
}
