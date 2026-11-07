function Update-FabricGitCredential {
    <#
    .SYNOPSIS
        Updates the Git credentials configuration of the current user for a Fabric workspace.

    .DESCRIPTION
        Sets how the calling user (or service principal) authenticates to Git in the specified
        workspace. Exactly one of the following is used:
        -Automatic          source 'Automatic' (Azure DevOps with the caller's identity)
        -ConnectionId <id>  source 'ConfiguredConnection' using a configured Fabric connection
        -None               source 'None' (removes the credentials configuration)

    .PARAMETER WorkspaceId
        The ID of the workspace. Accepts pipeline input by property name (alias Id).

    .PARAMETER Automatic
        Use automatic credentials.

    .PARAMETER ConnectionId
        The ID of a configured Fabric connection holding the Git credentials.

    .PARAMETER None
        Remove the Git credentials configuration.

    .OUTPUTS
        System.Management.Automation.PSCustomObject
        The updated credentials configuration with WorkspaceId added.

    .EXAMPLE
        Update-FabricGitCredential -WorkspaceId '11111111-1111-1111-1111-111111111111' -ConnectionId '22222222-2222-2222-2222-222222222222'

        Uses the configured connection for Git operations in the workspace.

    .EXAMPLE
        Update-FabricGitCredential -WorkspaceId '11111111-1111-1111-1111-111111111111' -Automatic

        Uses automatic credentials for Git operations in the workspace.

    .NOTES
        https://learn.microsoft.com/en-us/rest/api/fabric/core/git/update-my-git-credentials

        Requires the workspace Contributor role or higher.

        Author: Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ConfiguredConnection')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'Automatic')]
        [switch]$Automatic,

        [Parameter(Mandatory = $true, ParameterSetName = 'ConfiguredConnection')]
        [ValidateNotNullOrEmpty()]
        [guid]$ConnectionId,

        [Parameter(Mandatory = $true, ParameterSetName = 'None')]
        [switch]$None
    )

    process {
        $body = switch ($PSCmdlet.ParameterSetName) {
            'Automatic' { [ordered]@{ source = 'Automatic' } }
            'ConfiguredConnection' { [ordered]@{ source = 'ConfiguredConnection'; connectionId = $ConnectionId.ToString() } }
            'None' { [ordered]@{ source = 'None' } }
        }

        if (-not $PSCmdlet.ShouldProcess("Workspace '$WorkspaceId'", "Set Git credentials source to '$($body.source)'")) {
            return
        }

        $apiParams = @{
            Uri              = "workspaces/$WorkspaceId/git/myGitCredentials"
            Method           = 'Patch'
            Body             = ($body | ConvertTo-Json -Depth 5)
            TypeName         = 'Git credentials'
            ObjectIdOrName   = $WorkspaceId
            HandleResponse   = $true
            TestTokenExpired = $true
            SuccessMessage   = "Git credentials source of workspace '$WorkspaceId' set to '$($body.source)'."
        }
        $response = Invoke-FabricRestMethod @apiParams

        if ($null -ne $response) {
            $response | Add-Member -NotePropertyName 'WorkspaceId' -NotePropertyValue $WorkspaceId -Force -PassThru
        }
    }
}
