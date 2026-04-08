function New-FabricNotebook
{
<#
.SYNOPSIS
Creates a new notebook in a specified Microsoft Fabric workspace.

.DESCRIPTION
This function sends a POST request to the Microsoft Fabric API to create a new notebook
in the specified workspace. It supports optional parameters for notebook description
and path definitions for the notebook content.

.PARAMETER WorkspaceId
The unique identifier of the workspace where the notebook will be created.

.PARAMETER NotebookName
The name of the notebook to be created.

.PARAMETER NotebookDescription
An optional description for the notebook.

.PARAMETER NotebookPathDefinition
An optional path to the notebook definition file (e.g., .ipynb file) to upload.

.PARAMETER NotebookPathPlatformDefinition
An optional path to the platform-specific definition (e.g., .platform file) to upload.

.EXAMPLE
    Creates a new notebook in the specified workspace with a given name and path definition.

    ```powershell
    New-FabricNotebook -WorkspaceId "workspace-12345" -NotebookName "New Notebook" -NotebookPathDefinition "C:\notebooks\example.ipynb"
    ```

 .NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding(supportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$NotebookName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$NotebookDescription,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$NotebookPathDefinition,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$NotebookPathPlatformDefinition
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/notebooks" -f $FabricConfig.BaseUrl, $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $NotebookName
        }

        if ($NotebookDescription)
        {
            $body.description = $NotebookDescription
        }

        if ($NotebookPathDefinition)
        {
            $notebookEncodedContent = Convert-ToBase64 -filePath $NotebookPathDefinition

            if (-not [string]::IsNullOrEmpty($notebookEncodedContent))
            {
                # Initialize definition if it doesn't exist
                if (-not $body.definition)
                {
                    $body.definition = @{
                        format = "ipynb"
                        parts  = @()
                    }
                }

                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = "notebook-content.py"
                    payload     = $notebookEncodedContent
                    payloadType = "InlineBase64"
                }
            }
            else
            {
                Write-Message -Message "Invalid or empty content in notebook definition." -Level Error
                return $null
            }
        }

        if ($NotebookPathPlatformDefinition)
        {
            $notebookEncodedPlatformContent = Convert-ToBase64 -filePath $NotebookPathPlatformDefinition

            if (-not [string]::IsNullOrEmpty($notebookEncodedPlatformContent))
            {
                # Initialize definition if it doesn't exist
                if (-not $body.definition)
                {
                    $body.definition = @{
                        format = "ipynb"
                        parts  = @()
                    }
                }

                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = ".platform"
                    payload     = $notebookEncodedPlatformContent
                    payloadType = "InlineBase64"
                }
            }
            else
            {
                Write-Message -Message "Invalid or empty content in platform definition." -Level Error
                return $null
            }
        }

        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug
        if ($PSCmdlet.ShouldProcess($NotebookName, "Create Notebook"))
        {
            # Make the API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                TypeName       = 'Notebook'
                ObjectIdOrName = $NotebookName
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create notebook. Error: $errorDetails" -Level Error
    }
}
