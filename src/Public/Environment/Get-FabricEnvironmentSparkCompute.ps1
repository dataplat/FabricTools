function Get-FabricEnvironmentSparkCompute {
<#
.SYNOPSIS
Retrieves the Spark compute details for a specific environment in a Microsoft Fabric workspace.

.DESCRIPTION
The Get-FabricEnvironmentSparkCompute function communicates with the Microsoft Fabric API to fetch information
about Spark compute resources associated with a specified environment. It ensures that the API token is valid
and gracefully handles errors during the API call.

.PARAMETER WorkspaceId
The unique identifier of the workspace containing the target environment.

.PARAMETER EnvironmentId
The unique identifier of the environment whose Spark compute details are being retrieved.

.EXAMPLE
    Retrieves Spark compute details for the specified environment in the given workspace.

    ```powershell
    Get-FabricEnvironmentSparkCompute -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890"
    ```

.NOTES
- Uses `Confirm-TokenState` to validate the token before making API calls.

Author: Tiago Balabuch, Kamil Nowinski
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$EnvironmentId
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/{0}/environments/{1}/sparkcompute" -f $WorkspaceId, $EnvironmentId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Make the API request
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            TypeName       = 'Environment'
            ObjectIdOrName = $EnvironmentId
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams

        # Handle results
        return $response
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve environment Spark compute. Error: $errorDetails" -Level Error
    }

}
