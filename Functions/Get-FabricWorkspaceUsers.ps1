<#
.SYNOPSIS
Retrieves the users of a workspace.

.DESCRIPTION
The Get-FabricWorkspaceUsers function retrieves the users of a workspace. It supports multiple aliases for flexibility.

.PARAMETER WorkspaceId
The ID of the workspace. This is a mandatory parameter for the 'WorkspaceId' parameter set.

.PARAMETER Workspace
The workspace object. This is a mandatory parameter for the 'WorkspaceObject' parameter set and can be piped into the function.

.EXAMPLE
Get-FabricWorkspaceUsers -WorkspaceId "your-workspace-id"

This example retrieves the users of a workspace given the workspace ID.

.EXAMPLE
$workspace | Get-FabricWorkspaceUsers

This example retrieves the users of a workspace given a workspace object.

.NOTES
The function defines parameters for the workspace ID and workspace object. If the parameter set name is 'WorkspaceId', it retrieves the workspace object. It then makes a GET request to the PowerBI API to retrieve the users of the workspace and returns the 'value' property of the response, which contains the users.
#>

# This function retrieves the users of a workspace.
function Get-FabricWorkspaceUsers {
    # Define aliases for the function for flexibility.
    [Alias("Get-FabWorkspaceUsers")]

    # Define parameters for the workspace ID and workspace object.
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceId')]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceObject', ValueFromPipeline = $true )]
        $Workspace
    )

    process {
        # If the parameter set name is 'WorkspaceId', retrieve the workspace object.
        if ($PSCmdlet.ParameterSetName -eq 'WorkspaceId') {
            $workspace = Get-PowerBIWorkspace -Id $WorkspaceId
        }

        # Make a GET request to the PowerBI API to retrieve the users of the workspace.
        # The function returns the 'value' property of the response, which contains the users.
        return (Invoke-PowerBIRestMethod -Method get -Url ("groups/$($workspace.Id)/users") | ConvertFrom-Json).value
    }

}