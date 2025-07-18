<#
.SYNOPSIS
Retrieves deployment pipeline(s) from Microsoft Fabric.

.DESCRIPTION
The `Get-FabricDeploymentPipeline` function fetches deployment pipeline(s) from the Fabric API.
It can either retrieve all pipelines or a specific pipeline by ID.
It automatically handles pagination when retrieving all pipelines.

.PARAMETER DeploymentPipelineId
Optional. The ID of a specific deployment pipeline to retrieve. If not provided, all pipelines will be retrieved.

.PARAMETER DeploymentPipelineName
Optional. The display name of a specific deployment pipeline to retrieve. If provided, it will filter the results to match this name.

.EXAMPLE
Get-FabricDeploymentPipeline

Retrieves all deployment pipelines that the user can access.

.EXAMPLE
Get-FabricDeploymentPipeline -DeploymentPipelineId "GUID-GUID-GUID-GUID"

Retrieves a specific deployment pipeline with detailed information including its stages.

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Returns a collection of deployment pipelines with their IDs, display names, and descriptions.
- When retrieving a specific pipeline, returns extended information including stages.
- Requires Pipeline.Read.All or Pipeline.ReadWrite.All delegated scopes.

Author: Kamil Nowinski
#>

function Get-FabricDeploymentPipeline {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Guid]$DeploymentPipelineId,

        [Parameter(Mandatory = $false)]
        [Alias("Name", "DisplayName")]
        [string]$DeploymentPipelineName
    )

    try {
        # Step 1: Ensure token validity
        Confirm-TokenState

        if ($PSBoundParameters.ContainsKey("DeploymentPipelineName") -and $PSBoundParameters.ContainsKey("DeploymentPipelineId"))
        {
            Write-Warning "The parameters DeploymentPipelineName and DeploymentPipelineId cannot be used together"
            return
        }

        # If DeploymentPipelineId is provided, get specific pipeline
        if ($DeploymentPipelineId) {
            Write-Message -Message "Retrieving specific deployment pipeline with ID: $DeploymentPipelineId" -Level Debug
            $apiEndpointUrl = "deploymentPipelines/$DeploymentPipelineId"
        } else {
            $apiEndpointUrl = "deploymentPipelines"
        }

        # Step 5: Make the API request
        $apiParameters = @{
            Uri = $apiEndpointUrl
            Method = 'GET'
            HandleResponse = $true
            TypeName = "deployment pipeline"
        }
        $response = Invoke-FabricRestMethod @apiParameters

        if ($DeploymentPipelineName)
        {
            # Filter the list by name
            Write-Message -Message "Filtering deployment pipelines by name: $DeploymentPipelineName" -Level Debug
            $response = $response | Where-Object { $_.displayName -eq $DeploymentPipelineName }
        }

        # Step 7: Handle results
        $response

    } catch {
        # Step 8: Error handling
        $errorDetails = $_.Exception.Message
        Write-Error -Message "Failed to retrieve deployment pipelines. Error: $errorDetails"
    }
}
