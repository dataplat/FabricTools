
function Start-FabricDeploymentPipelineStage {
<#
.SYNOPSIS
Deploys items from one stage to another in a deployment pipeline.

.DESCRIPTION
The `Start-FabricDeploymentPipelineStage` function deploys items from the specified source stage to the target stage.
This API supports long running operations (LRO) and will return an operation ID that can be used to track the deployment status.

.PARAMETER DeploymentPipelineId
Required. The ID of the deployment pipeline.

.PARAMETER SourceStageId
Required. The ID of the source stage to deploy from.

.PARAMETER TargetStageId
Required. The ID of the target stage to deploy to.

.PARAMETER Items
Optional. A list of items to be deployed. If not specified, all supported stage items are deployed.
Each item should be a hashtable with:
- sourceItemId: The ID of the item to deploy
- itemType: The type of the item (e.g., "Report", "Dashboard", "Datamart", "SemanticModel")

.PARAMETER Note
Optional. A note describing the deployment. Limited to 1024 characters.

.PARAMETER NoWait
Optional. If specified, the function will not wait for the deployment to complete and will return immediately.

.EXAMPLE
    This example deploys items from the source stage to the target stage in the specified deployment pipeline.

    ```powershell
    Start-FabricDeploymentPipelineStage -DeploymentPipelineId "12345678-1234-1234-1234-1234567890AB" -SourceStageId "23456789-2345-2345-2345-2345678901BC" -TargetStageId "34567890-3456-3456-3456-3456789012CD" -Items @(@{sourceItemId="45678901-4567-4567-4567-4567890123EF"; itemType="Report"})
    ```

.EXAMPLE
    This example deploys all items from the source stage to the target stage in the specified deployment pipeline without waiting for completion.

    ```powershell
    Start-FabricDeploymentPipelineStage -DeploymentPipelineId "12345678-1234-1234-1234-1234567890AB" -SourceStageId "23456789-2345-2345-2345-2345678901BC" -TargetStageId "34567890-3456-3456-3456-3456789012CD" -NoWait
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Requires Pipeline.Deploy delegated scope.
- Requires admin deployment pipelines role.
- Requires contributor or higher role on both source and target workspaces.
- Maximum 300 deployed items per request.
- This API is in preview.

Author: Kamil Nowinski
#>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]$DeploymentPipelineId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]$SourceStageId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]$TargetStageId,

        [Parameter(Mandatory = $false)]
        [Array]$Items,

        [Parameter(Mandatory = $false)]
        [ValidateLength(0, 1024)]
        [String]$Note,

        [Parameter(Mandatory = $false)]
        [Switch]$NoWait
    )

    try {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "deploymentPipelines/$DeploymentPipelineId/deploy"
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
        $requestBody = @{
            sourceStageId = $SourceStageId
            targetStageId = $TargetStageId
        }

        if ($Items) {
            $requestBody.items = $Items
        }

        if ($Note) {
            $requestBody.note = $Note
        }

        # Step 4: Make the API request and validate response
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Start Deployment Pipeline")) {
            $response = Invoke-FabricRestMethod -Uri $apiEndpointUrl -Method Post -Body $requestBody
            #Write-Message -Message "Successfully initiated deployment. Operation ID: $($script:responseHeader['x-ms-operation-id'])" -Level Info
            $response = Test-FabricApiResponse -Response $response -typeName 'Deploy Pipeline Stage' -ObjectIdOrName $DeploymentPipelineId -NoWait:$NoWait
        }

        # Step 5: Return results
        $response

    } catch {
        # Step 6: Error handling
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to initiate deployment. Error: $errorDetails" -Level Error
    }
}
