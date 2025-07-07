<#
.SYNOPSIS
Retrieves the supported items from the workspace assigned to a specific stage of a deployment pipeline.

.DESCRIPTION
The `Get-FabricDeploymentPipelineStageItem` function returns a list of supported items from the workspace
assigned to the specified stage of a deployment pipeline. The function automatically handles pagination
and returns all available items.

.PARAMETER DeploymentPipelineId
Required. The ID of the deployment pipeline.

.PARAMETER StageId
Required. The ID of the stage to retrieve items from.

.EXAMPLE
Get-FabricDeploymentPipelineStageItem -DeploymentPipelineId "GUID-GUID-GUID-GUID" -StageId "GUID-GUID-GUID-GUID"

Retrieves all items from the specified stage of the deployment pipeline.

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Requires Pipeline.Read.All or Pipeline.ReadWrite.All delegated scope.
- Requires admin deployment pipelines role.
- The user must be at least a workspace contributor assigned to the specified stage.
- Returns items with their metadata including:
  - Item ID and display name
  - Item type (Report, Dashboard, SemanticModel, etc.)
  - Source and target item IDs (if applicable)
  - Last deployment time (if applicable)

Author: Kamil Nowinski
#>

function Get-FabricDeploymentPipelineStageItem {
    [CmdletBinding()]
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

        # Step 2: Initialize variables for pagination
        $continuationToken = $null
        $allItems = @()

        do {
            # Step 3: Construct the API URL
            $apiEndpointUrl = "deploymentPipelines/$DeploymentPipelineId/stages/$StageId/items"
            if ($continuationToken) {
                # URL-encode the continuation token
                $encodedToken = [System.Web.HttpUtility]::UrlEncode($continuationToken)
                $apiEndpointUrl = "{0}?continuationToken={1}" -f $apiEndpointUrl, $encodedToken
            }
            Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

            # Step 4: Make the API request
            $response = Invoke-FabricRestMethod -Uri $apiEndpointUrl -Method Get

            # Step 5: Validate response
            Test-FabricApiResponse -response $response -ObjectIdOrName $StageId -typeName "deployment pipeline stage items"

            # Step 6: Process results
            if ($response.value) {
                $allItems += $response.value
                Write-Message -Message "Retrieved $($response.value.Count) items." -Level Debug
            }
            $continuationToken = Get-FabricContinuationToken -Response $response
        } while ($continuationToken)

        # Step 7: Return all items
        $allItems
        # if ($allItems.Count -gt 0) {
        #     Write-Message -Message "Successfully retrieved $($allItems.Count) items in total." -Level Debug
        #     return $allItems
        # } else {
        #     Write-Message -Message "No items found in the deployment pipeline stage." -Level Warning
        #     return $null
        # }
    } catch {
        # Step 8: Error handling
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve deployment pipeline stage items. Error: $errorDetails" -Level Error
        return $null
    }
}
