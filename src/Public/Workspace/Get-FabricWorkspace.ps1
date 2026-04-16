function Get-FabricWorkspace {
    <#
    .SYNOPSIS
        Retrieves details of a Microsoft Fabric workspace by its ID or name.

    .DESCRIPTION
        The `Get-FabricWorkspace` function fetches workspace details from the Fabric API. It supports filtering by WorkspaceId or WorkspaceName.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace to retrieve.

    .PARAMETER WorkspaceName
        The display name of the workspace to retrieve.

    .EXAMPLE
        Fetches details of the workspace with ID "workspace123".

        ```powershell
        Get-FabricWorkspace -WorkspaceId "workspace123"
        ```

    .EXAMPLE
        Fetches details of the workspace with the name "MyWorkspace".

        ```powershell
        Get-FabricWorkspace -WorkspaceName "MyWorkspace"
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.
        - Returns the matching workspace details or all workspaces if no filter is provided.

        Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceName
    )

    # Handle ambiguous input
    if ($WorkspaceId -and $WorkspaceName) {
        Write-Message -Message "Both 'WorkspaceId' and 'WorkspaceName' were provided. Please specify only one." -Level Error
        return $null
    }

    try
    {

        # Ensure token validity
        Confirm-TokenState

        $apiParams = @{
            Uri            = "workspaces"
            Method         = 'Get'
            TypeName       = 'Workspace'
            ObjectIdOrName = $WorkspaceName
            HandleResponse = $true
            ExtractValue   = 'True'
        }

        $workspaces = @(Invoke-FabricRestMethod @apiParams)

        $workspaces = if ($WorkspaceId) {
            $workspaces | Where-Object { $_.Id -eq $WorkspaceId }
        } elseif ($WorkspaceName) {
            $workspaces | Where-Object { $_.DisplayName -eq $WorkspaceName }
        } else {
            # Return all workspaces if no filter is provided
            Write-Message -Message "No filter provided. Returning all workspaces." -Level Debug
            $workspaces
        }

        # Handle results
        if ($workspaces) {
            Write-Message -Message "Workspace found matching the specified criteria." -Level Debug
            return $workspaces
        } else {
            Write-Message -Message "No workspace found matching the provided criteria." -Level Warning
            return $null
        }

    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve workspace. Error: $errorDetails" -Level Error
    }
}
