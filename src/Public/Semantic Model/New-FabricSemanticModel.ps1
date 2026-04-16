function New-FabricSemanticModel
{
    <#
    .SYNOPSIS
        Creates a new SemanticModel in a specified Microsoft Fabric workspace.

    .DESCRIPTION
        This function sends a POST request to the Microsoft Fabric API to create a new SemanticModel
        in the specified workspace. It supports optional parameters for SemanticModel description and path definitions.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace where the SemanticModel will be created. This parameter is mandatory.

    .PARAMETER SemanticModelName
        The name of the SemanticModel to be created. This parameter is mandatory.

    .PARAMETER SemanticModelDescription
        An optional description for the SemanticModel.

    .PARAMETER SemanticModelPathDefinition
        An optional path to the SemanticModel definition file to upload.

    .EXAMPLE
        This example creates a new SemanticModel named "New SemanticModel" in the workspace with ID "workspace-12345" with the provided description.

        ```powershell
        New-FabricSemanticModel -WorkspaceId "workspace-12345" -SemanticModelName "New SemanticModel" -SemanticModelDescription "Description of the new SemanticModel"
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
        [string]$SemanticModelName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SemanticModelDescription,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SemanticModelPathDefinition
    )
    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/semanticModels"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $SemanticModelName
            definition  = @{
                parts = @()
            }
        }

        $jsonObjectParts = Get-FileDefinitionParts -sourceDirectory $SemanticModelPathDefinition
        # Add new part to the parts array
        $body.definition.parts = $jsonObjectParts.parts

        if ($SemanticModelDescription)
        {
            $body.description = $SemanticModelDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess("Create SemanticModel", "Creating the SemanticModel '$SemanticModelName' in workspace '$WorkspaceId'.")) {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "SemanticModel '$SemanticModelName' created successfully!" -Level Info
            return $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create SemanticModel. Error: $errorDetails" -Level Error
    }
}
