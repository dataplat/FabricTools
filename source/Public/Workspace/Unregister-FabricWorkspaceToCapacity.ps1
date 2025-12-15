function Unregister-FabricWorkspaceToCapacity {
    <#
    .SYNOPSIS
        Unregisters a workspace from a capacity.

    .DESCRIPTION
        The Unregister-FabricWorkspaceToCapacity function unregisters a workspace from a capacity in PowerBI. It can be used to remove a workspace from a capacity, allowing it to be assigned to a different capacity or remain unassigned.

    .PARAMETER WorkspaceId
        Specifies the ID of the workspace to be unregistered from the capacity. This parameter is mandatory when using the 'WorkspaceId' parameter set.

    .PARAMETER Workspace
        Specifies the workspace object to be unregistered from the capacity. This parameter is mandatory when using the 'WorkspaceObject' parameter set. The workspace object can be piped into the function.

    .EXAMPLE
        Unregisters the workspace with ID "12345678" from the capacity.

        ```powershell
        Unregister-FabricWorkspaceToCapacity -WorkspaceId "12345678"
        ```

    .EXAMPLE
        Unregisters the workspace objects piped from Get-FabricWorkspace from the capacity. .INPUTS System.Management.Automation.PSCustomObject

        ```powershell
        Get-FabricWorkspace | Unregister-FabricWorkspaceToCapacity
        ```

    .OUTPUTS
        System.Object

    .NOTES
        Author: Ioana Bouariu
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceId')]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceObject', ValueFromPipeline = $true)]
        $Workspace
    )

    begin {
        Confirm-TokenState
    }

    Process {
        if ($PSCmdlet.ParameterSetName -eq 'WorkspaceObject') {
            $workspaceid = $workspace.id
        }

        if ($PSCmdlet.ShouldProcess("Unassigns workspace $workspaceid from a capacity")) {
            Invoke-FabricRestMethod -Uri "workspaces/$workspaceid/unassignFromCapacity" -Method POST
        }
    }
}
