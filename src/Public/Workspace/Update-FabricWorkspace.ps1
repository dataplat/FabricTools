function Update-FabricWorkspace
{
    <#
    .SYNOPSIS
        Updates the properties of a Fabric workspace.

    .DESCRIPTION
        The `Update-FabricWorkspace` function updates the name and/or description of a specified Fabric workspace by making a PATCH request to the API.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace to be updated.

    .PARAMETER WorkspaceName
        The new name for the workspace.

    .PARAMETER WorkspaceDescription
        (Optional) The new description for the workspace.

    .EXAMPLE
        Updates the name of the workspace with the ID "workspace123" to "NewWorkspaceName".

        ```powershell
        Update-FabricWorkspace -WorkspaceId "workspace123" -WorkspaceName "NewWorkspaceName"
        ```

    .EXAMPLE
        Updates both the name and description of the workspace "workspace123".

        ```powershell
        Update-FabricWorkspace -WorkspaceId "workspace123" -WorkspaceName "NewName" -WorkspaceDescription "Updated description"
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.

        Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceDescription
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $WorkspaceName
        }

        if ($WorkspaceDescription)
        {
            $body.description = $WorkspaceDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Update Workspace"))
        {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Patch'
                Body           = $bodyJson
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Workspace '$WorkspaceName' updated successfully!" -Level Info
            return $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update workspace. Error: $errorDetails" -Level Error
    }
}
