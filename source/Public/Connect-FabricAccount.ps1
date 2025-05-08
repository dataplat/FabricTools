function Connect-FabricAccount {
#Requires -Version 7.1

<#
.SYNOPSIS
    Connects to the Fabric WebAPI.

.DESCRIPTION
    Connects to the Fabric WebAPI by using the cmdlet Connect-AzAccount.
    This function retrieves the authentication token for the Fabric API and sets up the headers for API calls.

.PARAMETER TenantId
    The TenantId of the Azure Active Directory tenant you want to connect to
    and in which your Fabric Capacity is.

.EXAMPLE
    Connect-FabricAccount `
        -TenantID '12345678-1234-1234-1234-123456789012'

.NOTES

    Revsion History:

    - 2024-12-22 - FGE: Added Verbose Output

.LINK
    Connect-AzAccount https://learn.microsoft.com/de-de/powershell/module/az.accounts/connect-azaccount?view=azps-12.4.0

#>

[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$TenantId
    )

begin {
}

process {
    Write-Verbose "Connect to Azure Account"
    Connect-AzAccount -TenantId $TenantId | Out-Null

    Write-Verbose "Get authentication token"
    $FabricSession.FabricToken = (Get-AzAccessToken -ResourceUrl $FabricSession.BaseApiUrl).Token
    Write-Verbose "Token: $($FabricSession.FabricToken)"

    Write-Verbose "Setup headers for API calls"
    $FabricSession.HeaderParams = @{'Authorization'="Bearer {0}" -f $FabricSession.FabricToken}
    Write-Verbose "HeaderParams: $($FabricSession.HeaderParams)"
}

end {
}

}