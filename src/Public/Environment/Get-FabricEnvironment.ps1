function Get-FabricEnvironment {

    <#
.SYNOPSIS
Retrieves an environment or a list of environments from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Get-FabricEnvironment` function sends a GET request to the Fabric API to retrieve environment details for a given workspace. It can filter the results by `EnvironmentName`.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace to query environments.

.PARAMETER EnvironmentId
(Optional) The ID of a specific environment to retrieve.

.PARAMETER EnvironmentName
(Optional) The name of the specific environment to retrieve.

.EXAMPLE
    Retrieves the "Development" environment from workspace "12345".

    ```powershell
    Get-FabricEnvironment -WorkspaceId "12345" -EnvironmentName "Development"
    ```

.EXAMPLE
    Retrieves all environments in workspace "12345".

    ```powershell
    Get-FabricEnvironment -WorkspaceId "12345"
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- Returns the matching environment details or all environments if no filter is provided.

Author: Tiago Balabuch, Kamil Nowinski

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$EnvironmentId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EnvironmentName
    )

    try {
        # Handle ambiguous input
        if ($EnvironmentId -and $EnvironmentName) {
            Write-Message -Message "Both 'EnvironmentId' and 'EnvironmentName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/{0}/environments" -f $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Make the API request
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            TypeName       = 'Environment'
            ObjectIdOrName = $EnvironmentId
            HandleResponse = $true
            ExtractValue   = 'True'
        }
        $environments = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $environment = if ($EnvironmentId) {
            $environments | Where-Object { $_.Id -eq $EnvironmentId }
        } elseif ($EnvironmentName) {
            $environments | Where-Object { $_.DisplayName -eq $EnvironmentName }
        } else {
            # Return all workspaces if no filter is provided
            Write-Message -Message "No filter provided. Returning all environments." -Level Debug
            $environments
        }

        # Handle results
        if ($environment) {
            Write-Message -Message "Environment found in the Workspace '$WorkspaceId'." -Level Debug
            return $environment
        } else {
            Write-Message -Message "No environment found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve environment. Error: $errorDetails" -Level Error
    }

}
