<#
.SYNOPSIS
   Retrieves the Fabric API authentication token.

.DESCRIPTION
   The Get-FabricAuthToken function retrieves the Fabric API authentication token.
   If the token is not already set, the function fails.

.EXAMPLE
   Get-FabricAuthToken

   This command retrieves the Fabric API authentication token.

.INPUTS
   None. You cannot pipe inputs to this function.

.OUTPUTS
   String. This function returns the Fabric API authentication token.

.NOTES

   Author: Rui Romano

#>

function Get-FabricAuthToken {
    [CmdletBinding()]
    param
    (
    )

    if ($FabricSession.AccessToken) {
       $ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($FabricSession.AccessToken.Token)
       $Token = ([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr))
       return $Token
    } else {
        Write-Message -Message "AccessToken details are missing. Please run 'Connect-FabricAccount' to configure session." -Level Error
    }

}
