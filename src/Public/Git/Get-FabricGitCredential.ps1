function Get-FabricGitCredential {
    <#
    .SYNOPSIS
        Gets the Git credentials configuration of the current user for a Fabric workspace.

    .DESCRIPTION
        Returns how the calling user (or service principal) authenticates to Git in the
        specified workspace: source Automatic, ConfiguredConnection (with connectionId) or None.
        A WorkspaceId property is added to the output.

    .PARAMETER WorkspaceId
        The ID of the workspace. Accepts pipeline input by property name (alias Id).

    .OUTPUTS
        System.Management.Automation.PSCustomObject
        Object with source, connectionId (when source is ConfiguredConnection) and WorkspaceId.

    .EXAMPLE
        Get-FabricGitCredential -WorkspaceId '11111111-1111-1111-1111-111111111111'

        Returns the current user's Git credentials configuration for the workspace.

    .NOTES
        https://learn.microsoft.com/en-us/rest/api/fabric/core/git/get-my-git-credentials

        Requires the workspace Contributor role or higher.

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
            Uri              = "workspaces/$WorkspaceId/git/myGitCredentials"
            Method           = 'Get'
            TypeName         = 'Git credentials'
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
