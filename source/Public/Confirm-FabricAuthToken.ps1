<#
.SYNOPSIS
    Check whether the Fabric API authentication token is set and not expired and reset it if necessary.

.DESCRIPTION
    The Confirm-FabricAuthToken function retrieves the Fabric API authentication token. If the token is not already set, it calls the Set-FabricAuthToken function to set it. It then outputs the token.

.EXAMPLE
    Confirm-FabricAuthToken

    This command retrieves the Fabric API authentication token.

.INPUTS
    None. You cannot pipe inputs to this function.

.OUTPUTS
    Returns object as Get-FabricDebugInfo function

.NOTES

#>

function Confirm-FabricAuthToken {
    [CmdletBinding()]
    param  (   )

    Write-Verbose "Check if session is established and token not expired."

    # Check if the Fabric token is already set
    if (!$FabricSession.FabricToken -or !$AzureSession.AccessToken) {
        Write-Output "Confirm-FabricAuthToken::Set-FabricAuthToken"
        Set-FabricAuthToken | Out-Null
    }

    $now = (Get-Date)
    $s = Get-FabricDebugInfo
    if ($FabricSession.AccessToken.ExpiresOn -lt $now ) {
        Write-Output "Confirm-FabricAuthToken::Set-FabricAuthToken#1"
        Set-FabricAuthToken -reset | Out-Null
    }

    if ($s.AzureSession.AccessToken.ExpiresOn -lt $now ) {
        Write-Output "Confirm-FabricAuthToken::Set-FabricAuthToken#2"
        Set-FabricAuthToken -reset | Out-Null
    }

    $s = Get-FabricDebugInfo
    return $s

}
