<#
.SYNOPSIS
Removes a workspace.

.DESCRIPTION
The Remove-FabricWorkspace function removes a workspace. It supports multiple aliases for flexibility.

.PARAMETER groupID
The ID of the group (workspace). This is a mandatory parameter.

.EXAMPLE
Remove-FabricWorkspace -groupID "your-group-id"

This example removes a workspace given the group ID.

.NOTES
The function retrieves the PowerBI access token and makes a DELETE request to the PowerBI API to remove the workspace.
#>

# This function removes a workspace.
function Remove-FabricWorkspace {
    [CmdletBinding(SupportsShouldProcess)]
    # Define aliases for the function for flexibility.
    [Alias("Remove-FabWorkspace")]

    # Define a parameter for the group ID.
    Param (
        [Parameter(Mandatory = $true)]
        [string]$workspaceID
    )

    # Make a DELETE request to the PowerBI API to remove the workspace.
    if ($PSCmdlet.ShouldProcess("Remove workspace $workspaceID")) {
        return Invoke-FabricAPIRequest -Uri "workspaces/$workspaceID"  -Method Delete
    }
}