<#
.SYNOPSIS
   Removes selected items from a Fabric workspace.

.DESCRIPTION
   The Remove-FabricItems function removes selected items from a specified Fabric workspace. It uses the workspace ID and an optional filter to select the items to remove. If a filter is provided, only items whose DisplayName matches the filter are removed.

.PARAMETER WorkspaceID
   The ID of the Fabric workspace. This is a mandatory parameter.

.PARAMETER Filter
   An optional filter to select items to remove. If provided, only items whose DisplayName matches the filter are removed.

.EXAMPLE
   Remove-FabricItems -WorkspaceID "12345678-90ab-cdef-1234-567890abcdef" -Filter "*test*"

   This command removes all items from the workspace with the specified ID whose DisplayName includes "test".

.INPUTS
   String. You can pipe two strings that contain the workspace ID and filter to Remove-FabricItems.

.OUTPUTS
   None. This function does not return any output.

.NOTES
   This function was written by Rui Romano.
   https://github.com/RuiRomano/fabricps-pbip
#>

Function Remove-FabricItem {
   [CmdletBinding(SupportsShouldProcess)]
   param
   (
      [Parameter(Mandatory = $true)]
      [string]$workspaceId,
      [Parameter(Mandatory = $false)]
      [string]$filter,
      [Parameter(Mandatory = $false)]
      [string]$itemID
   )

   # Check if the Fabric headers are already set


   # Invoke the Fabric API to get the items in the workspace
   if ($PSCmdlet.ShouldProcess("Remove items from workspace $workspaceId")) {
      if ($itemID) {
         Invoke-FabricAPIRequest -Uri "workspaces/$($workspaceID)/items/$($itemID)" -Method Delete
      } else {
         $items = Invoke-FabricAPIRequest -Uri "workspaces/$workspaceId/items" -Method Get

         # Display the count of existing items
         Write-Output "Existing items: $($items.Count)"

         # If a filter is provided
         if ($filter) {
            # Filter the items whose DisplayName matches the filter
            $items = $items | Where-Object { $_.DisplayName -like $filter }
         }

         # For each item
         foreach ($item in $items) {
            # Remove the item
            Invoke-FabricAPIRequest -Uri "workspaces/$workspaceId/items/$($item.ID)" -Method Delete
         }
      }
   }
}