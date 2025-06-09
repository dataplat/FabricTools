function Get-FabricItem {
    <#
.SYNOPSIS
Retrieves fabric items from a workspace.

.DESCRIPTION
The Get-FabricItem function retrieves fabric items from a specified workspace. It can retrieve all items or filter them by item type.

.PARAMETER workspaceId
The ID of the workspace from which to retrieve the fabric items.

.PARAMETER Workspace
The workspace object from which to retrieve the fabric items. This parameter can be piped into the function.

.PARAMETER itemID
The ID of the specific item to retrieve. If not specified, all items will be retrieved.

.PARAMETER type
(Optional) The type of the fabric items to retrieve. If not specified, all items will be retrieved.

.EXAMPLE
Get-FabricItem -workspaceId "12345" -type "file"

This example retrieves all fabric items of type "file" from the workspace with ID "12345".

.NOTES
This function was originally written by Rui Romano.
https://github.com/microsoft/Analysis-Services/tree/master/pbidevmode/fabricps-pbip

    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceId')]
        [string]$workspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceObject', ValueFromPipeline = $true )]
        $Workspace,

        [Parameter(Mandatory = $false)]
        [Alias("itemType")]
        [string]$type,

        [Parameter(Mandatory = $false)]
        [string]$itemID
    )

    begin {
        Confirm-TokenState
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'WorkspaceObject') {
            $workspaceID = $Workspace.id
        }
        if ($itemID) {
            $result = Invoke-FabricRestMethod -Uri "workspaces/$($workspaceID)/items/$($itemID)" -Method Get
        } else {
            if ($type) {
                $result = Invoke-FabricRestMethod -Uri "workspaces/$($workspaceID)/items?type=$type" -Method Get
            } else {
                # Invoke the Fabric API to get the workspaces
                $result = Invoke-FabricRestMethod -Uri "workspaces/$($workspaceID)/items" -Method Get
            }
            # Output the result
            return $result.value
        }
    }
}
