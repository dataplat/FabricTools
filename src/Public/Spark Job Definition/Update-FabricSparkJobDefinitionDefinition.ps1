function Update-FabricSparkJobDefinitionDefinition
{
    <#
    .SYNOPSIS
        Updates the definition of an existing SparkJobDefinition in a specified Microsoft Fabric workspace.

    .DESCRIPTION
        This function sends a PATCH request to the Microsoft Fabric API to update the definition of an existing SparkJobDefinition
        in the specified workspace. It supports optional parameters for SparkJobDefinition definition and platform-specific definition.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace where the SparkJobDefinition exists. This parameter is mandatory.

    .PARAMETER SparkJobDefinitionId
        The unique identifier of the SparkJobDefinition to be updated. This parameter is mandatory.

    .PARAMETER SparkJobDefinitionPathDefinition
        An optional path to the SparkJobDefinition definition file to upload.

    .PARAMETER SparkJobDefinitionPathPlatformDefinition
        An optional path to the platform-specific definition file to upload.

    .EXAMPLE
        This example updates the definition of the SparkJobDefinition with ID "SparkJobDefinition-67890" in the workspace with ID "workspace-12345" using the provided definition file.

        ```powershell
        Update-FabricSparkJobDefinitionDefinition -WorkspaceId "workspace-12345" -SparkJobDefinitionId "SparkJobDefinition-67890" -SparkJobDefinitionPathDefinition "C:\Path\To\SparkJobDefinitionDefinition.json"
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
        [guid]$SparkJobDefinitionId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SparkJobDefinitionPathDefinition,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SparkJobDefinitionPathPlatformDefinition
    )
    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/SparkJobDefinitions/$SparkJobDefinitionId/updateDefinition"
        if ($SparkJobDefinitionPathPlatformDefinition) {
            $apiEndpointUrl = "$apiEndpointUrl?updateMetadata=true"
        }
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            definition = @{
                format = "SparkJobDefinitionV1"
                parts  = @()
            }
        }

        if ($SparkJobDefinitionPathDefinition)
        {
            $SparkJobDefinitionEncodedContent = Convert-ToBase64 -filePath $SparkJobDefinitionPathDefinition

            if (-not [string]::IsNullOrEmpty($SparkJobDefinitionEncodedContent))
            {
                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = "SparkJobDefinitionV1.json"
                    payload     = $SparkJobDefinitionEncodedContent
                    payloadType = "InlineBase64"
                }
            }
            else
            {
                Write-Message -Message "Invalid or empty content in SparkJobDefinition definition." -Level Error
                return $null
            }
        }

        if ($SparkJobDefinitionPathPlatformDefinition)
        {
            $SparkJobDefinitionEncodedPlatformContent = Convert-ToBase64 -filePath $SparkJobDefinitionPathPlatformDefinition
            if (-not [string]::IsNullOrEmpty($SparkJobDefinitionEncodedPlatformContent))
            {
                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = ".platform"
                    payload     = $SparkJobDefinitionEncodedPlatformContent
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

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Update Spark Job Definition")) {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Update definition for Spark Job Definition '$SparkJobDefinitionId' created successfully!" -Level Info
            return $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update Spark Job Definition. Error: $errorDetails" -Level Error
    }
}
