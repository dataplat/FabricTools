function Initialize-FabricGitConnection {
    <#
    .SYNOPSIS
        Initializes the Git connection of a Fabric workspace.

    .DESCRIPTION
        Initializes the Git connection of a workspace that is already connected to Git (state
        'Connected'). This must be done once after connecting. The result tells you what to do next
        through requiredAction:
        - None: workspace and branch are in sync.
        - UpdateFromGit: run Invoke-FabricGitUpdate with the returned remoteCommitHash.
        - CommitToGit: run Invoke-FabricGitCommit to push the workspace content to the branch.
        Use Connect-FabricGit -Initialize to connect and initialize in one call.

    .PARAMETER WorkspaceId
        The ID of the workspace. Accepts pipeline input by property name (alias Id).

    .PARAMETER InitializationStrategy
        What to do when both the workspace and the Git branch have content.
        None (default), PreferRemote or PreferWorkspace.

    .PARAMETER NoWait
        Returns the long-running operation details instead of waiting for it to finish.

    .OUTPUTS
        System.Management.Automation.PSCustomObject
        Object with requiredAction, workspaceHead, remoteCommitHash and WorkspaceId.

    .EXAMPLE
        Initialize-FabricGitConnection -WorkspaceId '11111111-1111-1111-1111-111111111111' -InitializationStrategy PreferRemote

        Initializes the Git connection, preferring the content of the remote branch.

    .NOTES
        https://learn.microsoft.com/en-us/rest/api/fabric/core/git/initialize-connection

        Requires the workspace Admin role.

        Author: Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'PreferRemote', 'PreferWorkspace')]
        [string]$InitializationStrategy = 'None',

        [Parameter(Mandatory = $false)]
        [switch]$NoWait
    )

    process {
        if (-not $PSCmdlet.ShouldProcess("Workspace '$WorkspaceId'", "Initialize Git connection ($InitializationStrategy)")) {
            return
        }

        $body = @{ initializationStrategy = $InitializationStrategy } | ConvertTo-Json -Depth 5

        $apiParams = @{
            Uri              = "workspaces/$WorkspaceId/git/initializeConnection"
            Method           = 'Post'
            Body             = $body
            TypeName         = 'Git connection'
            ObjectIdOrName   = $WorkspaceId
            HandleResponse   = $true
            NoWait           = $NoWait
            TestTokenExpired = $true
            SuccessMessage   = "Git connection of workspace '$WorkspaceId' initialized."
        }
        $response = Invoke-FabricRestMethod @apiParams

        if ($null -ne $response) {
            if ($response.requiredAction -and $response.requiredAction -ne 'None') {
                Write-Message -Message "Required action for workspace '$WorkspaceId': $($response.requiredAction)." -Level Info
            }
            $response | Add-Member -NotePropertyName 'WorkspaceId' -NotePropertyValue $WorkspaceId -Force -PassThru
        }
    }
}
