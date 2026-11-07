function Get-FabricGitStatus {
    <#
    .SYNOPSIS
        Gets the Git status of the items in a Fabric workspace.

    .DESCRIPTION
        Returns the Git status of a workspace that is connected to Git: the workspace head, the
        latest remote commit hash and the list of items that changed in the workspace and/or in
        the remote branch, including conflicts.

        By default the full API response is returned with a WorkspaceId property added. With
        -ChangesOnly or -ConflictsOnly, one flattened object per changed item is returned instead
        (WorkspaceId, ItemName, ItemType, ObjectId, LogicalId, WorkspaceChange, RemoteChange,
        ConflictType). These objects can be piped into Invoke-FabricGitCommit to commit selected
        items only.

    .PARAMETER WorkspaceId
        The ID of the workspace. Accepts pipeline input by property name (alias Id).

    .PARAMETER ChangesOnly
        Returns one flattened object per changed item instead of the full response.

    .PARAMETER ConflictsOnly
        Like -ChangesOnly, but returns only items with a conflict.

    .PARAMETER NoWait
        Returns the long-running operation details instead of waiting for it to finish.

    .OUTPUTS
        System.Management.Automation.PSCustomObject

    .EXAMPLE
        Get-FabricGitStatus -WorkspaceId '11111111-1111-1111-1111-111111111111'

        Returns workspaceHead, remoteCommitHash and changes of the workspace.

    .EXAMPLE
        Get-FabricGitStatus -WorkspaceId '11111111-1111-1111-1111-111111111111' -ChangesOnly | Format-Table ItemName, ItemType, WorkspaceChange, RemoteChange

        Lists the changed items as a table.

    .EXAMPLE
        Get-FabricWorkspace -WorkspaceName 'Sales' | Get-FabricGitStatus -ConflictsOnly

        Lists the items in conflict in the 'Sales' workspace.

    .NOTES
        https://learn.microsoft.com/en-us/rest/api/fabric/core/git/get-status

        Requires the workspace Contributor role or higher.

        Author: Kamil Nowinski
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ChangesOnly')]
        [switch]$ChangesOnly,

        [Parameter(Mandatory = $true, ParameterSetName = 'ConflictsOnly')]
        [switch]$ConflictsOnly,

        [Parameter(Mandatory = $false)]
        [switch]$NoWait
    )

    process {
        $apiParams = @{
            Uri              = "workspaces/$WorkspaceId/git/status"
            Method           = 'Get'
            TypeName         = 'Git status'
            ObjectIdOrName   = $WorkspaceId
            HandleResponse   = $true
            NoWait           = $NoWait
            TestTokenExpired = $true
        }
        $response = Invoke-FabricRestMethod @apiParams

        if ($null -eq $response) {
            return
        }

        # With -NoWait an LRO descriptor may be returned instead of the status.
        $isStatus = $null -ne $response.PSObject.Properties['changes']
        if (-not ($ChangesOnly -or $ConflictsOnly) -or -not $isStatus) {
            return $response | Add-Member -NotePropertyName 'WorkspaceId' -NotePropertyValue $WorkspaceId -Force -PassThru
        }

        foreach ($change in @($response.changes)) {
            if ($null -eq $change) { continue }
            if ($ConflictsOnly -and ([string]::IsNullOrEmpty($change.conflictType) -or $change.conflictType -eq 'None')) {
                continue
            }
            $metadata = $change.itemMetadata
            [PSCustomObject]@{
                WorkspaceId     = $WorkspaceId
                ItemName        = $metadata.displayName
                ItemType        = $metadata.itemType
                ObjectId        = $metadata.itemIdentifier.objectId
                LogicalId       = $metadata.itemIdentifier.logicalId
                WorkspaceChange = $change.workspaceChange
                RemoteChange    = $change.remoteChange
                ConflictType    = $change.conflictType
            }
        }
    }
}
