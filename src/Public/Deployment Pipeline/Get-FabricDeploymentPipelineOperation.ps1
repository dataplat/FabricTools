function Get-FabricDeploymentPipelineOperation {
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
    Retrieves details of a specific deployment operation, including its execution plan and status.

    ```powershell
    Get-FabricDeploymentPipelineOperation -DeploymentPipelineId "GUID-GUID-GUID-GUID" -OperationId "GUID-GUID-GUID-GUID"
    ```

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
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "deploymentPipelines/$DeploymentPipelineId/operations/$OperationId"

        # Make the API request
        $apiParameters = @{
            Uri = $apiEndpointUrl
            Method = 'GET'
            HandleResponse = $true
            TypeName = "deployment pipeline operation"
            ObjectIdOrName = $DeploymentPipelineId
        }
        $response = Invoke-FabricRestMethod @apiParameters

        $response

    } catch {
        # Error handling
        $errorDetails = $_.Exception.Message
        Write-Error -Message "Failed to retrieve deployment pipeline operation. Error: $errorDetails"
    }
}
