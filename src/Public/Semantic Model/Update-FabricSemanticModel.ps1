function Update-FabricSemanticModel
{
    <#
    .SYNOPSIS
        Updates an existing SemanticModel in a specified Microsoft Fabric workspace.

    .DESCRIPTION
        This function sends a PATCH request to the Microsoft Fabric API to update an existing SemanticModel
        in the specified workspace. It supports optional parameters for SemanticModel description.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace where the SemanticModel exists. This parameter is optional.

    .PARAMETER SemanticModelId
        The unique identifier of the SemanticModel to be updated. This parameter is mandatory.

    .PARAMETER SemanticModelName
        The new name of the SemanticModel. This parameter is mandatory.

    .PARAMETER SemanticModelDescription
        An optional new description for the SemanticModel.

    .EXAMPLE
        This example updates the SemanticModel with ID "SemanticModel-67890" in the workspace with ID "workspace-12345" with a new name and description.

        ```powershell
        Update-FabricSemanticModel -WorkspaceId "workspace-12345" -SemanticModelId "SemanticModel-67890" -SemanticModelName "Updated SemanticModel" -SemanticModelDescription "Updated description"
        ```

    .NOTES
        - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.

        Author: Tiago Balabuch
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
        [string]$SemanticModelName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SemanticModelDescription
    )
    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/semanticModels/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $SemanticModelId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $SemanticModelName
        }

        if ($SemanticModelDescription)
        {
            $body.description = $SemanticModelDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess("Update SemanticModel", "Updating the SemanticModel with ID '$SemanticModelId' in workspace '$WorkspaceId'."))
        {
            # Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Patch `
                -Body $bodyJson
        }

        # Validate the response code
        if ($statusCode -ne 200)
        {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        # Handle results
        Write-Message -Message "SemanticModel '$SemanticModelName' updated successfully!" -Level Info
        return $response
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update SemanticModel. Error: $errorDetails" -Level Error
    }
}
