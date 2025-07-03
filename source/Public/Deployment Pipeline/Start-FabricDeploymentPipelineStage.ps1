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
Start-FabricDeploymentPipelineStage -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824" -SourceStageId "db1577e0-0132-4d6d-92b9-952c359988f2" -TargetStageId "f1c39546-6282-4590-8af3-847a6226ad16" -Note "Deploying business ready items"

Deploys all supported items from the source stage to the target stage.

.EXAMPLE
$items = @(
    @{
        sourceItemId = "6bfe235c-6d7b-41b7-98a6-2b8276b3e82b"
        itemType = "Datamart"
    },
    @{
        sourceItemId = "1a201f2a-d1d8-45c0-8c61-1676338517de"
        itemType = "SemanticModel"
    }
)
Start-FabricDeploymentPipelineStage -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824" -SourceStageId "db1577e0-0132-4d6d-92b9-952c359988f2" -TargetStageId "f1c39546-6282-4590-8af3-847a6226ad16" -Items $items -Note "Deploying specific items"

Deploys specific items from the source stage to the target stage.

.NOTES
- Requires `$FabricConfig` global configuration, including `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Requires Pipeline.Deploy delegated scope.
- Requires admin deployment pipelines role.
- Requires contributor or higher role on both source and target workspaces.
- Maximum 300 deployed items per request.
- This API is in preview.

Author: Kamil Nowinski
#>

function Start-FabricDeploymentPipelineStage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Guid]$DeploymentPipelineId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Guid]$SourceStageId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Guid]$TargetStageId,

        [Parameter(Mandatory = $false)]
        [array]$Items,

        [Parameter(Mandatory = $false)]
        [ValidateLength(0, 1024)]
        [string]$Note,

        [Parameter(Mandatory = $false)]
        [switch]$NoWait
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
        $response = Invoke-FabricRestMethod -Uri $apiEndpointUrl -Method Post -Body $requestBody
        #Write-Message -Message "Successfully initiated deployment. Operation ID: $($script:responseHeader['x-ms-operation-id'])" -Level Info
        Test-FabricApiResponse -Response $response -typeName 'Deploy Pipeline Stage' -ObjectIdOrName $DeploymentPipelineId -NoWait:$NoWait

        # Step 5: Return results
        return $response

    } catch {
        # Step 6: Error handling
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to initiate deployment. Error: $errorDetails" -Level Error
        return $null
    }
}
