function Get-FabricSemanticModel {
    <#
    .SYNOPSIS
        Retrieves SemanticModel details from a specified Microsoft Fabric workspace.

    .DESCRIPTION
        This function retrieves SemanticModel details from a specified workspace using either the provided SemanticModelId or SemanticModelName.
        It handles token validation, constructs the API URL, makes the API request, and processes the response.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace where the SemanticModel exists. This parameter is mandatory.

    .PARAMETER SemanticModelId
        The unique identifier of the SemanticModel to retrieve. This parameter is optional.

    .PARAMETER SemanticModelName
        The name of the SemanticModel to retrieve. This parameter is optional.

    .EXAMPLE
        This example retrieves the SemanticModel details for the SemanticModel with ID "SemanticModel-67890" in the workspace with ID "workspace-12345".

        ```powershell
        Get-FabricSemanticModel -WorkspaceId "workspace-12345" -SemanticModelId "SemanticModel-67890"
        ```

    .EXAMPLE
        This example retrieves the SemanticModel details for the SemanticModel named "My SemanticModel" in the workspace with ID "workspace-12345".

        ```powershell
        Get-FabricSemanticModel -WorkspaceId "workspace-12345" -SemanticModelName "My SemanticModel"
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
        [guid]$SemanticModelId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SemanticModelName
    )
    try {
        # Handle ambiguous input
        if ($SemanticModelId -and $SemanticModelName) {
            Write-Message -Message "Both 'SemanticModelId' and 'SemanticModelName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/semanticModels"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Invoke the Fabric API to retrieve SemanticModels
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            ExtractValue   = 'True'
            HandleResponse = $true
        }
        $SemanticModels = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $SemanticModel = if ($SemanticModelId) {
            $SemanticModels | Where-Object { $_.Id -eq $SemanticModelId }
        } elseif ($SemanticModelName) {
            $SemanticModels | Where-Object { $_.DisplayName -eq $SemanticModelName }
        } else {
            # Return all SemanticModels if no filter is provided
            Write-Message -Message "No filter provided. Returning all SemanticModels." -Level Debug
            $SemanticModels
        }

        # Handle results
        if ($SemanticModel) {
            Write-Message -Message "SemanticModel found in the Workspace '$WorkspaceId'." -Level Debug
            return $SemanticModel
        } else {
            Write-Message -Message "No SemanticModel found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve SemanticModel. Error: $errorDetails" -Level Error
    }

}
