function Invoke-FabricGitCommit {
    <#
    .SYNOPSIS
        Commits changes from a Fabric workspace to the connected Git branch.

    .DESCRIPTION
        Commits workspace changes to the Git branch the workspace is connected to. Without -Item,
        all changes are committed (mode 'All'). With -Item, only the given items are committed
        (mode 'Selective'). Items can be piped in from Get-FabricGitStatus -ChangesOnly.

        If -WorkspaceHead is not supplied, it is looked up with Get-FabricGitStatus just before
        the commit. Use -NoAutoResolve to turn off this lookup.

    .PARAMETER WorkspaceId
        The ID of the workspace. Accepts pipeline input by property name (alias Id).

    .PARAMETER Comment
        The commit message. Maximum 300 characters.

    .PARAMETER Item
        Items to commit. Each object must have ObjectId and/or LogicalId properties (as returned
        by Get-FabricGitStatus -ChangesOnly), or be a raw change from Get-FabricGitStatus
        (with itemMetadata.itemIdentifier). Accepts pipeline input.

    .PARAMETER WorkspaceHead
        The full SHA hash the workspace is synced to. Looked up automatically when omitted.

    .PARAMETER NoAutoResolve
        Does not look up WorkspaceHead automatically. WorkspaceHead is then sent only if supplied.

    .PARAMETER NoWait
        Returns the long-running operation details instead of waiting for it to finish.

    .EXAMPLE
        Invoke-FabricGitCommit -WorkspaceId '11111111-1111-1111-1111-111111111111' -Comment 'Nightly sync'

        Commits all workspace changes.

    .EXAMPLE
        Get-FabricGitStatus -WorkspaceId '11111111-1111-1111-1111-111111111111' -ChangesOnly | Where-Object ItemType -eq 'Notebook' | Invoke-FabricGitCommit -Comment 'Notebooks only'

        Commits only the changed notebooks.

    .NOTES
        https://learn.microsoft.com/en-us/rest/api/fabric/core/git/commit-to-git

        Requires the workspace Contributor role or higher.

        Author: Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateLength(0, 300)]
        [string]$Comment,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [object[]]$Item,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceHead,

        [Parameter(Mandatory = $false)]
        [switch]$NoAutoResolve,

        [Parameter(Mandatory = $false)]
        [switch]$NoWait
    )

    begin {
        # Items are collected per workspace and committed once in end{}.
        $workspaces = [ordered]@{}
    }

    process {
        $key = $WorkspaceId.ToString()
        if (-not $workspaces.Contains($key)) {
            $workspaces[$key] = [System.Collections.Generic.List[object]]::new()
        }
        foreach ($entry in @($Item)) {
            if ($null -eq $entry) { continue }
            $objectId = $entry.ObjectId
            $logicalId = $entry.LogicalId
            if (-not $objectId -and -not $logicalId -and $entry.itemMetadata) {
                $objectId = $entry.itemMetadata.itemIdentifier.objectId
                $logicalId = $entry.itemMetadata.itemIdentifier.logicalId
            }
            if (-not $objectId -and -not $logicalId) {
                # A piped workspace (or Get-FabricGitStatus summary) only supplies WorkspaceId: commit all.
                if ([string]$entry.id -eq $key -or [string]$entry.WorkspaceId -eq $key) { continue }
                throw "Item '$entry' has no ObjectId or LogicalId."
            }
            $identifier = [ordered]@{}
            if ($objectId) { $identifier.objectId = [string]$objectId }
            if ($logicalId) { $identifier.logicalId = [string]$logicalId }
            $workspaces[$key].Add($identifier)
        }
    }

    end {
        foreach ($key in $workspaces.Keys) {
            $items = $workspaces[$key]
            $mode = if ($items.Count -gt 0) { 'Selective' } else { 'All' }
            $description = if ($mode -eq 'All') { 'all changes' } else { "$($items.Count) item(s)" }

            if (-not $PSCmdlet.ShouldProcess("Workspace '$key'", "Commit $description to Git")) {
                continue
            }

            $head = $WorkspaceHead
            if (-not $head -and -not $NoAutoResolve) {
                Write-Message -Message "Resolving workspace head for workspace '$key'." -Level Verbose
                $head = (Get-FabricGitStatus -WorkspaceId $key).workspaceHead
            }

            $body = [ordered]@{ mode = $mode }
            if ($head) { $body.workspaceHead = $head }
            if ($Comment) { $body.comment = $Comment }
            if ($mode -eq 'Selective') { $body.items = @($items) }

            $apiParams = @{
                Uri              = "workspaces/$key/git/commitToGit"
                Method           = 'Post'
                Body             = ($body | ConvertTo-Json -Depth 5)
                TypeName         = 'Git commit'
                ObjectIdOrName   = $key
                HandleResponse   = $true
                NoWait           = $NoWait
                TestTokenExpired = $true
                SuccessMessage   = "Committed $description of workspace '$key' to Git."
            }
            try {
                Invoke-FabricRestMethod @apiParams
            } catch {
                Write-Message -Message "Commit failed for workspace '$key'. If the workspace head is out of date, run Get-FabricGitStatus and try again." -Level Warning
                throw
            }
        }
    }
}
