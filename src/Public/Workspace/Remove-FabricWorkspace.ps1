function Remove-FabricWorkspace {
    <#
    .SYNOPSIS
        Deletes an existing Fabric workspace by its workspace ID or name.

    .DESCRIPTION
        The `Remove-FabricWorkspace` function deletes a workspace in the Fabric platform by sending a DELETE request to the API. When a name is provided, exactly one accessible workspace must match. If no workspace or multiple workspaces match, no deletion is performed.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace to be deleted.

    .PARAMETER WorkspaceName
        The exact display name of the workspace to be deleted. Supports the alias Name. Use WorkspaceId if the name is ambiguous.

    .EXAMPLE
        Deletes the workspace with the ID "workspace123".

        ```powershell
        Remove-FabricWorkspace -WorkspaceId "workspace123"
        ```

    .EXAMPLE
        Deletes the workspace with the exact name "MyImportantFabricWorkspace".

        ```powershell
        Remove-FabricWorkspace -Name "MyImportantFabricWorkspace"
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.

        Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'ById')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ById', Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [Alias("Name")]
        [string]$WorkspaceName
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        if ($PSCmdlet.ParameterSetName -eq 'ByName') {
            $workspaces = @(Get-FabricWorkspace -WorkspaceName $WorkspaceName | Where-Object { $null -ne $_ })
            if ($workspaces.Count -eq 0) {
                Write-Message -Message "No workspace found with the name '$WorkspaceName'. No workspace was deleted." -Level Error
                return $null
            }
            if ($workspaces.Count -gt 1) {
                Write-Message -Message "Multiple workspaces found with the name '$WorkspaceName'. Specify WorkspaceId instead. No workspace was deleted." -Level Error
                return $null
            }
            $WorkspaceId = [guid]$workspaces[0].Id
            if ($WorkspaceId -eq [guid]::Empty) {
                throw "The workspace '$WorkspaceName' has no valid workspace ID."
            }
        }

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Delete Workspace"))
        {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Delete'
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Workspace '$WorkspaceId' deleted successfully!" -Level Info
            return $null
        }

    }
    catch
    {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete workspace. Error: $errorDetails" -Level Error
        return $null
    }
}
