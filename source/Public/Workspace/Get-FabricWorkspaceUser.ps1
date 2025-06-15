function Get-FabricWorkspaceUser {
    <#
.SYNOPSIS
Retrieves the user(s) of a workspace.

.DESCRIPTION
The Get-FabricWorkspaceUser function retrieves the details of the users of a workspace.

.PARAMETER WorkspaceId
The ID of the workspace. This is a mandatory parameter if Workspace is not provided.

.PARAMETER Workspace
The workspace object. This normally comes from the Get-FabricWorkspace cmdlet. This is a mandatory parameter if WorkspaceId is not provided.

.EXAMPLE
Get-FabricWorkspaceUser -WorkspaceId '12345678-1234-1234-1234-123456789012

This example retrieves the users of a workspace of the workspace with the ID '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
$workspace = Get-FabricWorkspace -WorkspaceName 'prod-workspace'
$workspace | Get-FabricWorkspaceUser

This example retrieves the users of the prod-workspace workspace by piping the object.

.NOTES
It supports multiple aliases for flexibility.
The function defines parameters for the workspace ID and workspace object. If the parameter set name is 'WorkspaceId', it retrieves the workspace object. It then makes a GET request to the PowerBI API to retrieve the users of the workspace and returns the 'value' property of the response, which contains the users.

Author: Ioana Bouariu

    #>

    # This function retrieves the users of a workspace.
    # Define aliases for the function for flexibility.
    [Alias("Get-FabWorkspaceUsers")]
    [Alias("Get-FabricWorkspaceUsers")]

    # Define parameters for the workspace ID and workspace object.
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceId')]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceObject', ValueFromPipeline = $true )]
        $Workspace
    )

    begin {
        Confirm-TokenState
    }

    process {
        # If the parameter set name is 'WorkspaceObject', retrieve the workspace object.
        if ($PSCmdlet.ParameterSetName -eq 'WorkspaceObject') {
            $WorkspaceId = $Workspace.id
        }

        # Make a GET request to the PowerBI API to retrieve the users of the workspace.
        # The function returns the 'value' property of the response, which contains the users.
        return (Invoke-FabricRestMethod -Method get -PowerBIApi -uri ("groups/$WorkspaceId/users")).value
    }

}
