<#
.SYNOPSIS
Deletes a specified deployment pipeline.

.DESCRIPTION
The `Remove-FabricDeploymentPipeline` function deletes a deployment pipeline by its ID.
This operation requires admin deployment pipelines role and will fail if there's an active deployment operation.

.PARAMETER DeploymentPipelineId
Required. The ID of the deployment pipeline to delete.

.EXAMPLE
Remove-FabricDeploymentPipeline -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824"

Deletes the specified deployment pipeline.

.NOTES
- Requires `$FabricConfig` global configuration, including `FabricHeaders`.
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
        [string]$DeploymentPipelineId
    )

    try {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "deploymentPipelines/$DeploymentPipelineId"
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Make the API request
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Delete deployment pipeline"))
        {
            $response = Invoke-FabricRestMethod -Uri $apiEndpointUrl -Method Delete
        }

        # Step 4: Validate response
        Test-FabricApiResponse -response $response -Name $DeploymentPipelineId -typeName "deployment pipeline"

        # Step 5: Handle results
        Write-Message -Message "Deployment pipeline $DeploymentPipelineId deleted successfully." -Level Info

    } catch {
        # Step 6: Error handling
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete deployment pipeline. Error: $errorDetails" -Level Error
    }
}
