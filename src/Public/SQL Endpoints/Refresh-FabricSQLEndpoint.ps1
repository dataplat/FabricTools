function Refresh-FabricSQLEndpoint {
    <#
    .SYNOPSIS
        Refreshes the metadata of a SQL analytics endpoint.

    .DESCRIPTION
        Starts a refresh of the metadata for a SQL analytics endpoint in a specified workspace.
        By default, the function waits for the long-running operation to complete.

    .PARAMETER WorkspaceId
        The ID of the workspace containing the SQL analytics endpoint.

    .PARAMETER SQLEndpointId
        The ID of the SQL analytics endpoint to refresh.

    .PARAMETER Timeout
        The maximum time, in minutes, to wait for the refresh operation. A value of 0 waits indefinitely.

    .PARAMETER NoWait
        If specified, returns immediately after the refresh request is accepted.

    .EXAMPLE
        ```powershell
        Refresh-FabricSQLEndpoint -WorkspaceId $workspaceId -SQLEndpointId $sqlEndpointId
        ```

    .NOTES
        Author: Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$SQLEndpointId,

        [Parameter(Mandatory = $false)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$Timeout = 15,

        [Parameter(Mandatory = $false)]
        [switch]$NoWait = $false
    )

    try {
        Confirm-TokenState

        $apiEndpointUrl = "workspaces/$WorkspaceId/sqlEndpoints/$SQLEndpointId/refreshMetadata"
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($SQLEndpointId, 'Refresh SQL endpoint metadata')) {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                TypeName       = 'SQL Endpoint'
                ObjectIdOrName = $SQLEndpointId
                Timeout        = $Timeout
                NoWait         = $NoWait
                HandleResponse = $true
            }
            Invoke-FabricRestMethod @apiParams
        }
    } catch {
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to refresh SQL endpoint metadata. Error: $errorDetails" -Level Error
    }
}
