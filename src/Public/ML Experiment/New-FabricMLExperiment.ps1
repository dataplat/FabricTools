function New-FabricMLExperiment
{
<#
.SYNOPSIS
    Creates a new ML Experiment in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a POST request to the Microsoft Fabric API to create a new ML Experiment
    in the specified workspace. It supports optional parameters for ML Experiment description.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the ML Experiment will be created. This parameter is mandatory.

.PARAMETER MLExperimentName
    The name of the ML Experiment to be created. This parameter is mandatory.

.PARAMETER MLExperimentDescription
    An optional description for the ML Experiment.

.EXAMPLE
    This example creates a new ML Experiment named "New ML Experiment" in the workspace with ID "workspace-12345" with the provided description.

    ```powershell
    New-FabricMLExperiment -WorkspaceId "workspace-12345" -MLExperimentName "New ML Experiment" -MLExperimentDescription "Description of the new ML Experiment"
    ```

.NOTES
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch, Kamil Nowinski
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$MLExperimentName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$MLExperimentDescription
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/mlExperiments"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $MLExperimentName
        }

        if ($MLExperimentDescription)
        {
            $body.description = $MLExperimentDescription
        }

        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($MLExperimentName, "Create ML Experiment")) {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "ML Experiment '$MLExperimentName' created successfully!" -Level Info
            return $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create ML Experiment. Error: $errorDetails" -Level Error
    }
}
