function Update-FabricSemanticModelDefinition
{
    <#
    .SYNOPSIS
        Updates the definition of an existing SemanticModel in a specified Microsoft Fabric workspace.

    .DESCRIPTION
        This function sends a POST request to the Microsoft Fabric API to update the definition of an existing SemanticModel
        in the specified workspace. It supports optional parameters for SemanticModel definition and platform-specific definition.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace where the SemanticModel exists. This parameter is mandatory.

    .PARAMETER SemanticModelId
        The unique identifier of the SemanticModel to be updated. This parameter is mandatory.

    .PARAMETER SemanticModelPathDefinition
        An optional path to the SemanticModel definition file to upload.

    .EXAMPLE
        This example updates the definition of the SemanticModel with ID "SemanticModel-67890" in the workspace with ID "workspace-12345" using the provided definition file.

        ```powershell
        Update-FabricSemanticModelDefinition -WorkspaceId "workspace-12345" -SemanticModelId "SemanticModel-67890" -SemanticModelPathDefinition "C:\Path\To\SemanticModelDefinition.json"
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
        [guid]$SemanticModelId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SemanticModelPathDefinition
    )

    # Ensure token validity
    Confirm-TokenState

    $body = @{
        definition = @{
            parts = @()
        }
    }

    $jsonObjectParts = Get-FileDefinitionParts -sourceDirectory $SemanticModelPathDefinition
    $body.definition.parts = $jsonObjectParts.parts

    $hasPlatformFile = $false
    foreach ($part in $jsonObjectParts.parts)
    {
        if ($part.path -eq ".platform")
        {
            $hasPlatformFile = $true
            Write-Message -Message "Platform File: $hasPlatformFile" -Level Debug
        }
    }

    $uri = "workspaces/$WorkspaceId/SemanticModels/$SemanticModelId/updateDefinition"
    if ($hasPlatformFile)
    {
        $uri = "$uri?updateMetadata=true"
    }
    Write-Message -Message "API Endpoint: $uri" -Level Debug

    $bodyJson = $body | ConvertTo-Json -Depth 10
    Write-Message -Message "Request Body: $bodyJson" -Level Debug

    if ($PSCmdlet.ShouldProcess($SemanticModelId, "Update SemanticModel Definition"))
    {
        $apiParams = @{
            Uri            = $uri
            Method         = 'Post'
            Body           = $bodyJson
            TypeName       = 'SemanticModel'
            ObjectIdOrName = $SemanticModelId
            HandleResponse = $true
        }

        $response = Invoke-FabricRestMethod @apiParams
        Write-Message -Message "Update definition for SemanticModel '$SemanticModelId' completed successfully!" -Level Info
        $response
    }
}
