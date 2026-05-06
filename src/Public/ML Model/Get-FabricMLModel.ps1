function Get-FabricMLModel {
<#
.SYNOPSIS
    Retrieves ML Model details from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function retrieves ML Model details from a specified workspace using either the provided MLModelId or MLModelName.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the ML Model exists. This parameter is mandatory.

.PARAMETER MLModelId
    The unique identifier of the ML Model to retrieve. This parameter is optional.

.PARAMETER MLModelName
    The name of the ML Model to retrieve. This parameter is optional.

.EXAMPLE
    This example retrieves the ML Model details for the model with ID "model-67890" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricMLModel -WorkspaceId "workspace-12345" -MLModelId "model-67890"
    ```

.EXAMPLE
    This example retrieves the ML Model details for the model named "My ML Model" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricMLModel -WorkspaceId "workspace-12345" -MLModelName "My ML Model"
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
        [guid]$MLModelId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$MLModelName
    )

    try {
        # Handle ambiguous input
        if ($MLModelId -and $MLModelName) {
            Write-Message -Message "Both 'MLModelId' and 'MLModelName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/mlModels"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Invoke the Fabric API to retrieve ML Models
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            ExtractValue   = 'True'
            HandleResponse = $true
        }
        $MLModels = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $MLModel = if ($MLModelId) {
            $MLModels | Where-Object { $_.Id -eq $MLModelId }
        } elseif ($MLModelName) {
            $MLModels | Where-Object { $_.DisplayName -eq $MLModelName }
        } else {
            # Return all MLModels if no filter is provided
            Write-Message -Message "No filter provided. Returning all MLModels." -Level Debug
            $MLModels
        }

        # Handle results
        if ($MLModel) {
            Write-Message -Message "ML Model found matching the specified criteria." -Level Debug
            return $MLModel
        } else {
            Write-Message -Message "No ML Model found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve ML Model. Error: $errorDetails" -Level Error
    }

}
