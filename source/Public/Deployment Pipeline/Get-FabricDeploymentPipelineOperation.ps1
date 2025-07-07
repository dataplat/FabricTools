<#
.SYNOPSIS
Retrieves details of a specific deployment pipeline operation.

.DESCRIPTION
The `Get-FabricDeploymentPipelineOperation` function fetches detailed information about a specific deployment operation
performed on a deployment pipeline, including the deployment execution plan, status, and timing information.

.PARAMETER DeploymentPipelineId
Required. The ID of the deployment pipeline.

.PARAMETER OperationId
Required. The ID of the operation to retrieve.

.EXAMPLE
Get-FabricDeploymentPipelineOperation -DeploymentPipelineId "GUID-GUID-GUID-GUID" -OperationId "GUID-GUID-GUID-GUID"

Retrieves details of a specific deployment operation, including its execution plan and status.

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Returns detailed operation information including:
  - Operation status and type
  - Execution timing
  - Source and target stage information
  - Deployment execution plan with steps
  - Pre-deployment diff information
  - Performed by information
- Requires Pipeline.Read.All or Pipeline.ReadWrite.All delegated scopes.

Author: Kamil Nowinski
#>

function Get-FabricDeploymentPipelineOperation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]$DeploymentPipelineId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]$OperationId
    )

    try {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "deploymentPipelines/$DeploymentPipelineId/operations/$OperationId"
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Make the API request
        $response = Invoke-FabricRestMethod -Uri $apiEndpointUrl -Method Get

        # Step 4: Validate response
        Test-FabricApiResponse -response $response -ObjectIdOrName $DeploymentPipelineId -typeName "deployment pipeline operation"

        # Step 5: Handle results
        $response
        # if ($response) {
        #     Write-Message -Message "Successfully retrieved deployment pipeline operation details." -Level Debug
        #     return $response
        # } else {
        #     Write-Message -Message "No deployment pipeline operation found with the specified IDs." -Level Warning
        #     return $null
        # }
    } catch {
        # Step 6: Error handling
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve deployment pipeline operation. Error: $errorDetails" -Level Error
    }
}
