function New-FabricWorkspace
{
    <#
.SYNOPSIS
Creates a new Fabric workspace with the specified display name.

.DESCRIPTION
The `New-FabricWorkspace` function creates a new workspace in the Fabric platform by sending a POST request to the API. It validates the display name and handles both success and error responses.

.PARAMETER WorkspaceName
The display name of the workspace to be created. Must only contain alphanumeric characters, spaces, and underscores.

.PARAMETER WorkspaceDescription
(Optional) A description for the workspace. This parameter is optional.

.PARAMETER CapacityId
(Optional) The ID of the capacity to be associated with the workspace. This parameter is optional.

.EXAMPLE
    Creates a workspace named "NewWorkspace".

    ```powershell
    New-FabricWorkspace -WorkspaceName "NewWorkspace"
    ```

.NOTES
- Requires `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceDescription,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$CapacityId
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces"
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $WorkspaceName
        }

        if ($WorkspaceDescription)
        {
            $body.description = $WorkspaceDescription
        }

        if ($CapacityId)
        {
            $body.capacityId = $CapacityId
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json -Depth 2
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Create Workspace"))
        {

            # Make the API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams

            Write-Message -Message "Workspace '$WorkspaceName' created successfully!" -Level Info
            return $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create workspace. Error: $errorDetails" -Level Error

    }
}
