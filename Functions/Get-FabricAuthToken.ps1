<#
.SYNOPSIS
   Retrieves the Fabric API authentication token.

.DESCRIPTION
   The Get-FabricAuthToken function retrieves the Fabric API authentication token. If the token is not already set, it calls the Set-FabricAuthToken function to set it. It then outputs the token.

.EXAMPLE
   Get-FabricAuthToken

   This command retrieves the Fabric API authentication token.

.INPUTS
   None. You cannot pipe inputs to this function.

.OUTPUTS
   String. This function returns the Fabric API authentication token.

.NOTES
   This function was originally written by Rui Romano.
   https://github.com/RuiRomano/fabricps-pbip
#>

function Get-FabricAuthToken {
   [Alias("Get-FabAuthToken")]
   [CmdletBinding()]
   param
   (
   )

   # Check if the Fabric token is already set
   if (!$script:fabricToken) {
      # If not, set the Fabric token
      Set-FabricAuthToken
   }

   # Output the Fabric token
   Write-Output $script:fabricToken
}