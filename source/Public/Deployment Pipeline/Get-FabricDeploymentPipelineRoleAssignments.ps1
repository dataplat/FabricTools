function Get-FabricDeploymentPipelineRoleAssignments {
<#
.SYNOPSIS
Returns a list of deployment pipeline role assignments.

.DESCRIPTION
The `Get-FabricDeploymentPipelineRoleAssignments` function retrieves a list of role assignments for a deployment pipeline.
The function automatically handles pagination and returns all available role assignments.

.PARAMETER DeploymentPipelineId
Required. The ID of the deployment pipeline to get role assignments for.

.EXAMPLE
    Returns all role assignments for the specified deployment pipeline.

    ```powershell
    Get-FabricDeploymentPipelineRoleAssignments -DeploymentPipelineId "GUID-GUID-GUID-GUID"
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Requires Pipeline.Read.All or Pipeline.ReadWrite.All delegated scope.
- Requires admin deployment pipelines role.
- This API is in preview.

Author: Kamil Nowinski
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Guid]$DeploymentPipelineId
    )

    try {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Initialize variables
        $continuationToken = $null
        $roleAssignments = @()

        do {
            # Step 3: Construct the API URL
            $apiEndpointUrl = "deploymentPipelines/$DeploymentPipelineId/roleAssignments"
            if ($continuationToken) {
                $apiEndpointUrl += "?continuationToken=$continuationToken"
            }
            Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

            # Step 4: Make the API request and validate response
            $response = Invoke-FabricRestMethod -Uri $apiEndpointUrl -Method Get
            Test-FabricApiResponse -Response $response -ObjectIdOrName $DeploymentPipelineId -TypeName "Deployment Pipeline Role Assignments"

            # Step 5: Process response and update continuation token
            if ($response.value) {
                $roleAssignments += $response.value
                Write-Message -Message "Added $($response.value.Count) role assignments to the result set." -Level Debug
            }
            $continuationToken = Get-FabricContinuationToken -Response $response

        } while ($continuationToken)

        # Step 7: Return results
        Write-Message -Message "Successfully retrieved $($roleAssignments.Count) role assignments." -Level Debug
        $roleAssignments

    } catch {
        # Step 8: Error handling
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to get deployment pipeline role assignments. Error: $errorDetails" -Level Error
    }
}
