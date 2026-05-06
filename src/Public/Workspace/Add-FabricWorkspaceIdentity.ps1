function Add-FabricWorkspaceIdentity {
    <#
    .SYNOPSIS
        Provisions an identity for a Fabric workspace.

    .DESCRIPTION
        The `Add-FabricWorkspaceIdentity` function provisions an identity for a specified workspace by making an API call.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace for which the identity will be provisioned.

    .EXAMPLE
        Provisions a Managed Identity for the workspace with ID "workspace123".

        ```powershell
        Add-FabricWorkspaceIdentity -WorkspaceId "workspace123"
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.

        Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [guid]$WorkspaceId
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/provisionIdentity"
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Make the API request
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams

        Write-Message -Message "Workspace identity was successfully provisioned for workspace '$WorkspaceId'." -Level Info
        return $response
    } catch {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to provision workspace identity. Error: $errorDetails" -Level Error
    }
}
