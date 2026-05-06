function Update-FabricReflexDefinition
{
<#
.SYNOPSIS
    Updates the definition of an existing Reflex in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a PATCH request to the Microsoft Fabric API to update the definition of an existing Reflex
    in the specified workspace. It supports optional parameters for Reflex definition and platform-specific definition.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Reflex exists. This parameter is mandatory.

.PARAMETER ReflexId
    The unique identifier of the Reflex to be updated. This parameter is mandatory.

.PARAMETER ReflexPathDefinition
    An optional path to the Reflex definition file to upload.

.PARAMETER ReflexPathPlatformDefinition
    An optional path to the platform-specific definition file to upload.

.EXAMPLE
    This example updates the definition of the Reflex with ID "Reflex-67890" in the workspace with ID "workspace-12345" using the provided definition file.

    ```powershell
    Update-FabricReflexDefinition -WorkspaceId "workspace-12345" -ReflexId "Reflex-67890" -ReflexPathDefinition "C:\Path\To\ReflexDefinition.json"
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
        [guid]$ReflexId,

        [Parameter(Mandatory = $true)]
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
        $apiEndpointUrl = "{0}/workspaces/{1}/reflexes/{2}/updateDefinition" -f $FabricConfig.BaseUrl, $WorkspaceId, $ReflexId

        if ($ReflexPathPlatformDefinition)
        {
            $apiEndpointUrl += "?updateMetadata=true"
        }
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            definition = @{
                parts = @()
            }
        }

        if ($ReflexPathDefinition)
        {
            $ReflexEncodedContent = Convert-ToBase64 -filePath $ReflexPathDefinition

            if (-not [string]::IsNullOrEmpty($ReflexEncodedContent))
            {
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

        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Update Reflex Definition"))
        {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                TypeName       = 'Reflex Definition'
                ObjectIdOrName = $ReflexId
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
        Write-Message -Message "Failed to update Reflex. Error: $errorDetails" -Level Error
    }
}
