Function Remove-FabricItem {
<#
.SYNOPSIS
   Removes selected items from a Fabric workspace.

.DESCRIPTION
   The Remove-FabricItem function removes items from a specified Fabric workspace.

   Supply `ItemID` to remove a single item. Otherwise the items in the workspace are listed and
   removed; pass `Filter` to narrow that list to items whose DisplayName matches a wildcard
   pattern. Without a filter, every item in the workspace is removed.

   Each item is confirmed individually, so `-WhatIf` lists precisely what would be removed and
   `-Confirm` prompts per item rather than once for the whole batch.

.PARAMETER WorkspaceID
   The ID of the Fabric workspace. This is a mandatory parameter.

.PARAMETER Filter
   A wildcard pattern matched against each item's DisplayName. Only matching items are removed.
   If omitted, every item in the workspace is removed.

.PARAMETER ItemID
   The ID of a single item to remove.

.EXAMPLE
    Removes every item in the workspace whose DisplayName contains "test".

    ```powershell
    Remove-FabricItem -WorkspaceID "12345678-90ab-cdef-1234-567890abcdef" -Filter "*test*"
    ```

.EXAMPLE
    Removes a single item by ID.

    ```powershell
    Remove-FabricItem -WorkspaceID "12345678-90ab-cdef-1234-567890abcdef" -ItemID "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
    ```

.EXAMPLE
    Lists every item that would be removed from the workspace, without removing anything.

    ```powershell
    Remove-FabricItem -WorkspaceID "12345678-90ab-cdef-1234-567890abcdef" -WhatIf
    ```

.INPUTS
   String. You can pipe a string that contains the workspace ID to Remove-FabricItem.

.OUTPUTS
   None. This function does not return any output.

.NOTES

   Revision History:

   - 2026-08-25 - PBO: Confirm each item individually so the prompt and -WhatIf name the item
     being removed, rather than confirming the whole batch once.

   Author: Rui Romano
   https://github.com/microsoft/Analysis-Services/tree/master/pbidevmode/fabricps-pbip

#>
   [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
   param
   (
      [Parameter(Mandatory = $true)]
      [guid]$WorkspaceId,
      [Parameter(Mandatory = $false)]
      [string]$filter,
      [Parameter(Mandatory = $false)]
      [guid]$itemID
   )

   Confirm-TokenState

   if ($itemID) {
      if ($PSCmdlet.ShouldProcess("item $itemID in workspace $WorkspaceId", 'Remove')) {
         Invoke-FabricRestMethod -Uri "workspaces/$($WorkspaceId)/items/$($itemID)" -Method Delete
      }
      return
   }

   $items = @(Invoke-FabricRestMethod -Uri "workspaces/$WorkspaceId/items" -Method Get)
   Write-Message -Message "Workspace $WorkspaceId contains $($items.Count) item(s)." -Level Verbose

   if ($filter) {
      $items = @($items | Where-Object { $_.DisplayName -like $filter })
      Write-Message -Message "$($items.Count) item(s) match filter '$filter'." -Level Info
   } else {
      Write-Message -Message "No filter specified - removing all $($items.Count) item(s) from workspace $WorkspaceId." -Level Info
   }

   foreach ($item in $items) {
      $target = "'{0}' (id {1}) in workspace {2}" -f $item.displayName, $item.id, $WorkspaceId
      if ($PSCmdlet.ShouldProcess($target, 'Remove')) {
         Invoke-FabricRestMethod -Uri "workspaces/$WorkspaceId/items/$($item.id)" -Method Delete
      }
   }
}
