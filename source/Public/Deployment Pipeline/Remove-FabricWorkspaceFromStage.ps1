function Remove-FabricWorkspaceFromStage {
<#
.SYNOPSIS
Removes a workspace from a deployment pipeline stage.

.DESCRIPTION
The `Remove-FabricWorkspaceFromStage` function removes the workspace from the specified stage in the specified deployment pipeline.
This operation will fail if there's an active deployment operation.

.PARAMETER DeploymentPipelineId
Required. The ID of the deployment pipeline.

.PARAMETER StageId
Required. The ID of the deployment pipeline stage.

.EXAMPLE
    Removes the workspace from the specified deployment pipeline stage.

    ```powershell
    Remove-FabricWorkspaceFromStage -DeploymentPipelineId "GUID-GUID-GUID-GUID" -StageId "GUID-GUID-GUID-GUID"
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Requires Pipeline.ReadWrite.All delegated scope.
- Requires admin deployment pipelines role.
- This operation will fail if there's an active deployment operation.
- This API is in preview.

Author: Kamil Nowinski
#>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]$DeploymentPipelineId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]$StageId
    )

    try {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "deploymentPipelines/$DeploymentPipelineId/stages/$StageId/unassignWorkspace"
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Make the API request and validate response
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Remove Workspace from Deployment Pipeline Stage")) {
            $response = Invoke-FabricRestMethod -Uri $apiEndpointUrl -Method Post
            $response = Test-FabricApiResponse -Response $response
        }

        # Step 4: Return results
        Write-Message -Message "Successfully unassigned workspace from deployment pipeline stage." -Level Info
        $response

    } catch {
        # Step 5: Error handling
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to unassign workspace from deployment pipeline stage. Error: $errorDetails" -Level Error
    }
}
