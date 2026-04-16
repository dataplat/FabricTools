function Update-FabricKQLDatabaseDefinition
{
<#
.SYNOPSIS
Updates the definition of a KQLDatabase in a Microsoft Fabric workspace.

.DESCRIPTION
This function allows updating the content or metadata of a KQLDatabase in a Microsoft Fabric workspace.
The KQLDatabase content can be provided as file paths, and metadata updates can optionally be enabled.

.PARAMETER WorkspaceId
(Mandatory) The unique identifier of the workspace where the KQLDatabase resides.

.PARAMETER KQLDatabaseId
(Mandatory) The unique identifier of the KQLDatabase to be updated.

.PARAMETER KQLDatabasePathDefinition
(Mandatory) The file path to the KQLDatabase content definition file. The content will be encoded as Base64 and sent in the request.

.PARAMETER KQLDatabasePathPlatformDefinition
(Optional) The file path to the KQLDatabase's platform-specific definition file. The content will be encoded as Base64 and sent in the request.

.PARAMETER UpdateMetadata
(Optional)A boolean flag indicating whether to update the KQLDatabase's metadata.
Default: `$false`.

.PARAMETER KQLDatabasePathSchemaDefinition
(Optional) The file path to the KQLDatabase's schema definition file. The content will be encoded as Base64 and sent in the request.

.EXAMPLE
    Updates the content of the KQLDatabase with ID `67890` in the workspace `12345` using the specified KQLDatabase file.

    ```powershell
    Update-FabricKQLDatabaseDefinition -WorkspaceId "12345" -KQLDatabaseId "67890" -KQLDatabasePathDefinition "C:\KQLDatabases\KQLDatabase.ipynb"
    ```

.EXAMPLE
    Updates both the content and metadata of the KQLDatabase with ID `67890` in the workspace `12345`.

    ```powershell
    Update-FabricKQLDatabaseDefinition -WorkspaceId "12345" -KQLDatabaseId "67890" -KQLDatabasePathDefinition "C:\KQLDatabases\KQLDatabase.ipynb" -UpdateMetadata $true
    ```

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- The KQLDatabase content is encoded as Base64 before being sent to the Fabric API.
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
        [guid]$KQLDatabaseId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLDatabasePathDefinition,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLDatabasePathPlatformDefinition,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLDatabasePathSchemaDefinition
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/kqlDatabases/{2}/updateDefinition" -f $FabricConfig.BaseUrl, $WorkspaceId, $KQLDatabaseId

        if ($KQLDatabasePathPlatformDefinition)
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

        if ($KQLDatabasePathDefinition)
        {
            $KQLDatabaseEncodedContent = Convert-ToBase64 -filePath $KQLDatabasePathDefinition

            if (-not [string]::IsNullOrEmpty($KQLDatabaseEncodedContent))
            {
                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = "DatabaseProperties.json"
                    payload     = $KQLDatabaseEncodedContent
                    payloadType = "InlineBase64"
                }
            }
            else
            {
                Write-Message -Message "Invalid or empty content in KQLDatabase definition." -Level Error
                return $null
            }
        }

        if ($KQLDatabasePathPlatformDefinition)
        {
            $KQLDatabaseEncodedPlatformContent = Convert-ToBase64 -filePath $KQLDatabasePathPlatformDefinition
            if (-not [string]::IsNullOrEmpty($KQLDatabaseEncodedPlatformContent))
            {
                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = ".platform"
                    payload     = $KQLDatabaseEncodedPlatformContent
                    payloadType = "InlineBase64"
                }
            }
            else
            {
                Write-Message -Message "Invalid or empty content in platform definition." -Level Error
                return $null
            }
        }

        if ($KQLDatabasePathSchemaDefinition)
        {
            $KQLDatabaseEncodedSchemaContent = Convert-ToBase64 -filePath $KQLDatabasePathSchemaDefinition

            if (-not [string]::IsNullOrEmpty($KQLDatabaseEncodedSchemaContent))
            {
                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = "DatabaseSchema.kql"
                    payload     = $KQLDatabaseEncodedSchemaContent
                    payloadType = "InlineBase64"
                }
            }
            else
            {
                Write-Message -Message "Invalid or empty content in schema definition." -Level Error
                return $null
            }
        }

        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($KQLDatabaseId, "Update KQLDatabase Definition"))
        {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                TypeName       = 'KQL Database Definition'
                ObjectIdOrName = $KQLDatabaseId
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
        Write-Message -Message "Failed to update KQLDatabase. Error: $errorDetails" -Level Error
    }
}
