<#
.SYNOPSIS
   Retrieves all Fabric workspaces.

.DESCRIPTION
   The Get-FabricWorkspace function retrieves all Fabric workspaces. It invokes the Fabric API to get the workspaces and outputs the result.

.EXAMPLE
   Get-FabricWorkspace

   This command retrieves all Fabric workspaces.

.INPUTS
   None. You cannot pipe inputs to this function.

.OUTPUTS
   Object. This function returns the Fabric workspaces.

.NOTES
   This function was originally written by Rui Romano.
   https://github.com/RuiRomano/fabricps-pbip
#>

Function Get-FabricWorkspace {
   [Alias("Get-FabWorkspace")]
    [CmdletBinding()]
    param
    (
         [Parameter(Mandatory=$false)]
         [string]$workspaceId
    )
    
    # Invoke the Fabric API to get the workspaces
    if ($workspaceId) {
        $result = Invoke-FabricAPIRequest -Uri "workspaces/$($workspaceID)" -Method Get
    } else {
        $result = Invoke-FabricAPIRequest -Uri "workspaces" -Method Get
    }


    # Output the result
    Write-Output $result
}