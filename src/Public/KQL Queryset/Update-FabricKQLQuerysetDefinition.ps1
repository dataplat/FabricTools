function Update-FabricKQLQuerysetDefinition {
<#
.SYNOPSIS
Updates the definition of a KQLQueryset in a Microsoft Fabric workspace.

.DESCRIPTION
This function allows updating the content or metadata of a KQLQueryset in a Microsoft Fabric workspace.
The KQLQueryset content can be provided as file paths, and metadata updates can optionally be enabled.

.PARAMETER WorkspaceId
(Mandatory) The unique identifier of the workspace where the KQLQueryset resides.

.PARAMETER KQLQuerysetId
(Mandatory) The unique identifier of the KQLQueryset to be updated.

.PARAMETER KQLQuerysetPathDefinition
(Mandatory) The file path to the KQLQueryset content definition file. The content will be encoded as Base64 and sent in the request.

.PARAMETER KQLQuerysetPathPlatformDefinition
(Optional) The file path to the KQLQueryset's platform-specific definition file. The content will be encoded as Base64 and sent in the request.

.EXAMPLE
    Updates the content of the KQLQueryset with ID `67890` in the workspace `12345` using the specified KQLQueryset file.

    ```powershell
    Update-FabricKQLQuerysetDefinition -WorkspaceId "12345" -KQLQuerysetId "67890" -KQLQuerysetPathDefinition "C:\KQLQuerysets\KQLQueryset.ipynb"
    ```

.EXAMPLE
    Updates both the content and metadata of the KQLQueryset with ID `67890` in the workspace `12345`.

    ```powershell
    Update-FabricKQLQuerysetDefinition -WorkspaceId "12345" -KQLQuerysetId "67890" -KQLQuerysetPathDefinition "C:\KQLQuerysets\KQLQueryset.ipynb"
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- The KQLQueryset content is encoded as Base64 before being sent to the Fabric API.
- This function handles asynchronous operations and retrieves operation results if required.

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$KQLQuerysetId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLQuerysetPathDefinition,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLQuerysetPathPlatformDefinition
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/kqlQuerysets/$KQLQuerysetId/updateDefinition"

        if ($KQLQuerysetPathPlatformDefinition) {
            $apiEndpointUrl = "$apiEndpointUrl?updateMetadata=true"
        }
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            definition = @{
                format = $null
                parts  = @()
            }
        }

        if ($KQLQuerysetPathDefinition) {
            $KQLQuerysetEncodedContent = Convert-ToBase64 -filePath $KQLQuerysetPathDefinition

            if (-not [string]::IsNullOrEmpty($KQLQuerysetEncodedContent)) {
                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = "RealTimeQueryset.json"
                    payload     = $KQLQuerysetEncodedContent
                    payloadType = "InlineBase64"
                }
            } else {
                Write-Message -Message "Invalid or empty content in KQLQueryset definition." -Level Error
                return $null
            }
        }

        if ($KQLQuerysetPathPlatformDefinition) {
            $KQLQuerysetEncodedPlatformContent = Convert-ToBase64 -filePath $KQLQuerysetPathPlatformDefinition
            if (-not [string]::IsNullOrEmpty($KQLQuerysetEncodedPlatformContent)) {
                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = ".platform"
                    payload     = $KQLQuerysetEncodedPlatformContent
                    payloadType = "InlineBase64"
                }
            } else {
                Write-Message -Message "Invalid or empty content in platform definition." -Level Error
                return $null
            }
        }

        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($KQLQuerysetId, "Update KQLQueryset")) {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Update definition for KQLQueryset '$KQLQuerysetId' created successfully!" -Level Info
            return $response
        }
    } catch {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update KQLQueryset. Error: $errorDetails" -Level Error
    }
}
