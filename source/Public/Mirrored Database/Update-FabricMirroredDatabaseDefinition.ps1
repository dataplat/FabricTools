<#
.SYNOPSIS
Updates the definition of a MirroredDatabase in a Microsoft Fabric workspace.

.DESCRIPTION
This function allows updating the content or metadata of a MirroredDatabase in a Microsoft Fabric workspace.
The MirroredDatabase content can be provided as file paths, and metadata updates can optionally be enabled.

.PARAMETER WorkspaceId
(Mandatory) The unique identifier of the workspace where the MirroredDatabase resides.

.PARAMETER MirroredDatabaseId
(Mandatory) The unique identifier of the MirroredDatabase to be updated.

.PARAMETER MirroredDatabasePathDefinition
(Mandatory) The file path to the MirroredDatabase content definition file. The content will be encoded as Base64 and sent in the request.

.PARAMETER MirroredDatabasePathPlatformDefinition
(Optional) The file path to the MirroredDatabase's platform-specific definition file. The content will be encoded as Base64 and sent in the request.

.PARAMETER UpdateMetadata
(Optional)A boolean flag indicating whether to update the MirroredDatabase's metadata.
Default: `$false`.

.EXAMPLE
Update-FabricMirroredDatabaseDefinition -WorkspaceId "12345" -MirroredDatabaseId "67890" -MirroredDatabasePathDefinition "C:\MirroredDatabases\MirroredDatabase.json"

Updates the content of the MirroredDatabase with ID `67890` in the workspace `12345` using the specified MirroredDatabase file.

.EXAMPLE
Update-FabricMirroredDatabaseDefinition -WorkspaceId "12345" -MirroredDatabaseId "67890" -MirroredDatabasePathDefinition "C:\MirroredDatabases\MirroredDatabase.json" -UpdateMetadata $true

Updates both the content and metadata of the MirroredDatabase with ID `67890` in the workspace `12345`.

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.
- The MirroredDatabase content is encoded as Base64 before being sent to the Fabric API.
- This function handles asynchronous operations and retrieves operation results if required.

Author: Tiago Balabuch

#>

function Update-FabricMirroredDatabaseDefinition
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$MirroredDatabaseId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$MirroredDatabasePathDefinition,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$MirroredDatabasePathPlatformDefinition
    )

    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/mirroredDatabases/{2}/updateDefinition" -f $FabricConfig.BaseUrl, $WorkspaceId, $MirroredDatabaseId

        if ($MirroredDatabasePathPlatformDefinition)
        {
            $apiEndpointUrl = "?updateMetadata=true" -f $apiEndpointUrl
        }
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            definition = @{
                parts = @()
            }
        }

        if ($MirroredDatabasePathDefinition)
        {
            $MirroredDatabaseEncodedContent = Convert-ToBase64 -filePath $MirroredDatabasePathDefinition

            if (-not [string]::IsNullOrEmpty($MirroredDatabaseEncodedContent))
            {
                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = "MirroredDatabase.json"
                    payload     = $MirroredDatabaseEncodedContent
                    payloadType = "InlineBase64"
                }
            }
            else
            {
                Write-Message -Message "Invalid or empty content in MirroredDatabase definition." -Level Error
                return $null
            }
        }

        if ($MirroredDatabasePathPlatformDefinition)
        {
            $MirroredDatabaseEncodedPlatformContent = Convert-ToBase64 -filePath $MirroredDatabasePathPlatformDefinition
            if (-not [string]::IsNullOrEmpty($MirroredDatabaseEncodedPlatformContent))
            {
                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = ".platform"
                    payload     = $MirroredDatabaseEncodedPlatformContent
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
        if ($PSCmdlet.ShouldProcess($MirroredDatabaseId, "Update MirroredDatabase"))
        {
            # Step 4: Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Post `
                -Body $bodyJson
        }

        # Step 5: Handle and log the response
        switch ($statusCode)
        {
            200
            {
                Write-Message -Message "Update definition for MirroredDatabase '$MirroredDatabaseId' created successfully!" -Level Info
                return $response
            }
            202
            {
                Write-Message -Message "Update definition for MirroredDatabase '$MirroredDatabaseId' accepted. Operation in progress!" -Level Info
                [string]$operationId = $responseHeader["x-ms-operation-id"]
                $operationResult = Get-FabricLongRunningOperation -operationId $operationId

                # Handle operation result
                if ($operationResult.status -eq "Succeeded")
                {
                    Write-Message -Message "Operation Succeeded" -Level Debug

                    $result = Get-FabricLongRunningOperationResult -operationId $operationId
                    return $result.definition.parts
                }
                else
                {
                    Write-Message -Message "Operation Failed" -Level Debug
                    return $operationResult.definition.parts
                }
            }
            default
            {
                Write-Message -Message "Unexpected response code: $statusCode" -Level Error
                Write-Message -Message "Error details: $($response.message)" -Level Error
                throw "API request failed with status code $statusCode."
            }
        }
    }
    catch
    {
        # Step 6: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update MirroredDatabase. Error: $errorDetails" -Level Error
    }
}
