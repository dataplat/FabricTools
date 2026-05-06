function Get-FabricMLExperiment {
<#
.SYNOPSIS
    Retrieves ML Experiment details from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function retrieves ML Experiment details from a specified workspace using either the provided MLExperimentId or MLExperimentName.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the ML Experiment exists. This parameter is mandatory.

.PARAMETER MLExperimentId
    The unique identifier of the ML Experiment to retrieve. This parameter is optional.

.PARAMETER MLExperimentName
    The name of the ML Experiment to retrieve. This parameter is optional.

.EXAMPLE
    This example retrieves the ML Experiment details for the experiment with ID "experiment-67890" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricMLExperiment -WorkspaceId "workspace-12345" -MLExperimentId "experiment-67890"
    ```

.EXAMPLE
    This example retrieves the ML Experiment details for the experiment named "My ML Experiment" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricMLExperiment -WorkspaceId "workspace-12345" -MLExperimentName "My ML Experiment"
    ```

.NOTES
    Author: Tiago Balabuch, Kamil Nowinski
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$MLExperimentId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$MLExperimentName
    )

    try {
        # Handle ambiguous input
        if ($MLExperimentId -and $MLExperimentName) {
            Write-Message -Message "Both 'MLExperimentId' and 'MLExperimentName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/mlExperiments"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Invoke the Fabric API to retrieve ML Experiments
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            ExtractValue   = 'True'
            HandleResponse = $true
        }
        $MLExperiments = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $MLExperiment = if ($MLExperimentId) {
            $MLExperiments | Where-Object { $_.Id -eq $MLExperimentId }
        } elseif ($MLExperimentName) {
            $MLExperiments | Where-Object { $_.DisplayName -eq $MLExperimentName }
        } else {
            # Return all MLExperiments if no filter is provided
            Write-Message -Message "No filter provided. Returning all MLExperiments." -Level Debug
            $MLExperiments
        }

        # Handle results
        if ($MLExperiment) {
            Write-Message -Message "ML Experiment found matching the specified criteria." -Level Debug
            return $MLExperiment
        } else {
            Write-Message -Message "No ML Experiment found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve ML Experiment. Error: $errorDetails" -Level Error
    }

}
