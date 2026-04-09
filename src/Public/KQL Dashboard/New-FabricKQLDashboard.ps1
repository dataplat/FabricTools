function New-FabricKQLDashboard
{
<#
.SYNOPSIS
Creates a new KQLDashboard in a specified Microsoft Fabric workspace.

.DESCRIPTION
This function sends a POST request to the Microsoft Fabric API to create a new KQLDashboard
in the specified workspace. It supports optional parameters for KQLDashboard description
and path definitions for the KQLDashboard content.

.PARAMETER WorkspaceId
The unique identifier of the workspace where the KQLDashboard will be created.

.PARAMETER KQLDashboardName
The name of the KQLDashboard to be created.

.PARAMETER KQLDashboardDescription
An optional description for the KQLDashboard.

.PARAMETER KQLDashboardPathDefinition
An optional path to the KQLDashboard definition file (e.g., .ipynb file) to upload.

.PARAMETER KQLDashboardPathPlatformDefinition
An optional path to the platform-specific definition (e.g., .platform file) to upload.

.EXAMPLE
    Creates a new KQLDashboard named "New KQLDashboard" in the workspace with ID "workspace-12345".

    ```powershell
    New-FabricKQLDashboard -WorkspaceId "workspace-12345" -KQLDashboardName "New KQLDashboard"
    ```

.EXAMPLE
    Creates a new KQLDashboard with a definition file and platform definition.

    ```powershell
    New-FabricKQLDashboard -WorkspaceId "workspace-12345" -KQLDashboardName "New KQLDashboard" -KQLDashboardPathDefinition "C:\KQLDashboards\example.ipynb" -KQLDashboardPathPlatformDefinition "C:\KQLDashboards\platform.json"
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
        [string]$KQLDashboardName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLDashboardDescription,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLDashboardPathDefinition,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLDashboardPathPlatformDefinition
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/kqlDashboards" -f $FabricConfig.BaseUrl, $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $KQLDashboardName
        }

        if ($KQLDashboardDescription)
        {
            $body.description = $KQLDashboardDescription
        }

        if ($KQLDashboardPathDefinition)
        {
            $KQLDashboardEncodedContent = Convert-ToBase64 -filePath $KQLDashboardPathDefinition

            if (-not [string]::IsNullOrEmpty($KQLDashboardEncodedContent))
            {
                # Initialize definition if it doesn't exist
                if (-not $body.definition)
                {
                    $body.definition = @{
                        format = "KQLDashboard"
                        parts  = @()
                    }
                }

                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = "RealTimeDashboard.json"
                    payload     = $KQLDashboardEncodedContent
                    payloadType = "InlineBase64"
                }
            }
            else
            {
                Write-Message -Message "Invalid or empty content in KQLDashboard definition." -Level Error
                return $null
            }
        }

        if ($KQLDashboardPathPlatformDefinition)
        {
            $KQLDashboardEncodedPlatformContent = Convert-ToBase64 -filePath $KQLDashboardPathPlatformDefinition

            if (-not [string]::IsNullOrEmpty($KQLDashboardEncodedPlatformContent))
            {
                # Initialize definition if it doesn't exist
                if (-not $body.definition)
                {
                    $body.definition = @{
                        format = $null
                        parts  = @()
                    }
                }

                # Add new part to the parts array
                $body.definition.parts += @{
                    path        = ".platform"
                    payload     = $KQLDashboardEncodedPlatformContent
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

        if ($PSCmdlet.ShouldProcess($KQLDashboardName, "Create KQLDashboard"))
        {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                TypeName       = 'KQL Dashboard'
                ObjectIdOrName = $KQLDashboardName
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
        Write-Message -Message "Failed to create KQLDashboard. Error: $errorDetails" -Level Error
    }
}
