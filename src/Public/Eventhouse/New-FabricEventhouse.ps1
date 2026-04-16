function New-FabricEventhouse
{

    <#
    .SYNOPSIS
        Creates a new Eventhouse in a specified Microsoft Fabric workspace.

    .DESCRIPTION
        This function sends a POST request to the Microsoft Fabric API to create a new Eventhouse
        in the specified workspace. It supports optional parameters for Eventhouse description and path definitions.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace where the Eventhouse will be created. This parameter is mandatory.

    .PARAMETER EventhouseName
        The name of the Eventhouse to be created. This parameter is mandatory.

    .PARAMETER EventhouseDescription
        An optional description for the Eventhouse.

    .PARAMETER EventhousePathDefinition
        An optional path to the Eventhouse definition file to upload.

    .PARAMETER EventhousePathPlatformDefinition
        An optional path to the platform-specific definition file to upload.

    .EXAMPLE
    This example creates a new Eventhouse named "New Eventhouse" in the workspace with ID "workspace-12345" with the provided description.

    ```powershell
    New-FabricEventhouse -WorkspaceId "workspace-12345" -EventhouseName "New Eventhouse" -EventhouseDescription "Description of the new Eventhouse"
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
        [string]$EventhouseName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EventhouseDescription,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EventhousePathDefinition,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EventhousePathPlatformDefinition
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/eventhouses" -f $FabricConfig.BaseUrl, $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        $body = @{
            displayName = $EventhouseName
        }

        if ($EventhouseDescription)
        {
            $body.description = $EventhouseDescription
        }

        if ($EventhousePathDefinition)
        {
            $eventhouseEncodedContent = Convert-ToBase64 -filePath $EventhousePathDefinition

            if (-not [string]::IsNullOrEmpty($eventhouseEncodedContent))
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
                    path        = "EventhouseProperties.json"
                    payload     = $eventhouseEncodedContent
                    payloadType = "InlineBase64"
                }
            }
            else
            {
                Write-Message -Message "Invalid or empty content in Eventhouse definition." -Level Error
                return $null
            }
        }

        if ($EventhousePathPlatformDefinition)
        {
            $eventhouseEncodedPlatformContent = Convert-ToBase64 -filePath $EventhousePathPlatformDefinition

            if (-not [string]::IsNullOrEmpty($eventhouseEncodedPlatformContent))
            {
                if (-not $body.definition)
                {
                    $body.definition = @{ parts = @() }
                }
                $body.definition.parts += @{
                    path        = ".platform"
                    payload     = $eventhouseEncodedPlatformContent
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

        if ($PSCmdlet.ShouldProcess($EventhouseName, "Create Eventhouse"))
        {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                TypeName       = 'Eventhouse'
                ObjectIdOrName = $EventhouseName
                HandleResponse = $true
            }

            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Eventhouse '$EventhouseName' created successfully!" -Level Info
        }
        $response
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create Eventhouse. Error: $errorDetails" -Level Error
    }
}
