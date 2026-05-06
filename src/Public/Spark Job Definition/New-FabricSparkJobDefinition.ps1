function New-FabricSparkJobDefinition
{
    <#
    .SYNOPSIS
        Creates a new SparkJobDefinition in a specified Microsoft Fabric workspace.

    .DESCRIPTION
        This function sends a POST request to the Microsoft Fabric API to create a new SparkJobDefinition
        in the specified workspace. It supports optional parameters for SparkJobDefinition description and path definitions.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace where the SparkJobDefinition will be created. This parameter is mandatory.

    .PARAMETER SparkJobDefinitionName
        The name of the SparkJobDefinition to be created. This parameter is mandatory.

    .PARAMETER SparkJobDefinitionDescription
        An optional description for the SparkJobDefinition.

    .PARAMETER SparkJobDefinitionPathDefinition
        An optional path to the SparkJobDefinition definition file to upload.

    .PARAMETER SparkJobDefinitionPathPlatformDefinition
        An optional path to the platform-specific definition file to upload.

    .EXAMPLE
        This example creates a new SparkJobDefinition named "New SparkJobDefinition" in the workspace with ID "workspace-12345" with the provided description.

        ```powershell
        New-FabricSparkJobDefinition -WorkspaceId "workspace-12345" -SparkJobDefinitionName "New SparkJobDefinition" -SparkJobDefinitionDescription "Description of the new SparkJobDefinition"
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
        [string]$SparkJobDefinitionName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SparkJobDefinitionDescription,

        [Parameter(Mandatory = $false)]
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
        $apiEndpointUrl = "workspaces/$WorkspaceId/sparkJobDefinitions"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $SparkJobDefinitionName
        }

        if ($SparkJobDefinitionDescription)
        {
            $body.description = $SparkJobDefinitionDescription
        }
        if ($SparkJobDefinitionPathDefinition)
        {
            $SparkJobDefinitionEncodedContent = Convert-ToBase64 -filePath $SparkJobDefinitionPathDefinition

            if (-not [string]::IsNullOrEmpty($SparkJobDefinitionEncodedContent))
            {
                # Initialize definition if it doesn't exist
                if (-not $body.definition)
                {
                    $body.definition = @{
                        format = "SparkJobDefinitionV1"
                        parts  = @()
                    }
                }

                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = "SparkJobDefinitionProperties.json"
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
                # Initialize definition if it doesn't exist
                if (-not $body.definition)
                {
                    $body.definition = @{
                        format = "SparkJobDefinitionV1"
                        parts  = @()
                    }
                }

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

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Create Spark Job Definition")) {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Spark Job Definition '$SparkJobDefinitionName' created successfully!" -Level Info
            return $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create Spark Job Definition. Error: $errorDetails" -Level Error
    }
}
