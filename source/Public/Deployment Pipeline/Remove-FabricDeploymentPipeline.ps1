<#
.SYNOPSIS
Deletes a specified deployment pipeline.

.DESCRIPTION
The `Remove-FabricDeploymentPipeline` function deletes a deployment pipeline by its ID.
This operation requires admin deployment pipelines role and will fail if there's an active deployment operation.

.PARAMETER DeploymentPipelineId
Required. The ID of the deployment pipeline to delete.

.EXAMPLE
Remove-FabricDeploymentPipeline -DeploymentPipelineId "GUID-GUID-GUID-GUID"

Deletes the specified deployment pipeline.

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Requires Pipeline.ReadWrite.All delegated scope.
- Requires admin deployment pipelines role.
- Operation will fail if there's an active deployment operation.

Author: Kamil Nowinski
#>

function Remove-FabricDeploymentPipeline {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]$DeploymentPipelineId
    )

    try {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "deploymentPipelines/$DeploymentPipelineId"
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Make the API request & validate response
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Delete Deployment Pipeline"))
        {
            $apiParameters = @{
                Uri = $apiEndpointUrl
                Method = 'DELETE'
                HandleResponse = $true
                TypeName = "deployment pipeline"
                ObjectIdOrName = $DeploymentPipelineId
            }
            $response = Invoke-FabricRestMethod @apiParameters
        }

        # Step 4: Handle results
        $response

    } catch {
        # Step 5: Error handling
        $errorDetails = $_.Exception.Message
        Write-Error -Message "Failed to delete deployment pipeline. Error: $errorDetails"
    }
}
