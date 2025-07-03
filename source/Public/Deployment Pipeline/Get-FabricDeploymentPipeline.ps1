<#
.SYNOPSIS
Retrieves deployment pipeline(s) from Microsoft Fabric.

.DESCRIPTION
The `Get-FabricDeploymentPipeline` function fetches deployment pipeline(s) from the Fabric API.
It can either retrieve all pipelines or a specific pipeline by ID.
It automatically handles pagination when retrieving all pipelines.

.PARAMETER DeploymentPipelineId
Optional. The ID of a specific deployment pipeline to retrieve. If not provided, all pipelines will be retrieved.

.EXAMPLE
Get-FabricDeploymentPipeline

Retrieves all deployment pipelines that the user can access.

.EXAMPLE
Get-FabricDeploymentPipeline -DeploymentPipelineId "a5ded933-57b7-41f4-b072-ed4c1f9d5824"

Retrieves a specific deployment pipeline with detailed information including its stages.

.NOTES
- Requires `$FabricConfig` global configuration, including `FabricHeaders`.
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

            $response = Invoke-FabricRestMethod -Uri $apiEndpointUrl -Method Get

            # Validate response
            Test-FabricApiResponse -response $response -ObjectIdOrName $DeploymentPipelineId -typeName "deployment pipeline"

            if ($response) {
                Write-Message -Message "Successfully retrieved deployment pipeline." -Level Debug
                return $response
            } else {
                Write-Message -Message "No deployment pipeline found with the specified ID." -Level Warning
                return $null
            }
        }

        # Step 2: Initialize variables for listing all pipelines
        $continuationToken = $null
        $pipelines = @()

        if (-not ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetName().Name -eq "System.Web" })) {
            Add-Type -AssemblyName System.Web
        }

        # Step 3: Loop to retrieve all pipelines with continuation token
        Write-Message -Message "Loop started to get continuation token" -Level Debug
        $baseApiEndpointUrl = "deploymentPipelines"

        do {
            # Step 4: Construct the API URL
            $apiEndpointUrl = $baseApiEndpointUrl

            if ($null -ne $continuationToken) {
                # URL-encode the continuation token
                $encodedToken = [System.Web.HttpUtility]::UrlEncode($continuationToken)
                $apiEndpointUrl = "{0}?continuationToken={1}" -f $apiEndpointUrl, $encodedToken
            }
            Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

            # Step 5: Make the API request
            $response = Invoke-FabricRestMethod -Uri $apiEndpointUrl -Method Get

            # Validate response
            Test-FabricApiResponse -response $response -typeName "deployment pipeline"

            # Step 6: Process response and update continuation token
            if ($null -ne $response) {
                $pipelines += $response.value
            }
            $continuationToken = Get-FabricContinuationToken -Response $response

        } while ($null -ne $continuationToken)

        Write-Message -Message "Loop finished and all data added to the list" -Level Debug

        if ($DeploymentPipelineName)
        {
            # Filter the list by name
            Write-Message -Message "Filtering deployment pipelines by name: $DeploymentPipelineName" -Level Debug
            $pipelines = $pipelines | Where-Object { $_.displayName -eq $DeploymentPipelineName }
        }

        # Step 7: Handle results
        $pipelines
        # if ($pipelines) {
        #     Write-Message -Message "Successfully retrieved deployment pipelines." -Level Debug
        #     return $pipelines
        # } else {
        #     Write-Message -Message "No deployment pipelines found." -Level Warning
        #     return $null
        # }

    } catch {
        # Step 8: Error handling
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve deployment pipelines. Error: $errorDetails" -Level Error
        return $null
    }
}
