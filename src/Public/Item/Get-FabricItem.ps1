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
    This example retrieves all fabric items of type "file" from the workspace with ID "12345".

    ```powershell
    Get-FabricItem -workspaceId "12345" -type "file"
    ```

.NOTES

Author: Rui Romano

    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceId')]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceObject', ValueFromPipeline = $true )]
        $Workspace,

        [Parameter(Mandatory = $false)]
        [Alias("itemType")]
        [string]$type,

        [Parameter(Mandatory = $false)]
        [Alias('Id')]
        [guid]$itemID
    )

    begin {
        Confirm-TokenState
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'WorkspaceObject') {
            $workspaceID = $Workspace.id
        }
        $apiParams = @{
            Method         = 'Get'
            TypeName       = 'Item'
            HandleResponse = $true
        }
        if ($itemID) {
            # Single item: the response is the item object itself
            $apiParams.Uri = "workspaces/$($workspaceID)/items/$($itemID)"
            $apiParams.ObjectIdOrName = $itemID
            return Invoke-FabricRestMethod @apiParams
        }

        if ($type) {
            $apiParams.Uri = "workspaces/$($workspaceID)/items?type=$type"
        } else {
            $apiParams.Uri = "workspaces/$($workspaceID)/items"
        }
        $apiParams.ExtractValue = 'True'
        Invoke-FabricRestMethod @apiParams
    }
}
