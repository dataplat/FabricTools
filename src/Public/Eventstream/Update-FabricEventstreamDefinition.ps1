function Update-FabricEventstreamDefinition
{
<#
.SYNOPSIS
Updates the definition of a Eventstream in a Microsoft Fabric workspace.

.DESCRIPTION
This function allows updating the content or metadata of a Eventstream in a Microsoft Fabric workspace.
The Eventstream content can be provided as file paths, and metadata updates can optionally be enabled.

.PARAMETER WorkspaceId
(Mandatory) The unique identifier of the workspace where the Eventstream resides.

.PARAMETER EventstreamId
(Mandatory) The unique identifier of the Eventstream to be updated.

.PARAMETER EventstreamPathDefinition
(Mandatory) The file path to the Eventstream content definition file. The content will be encoded as Base64 and sent in the request.

.PARAMETER EventstreamPathPlatformDefinition
(Optional) The file path to the Eventstream's platform-specific definition file. The content will be encoded as Base64 and sent in the request.

.PARAMETER UpdateMetadata
(Optional)A boolean flag indicating whether to update the Eventstream's metadata.
Default: `$false`.

.EXAMPLE
    Updates the content of the Eventstream with ID `67890` in the workspace `12345` using the specified Eventstream file.

    ```powershell
    Update-FabricEventstreamDefinition -WorkspaceId "12345" -EventstreamId "67890" -EventstreamPathDefinition "C:\Eventstreams\Eventstream.ipynb"
    ```

.EXAMPLE
    Updates both the content and metadata of the Eventstream with ID `67890` in the workspace `12345`.

    ```powershell
    Update-FabricEventstreamDefinition -WorkspaceId "12345" -EventstreamId "67890" -EventstreamPathDefinition "C:\Eventstreams\Eventstream.ipynb" -UpdateMetadata $true
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- The Eventstream content is encoded as Base64 before being sent to the Fabric API.

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$EventstreamId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$EventstreamPathDefinition,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EventstreamPathPlatformDefinition
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/eventstreams/$EventstreamId/updateDefinition"
        if ($EventstreamPathPlatformDefinition) {
            $apiEndpointUrl = "$apiEndpointUrl?updateMetadata=true"
        }
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            definition = @{
                parts = @()
            }
        }

        if ($EventstreamPathDefinition)
        {
            $EventstreamEncodedContent = Convert-ToBase64 -filePath $EventstreamPathDefinition

            if (-not [string]::IsNullOrEmpty($EventstreamEncodedContent))
            {
                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = "eventstream.json"
                    payload     = $EventstreamEncodedContent
                    payloadType = "InlineBase64"
                }
            }
            else
            {
                Write-Message -Message "Invalid or empty content in Eventstream definition." -Level Error
                return $null
            }
        }

        if ($EventstreamPathPlatformDefinition)
        {
            $EventstreamEncodedPlatformContent = Convert-ToBase64 -filePath $EventstreamPathPlatformDefinition
            if (-not [string]::IsNullOrEmpty($EventstreamEncodedPlatformContent))
            {
                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = ".platform"
                    payload     = $EventstreamEncodedPlatformContent
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

        if ($PSCmdlet.ShouldProcess($EventstreamId, "Update Eventstream")) {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Update definition for Eventstream '$EventstreamId' created successfully!" -Level Info
            return $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update Eventstream. Error: $errorDetails" -Level Error
    }
}
