<#
.SYNOPSIS
Retrieves fabric items from a workspace.

.DESCRIPTION
The Get-FabricItem function retrieves fabric items from a specified workspace. It can retrieve all items or filter them by item type.

.PARAMETER workspaceId
The ID of the workspace from which to retrieve the fabric items.

.PARAMETER type
(Optional) The type of the fabric items to retrieve. If not specified, all items will be retrieved.

.EXAMPLE
Get-FabricItem -workspaceId "12345" -type "file"

This example retrieves all fabric items of type "file" from the workspace with ID "12345".

.NOTES
This function was originally written by Rui Romano.
https://github.com/RuiRomano/fabricps-pbip

#>

Function Get-FabricItem {
    [CmdletBinding()]
    param
    (
         [Parameter(Mandatory=$true)]
         [string]$workspaceId,
         [Parameter(Mandatory=$false)]
         [string]$type,
         [Parameter(Mandatory=$false)]
         [string]$itemID
      )

      if ($itemID) {
        $result = Invoke-FabricAPIRequest -Uri "workspaces/$($workspaceID)/items/$($itemID)" -Method Get
      } else {
   if ($type) {

        $result = Invoke-FabricAPIRequest -Uri "workspaces/$($workspaceID)/items?type=$type" -Method Get

    } else {
    # Invoke the Fabric API to get the workspaces
    $result = Invoke-FabricAPIRequest -Uri "workspaces/$($workspaceID)/items" -Method Get
    }
    # Output the result
    Write-Output $result
}
}