function Disconnect-FabricGit {
    <#
    .SYNOPSIS
        Disconnects a Fabric workspace from its Git repository.

    .DESCRIPTION
        Disconnects the specified workspace from the Git repository and branch it is connected to.
        Workspace items are not deleted, but the link to source control is removed. Because this
        affects every user of the workspace, the cmdlet asks for confirmation by default; use
        -Confirm:$false to skip the prompt.

    .PARAMETER WorkspaceId
        The ID of the workspace to disconnect. Accepts pipeline input by property name (alias Id).

    .EXAMPLE
        Disconnect-FabricGit -WorkspaceId '11111111-1111-1111-1111-111111111111'

        Disconnects the workspace from Git after confirmation.

    .EXAMPLE
        Get-FabricWorkspace -WorkspaceName 'Sales' | Disconnect-FabricGit -Confirm:$false

        Disconnects the 'Sales' workspace from Git without prompting.

    .NOTES
        https://learn.microsoft.com/en-us/rest/api/fabric/core/git/disconnect

        Requires the workspace Admin role.

        Author: Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [guid]$WorkspaceId
    )

    process {
        if (-not $PSCmdlet.ShouldProcess("Workspace '$WorkspaceId'", 'Disconnect from Git')) {
            return
        }

        $apiParams = @{
            Uri              = "workspaces/$WorkspaceId/git/disconnect"
            Method           = 'Post'
            TypeName         = 'Git connection'
            ObjectIdOrName   = $WorkspaceId
            HandleResponse   = $true
            TestTokenExpired = $true
            SuccessMessage   = "Workspace '$WorkspaceId' disconnected from Git."
        }
        $null = Invoke-FabricRestMethod @apiParams
    }
}
