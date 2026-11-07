function Get-FabricGitConnection {
    <#
    .SYNOPSIS
        Gets the Git connection details of a Fabric workspace.

    .DESCRIPTION
        Returns the Git connection state of the specified workspace, the Git provider details
        (provider type, organization or owner, project, repository, branch and directory) and the
        Git sync details (head commit and last sync time). A WorkspaceId property is added to the
        output so it can be piped into the other FabricGit cmdlets.

    .PARAMETER WorkspaceId
        The ID of the workspace. Accepts pipeline input by property name (alias Id), so the output
        of Get-FabricWorkspace can be piped in.

    .OUTPUTS
        System.Management.Automation.PSCustomObject
        Object with gitConnectionState (NotConnected, Connected or ConnectedAndInitialized),
        gitProviderDetails, gitSyncDetails and WorkspaceId.

    .EXAMPLE
        Get-FabricGitConnection -WorkspaceId '11111111-1111-1111-1111-111111111111'

        Returns the Git connection details of the workspace.

    .EXAMPLE
        Get-FabricWorkspace -WorkspaceName 'Sales' | Get-FabricGitConnection

        Returns the Git connection details of the 'Sales' workspace.

    .NOTES
        https://learn.microsoft.com/en-us/rest/api/fabric/core/git/get-connection

        Requires the workspace Admin role.

        Author: Kamil Nowinski
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [guid]$WorkspaceId
    )

    process {
        $apiParams = @{
            Uri              = "workspaces/$WorkspaceId/git/connection"
            Method           = 'Get'
            TypeName         = 'Git connection'
            ObjectIdOrName   = $WorkspaceId
            HandleResponse   = $true
            TestTokenExpired = $true
        }
        $response = Invoke-FabricRestMethod @apiParams

        if ($null -ne $response) {
            $response | Add-Member -NotePropertyName 'WorkspaceId' -NotePropertyValue $WorkspaceId -Force -PassThru
        }
    }
}
