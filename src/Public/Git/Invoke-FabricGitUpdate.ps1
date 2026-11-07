function Invoke-FabricGitUpdate {
    <#
    .SYNOPSIS
        Updates a Fabric workspace with the latest commits from the connected Git branch.

    .DESCRIPTION
        Updates the workspace with commits pushed to the connected branch. Workspace items may be
        overwritten, so the cmdlet asks for confirmation by default; use -Confirm:$false to skip
        the prompt.

        If -RemoteCommitHash or -WorkspaceHead are not supplied, they are looked up with
        Get-FabricGitStatus just before the update. Use -NoAutoResolve to turn off this lookup;
        -RemoteCommitHash is then required.

    .PARAMETER WorkspaceId
        The ID of the workspace. Accepts pipeline input by property name (alias Id).

    .PARAMETER RemoteCommitHash
        The full SHA hash of the remote commit to update to. Looked up automatically when omitted.

    .PARAMETER WorkspaceHead
        The full SHA hash the workspace is synced to. Looked up automatically when omitted.

    .PARAMETER ConflictResolutionPolicy
        How to resolve conflicts: PreferRemote or PreferWorkspace. When omitted, the update fails
        if there are conflicts.

    .PARAMETER AllowOverrideItems
        Allows the update to override incoming items that conflict with workspace items.

    .PARAMETER NoAutoResolve
        Does not look up RemoteCommitHash and WorkspaceHead automatically.

    .PARAMETER NoWait
        Returns the long-running operation details instead of waiting for it to finish.

    .EXAMPLE
        Invoke-FabricGitUpdate -WorkspaceId '11111111-1111-1111-1111-111111111111' -Confirm:$false

        Updates the workspace to the latest remote commit without prompting.

    .EXAMPLE
        Invoke-FabricGitUpdate -WorkspaceId '11111111-1111-1111-1111-111111111111' -ConflictResolutionPolicy PreferRemote -AllowOverrideItems

        Updates the workspace and resolves conflicts in favour of the remote branch.

    .NOTES
        https://learn.microsoft.com/en-us/rest/api/fabric/core/git/update-from-git

        Requires the workspace Contributor role or higher.

        Author: Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$RemoteCommitHash,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceHead,

        [Parameter(Mandatory = $false)]
        [ValidateSet('PreferRemote', 'PreferWorkspace')]
        [string]$ConflictResolutionPolicy,

        [Parameter(Mandatory = $false)]
        [switch]$AllowOverrideItems,

        [Parameter(Mandatory = $false)]
        [switch]$NoAutoResolve,

        [Parameter(Mandatory = $false)]
        [switch]$NoWait
    )

    process {
        if ($NoAutoResolve -and -not $RemoteCommitHash) {
            throw '-RemoteCommitHash is required when -NoAutoResolve is used.'
        }

        if (-not $PSCmdlet.ShouldProcess("Workspace '$WorkspaceId'", 'Update from Git')) {
            return
        }

        $remoteHash = $RemoteCommitHash
        $head = $WorkspaceHead
        if (-not $NoAutoResolve -and (-not $remoteHash -or -not $head)) {
            Write-Message -Message "Resolving Git heads for workspace '$WorkspaceId'." -Level Verbose
            $status = Get-FabricGitStatus -WorkspaceId $WorkspaceId
            if (-not $remoteHash) { $remoteHash = $status.remoteCommitHash }
            if (-not $head) { $head = $status.workspaceHead }
        }
        if (-not $remoteHash) {
            throw "Could not determine the remote commit hash for workspace '$WorkspaceId'."
        }

        $body = [ordered]@{ remoteCommitHash = $remoteHash }
        if ($head) { $body.workspaceHead = $head }
        if ($ConflictResolutionPolicy) {
            $body.conflictResolution = [ordered]@{
                conflictResolutionType   = 'Workspace'
                conflictResolutionPolicy = $ConflictResolutionPolicy
            }
        }
        if ($AllowOverrideItems) {
            $body.options = [ordered]@{ allowOverrideItems = $true }
        }

        $apiParams = @{
            Uri              = "workspaces/$WorkspaceId/git/updateFromGit"
            Method           = 'Post'
            Body             = ($body | ConvertTo-Json -Depth 5)
            TypeName         = 'Git update'
            ObjectIdOrName   = $WorkspaceId
            HandleResponse   = $true
            NoWait           = $NoWait
            TestTokenExpired = $true
            SuccessMessage   = "Workspace '$WorkspaceId' updated from Git to commit '$remoteHash'."
        }
        try {
            Invoke-FabricRestMethod @apiParams
        } catch {
            Write-Message -Message "Update from Git failed for workspace '$WorkspaceId'. If the heads are out of date, run Get-FabricGitStatus and try again; use -ConflictResolutionPolicy to resolve conflicts." -Level Warning
            throw
        }
    }
}
