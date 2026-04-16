function New-FabricReflex
{
<#
.SYNOPSIS
    Creates a new Reflex in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a POST request to the Microsoft Fabric API to create a new Reflex
    in the specified workspace. It supports optional parameters for Reflex description and path definitions.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Reflex will be created. This parameter is mandatory.

.PARAMETER ReflexName
    The name of the Reflex to be created. This parameter is mandatory.

.PARAMETER ReflexDescription
    An optional description for the Reflex.

.PARAMETER ReflexPathDefinition
    An optional path to the Reflex definition file to upload.

.PARAMETER ReflexPathPlatformDefinition
    An optional path to the platform-specific definition file to upload.

.EXAMPLE
    This example creates a new Reflex named "New Reflex" in the workspace with ID "workspace-12345" with the provided description.

    ```powershell
    New-FabricReflex -WorkspaceId "workspace-12345" -ReflexName "New Reflex" -ReflexDescription "Description of the new Reflex"
    ```

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
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
        [string]$ReflexName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ReflexDescription,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ReflexPathDefinition,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ReflexPathPlatformDefinition
    )
    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/reflexes" -f $FabricConfig.BaseUrl, $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $ReflexName
        }

        if ($ReflexDescription)
        {
            $body.description = $ReflexDescription
        }

        if ($ReflexPathDefinition)
        {
            $ReflexEncodedContent = Convert-ToBase64 -filePath $ReflexPathDefinition

            if (-not [string]::IsNullOrEmpty($ReflexEncodedContent))
            {
                # Initialize definition if it doesn't exist
                if (-not $body.definition)
                {
                    $body.definition = @{
                        parts = @()
                    }
                }

                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = "ReflexEntities.json"
                    payload     = $ReflexEncodedContent
                    payloadType = "InlineBase64"
                }
            }
            else
            {
                Write-Message -Message "Invalid or empty content in Reflex definition." -Level Error
                return $null
            }
        }

        if ($ReflexPathPlatformDefinition)
        {
            $ReflexEncodedPlatformContent = Convert-ToBase64 -filePath $ReflexPathPlatformDefinition

            if (-not [string]::IsNullOrEmpty($ReflexEncodedPlatformContent))
            {
                # Initialize definition if it doesn't exist
                if (-not $body.definition)
                {
                    $body.definition = @{
                        parts = @()
                    }
                }

                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = ".platform"
                    payload     = $ReflexEncodedPlatformContent
                    payloadType = "InlineBase64"
                }
            }
            else
            {
                Write-Message -Message "Invalid or empty content in platform definition." -Level Error
                return $null
            }
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($ReflexName, "Create Reflex"))
        {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                TypeName       = 'Reflex'
                ObjectIdOrName = $ReflexName
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
        Write-Message -Message "Failed to create Reflex. Error: $errorDetails" -Level Error
    }
}
