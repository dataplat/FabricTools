function Get-FabricSemanticModelDefinition {
    <#
    .SYNOPSIS
        Retrieves the definition of an SemanticModel from a specified Microsoft Fabric workspace.

    .DESCRIPTION
        This function retrieves the definition of an SemanticModel from a specified workspace using the provided SemanticModelId.
        It handles token validation, constructs the API URL, makes the API request, and processes the response.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace where the SemanticModel exists. This parameter is mandatory.

    .PARAMETER SemanticModelId
        The unique identifier of the SemanticModel to retrieve the definition for. This parameter is optional.

    .PARAMETER SemanticModelFormat
        The format in which to retrieve the SemanticModel definition. This parameter is optional.

    .EXAMPLE
        This example retrieves the definition of the SemanticModel with ID "SemanticModel-67890" in the workspace with ID "workspace-12345".

        ```powershell
        Get-FabricSemanticModelDefinition -WorkspaceId "workspace-12345" -SemanticModelId "SemanticModel-67890"
        ```

    .EXAMPLE
        This example retrieves the definition of the SemanticModel with ID "SemanticModel-67890" in the workspace with ID "workspace-12345" in JSON format.

        ```powershell
        Get-FabricSemanticModelDefinition -WorkspaceId "workspace-12345" -SemanticModelId "SemanticModel-67890" -SemanticModelFormat "json"
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
        [ValidateSet('TMDL', 'TMSL')]
        [string]$SemanticModelFormat = "TMDL"
    )
    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/semanticModels/$SemanticModelId/getDefinition"
        if ($SemanticModelFormat) {
            $apiEndpointUrl = "$apiEndpointUrl?format=$SemanticModelFormat"
        }
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Invoke the Fabric API to retrieve SemanticModel definition
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams

        # Return the response
        return $response
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve SemanticModel. Error: $errorDetails" -Level Error
    }

}
