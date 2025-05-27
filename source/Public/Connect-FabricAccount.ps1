function Connect-FabricAccount {

    <#
.SYNOPSIS
    Connects to the Fabric WebAPI.

.DESCRIPTION
    Connects to the Fabric WebAPI by using the cmdlet Connect-AzAccount. This function retrieves the authentication token for the Fabric API and sets up the headers for API calls.

.PARAMETER TenantId
    The TenantId of the Azure Active Directory tenant you want to connect to and in which your Fabric Capacity is.

.PARAMETER ServicePrincipalId
    The Client ID (AppId) of the service principal used for authentication.

.PARAMETER ServicePrincipalSecret
    The **secure string** representing the service principal secret.

.PARAMETER Credential
    A PSCredential object representing a user credential (username and secure password).

.EXAMPLE
    Connect-FabricAccount -TenantId '12345678-1234-1234-1234-123456789012'

    Connects to the stated Tenant with exisitng credentials

.EXAMPLE
    $credential = Get-Credential
    Connect-FabricAccount -TenantId 'xxx' -credential $credential

    Prompts for Service Principal id and secret and connects as that Service Principal

.EXAMPLE
    Connect-FabricAccount -TenantId 'xxx' -ServicePrincipalId 'appId' -ServicePrincipalSecret $secret

    Connects as Service Principal using id and secret

.NOTES

    Revsion History:

    - 2024-12-22 - FGE: Added Verbose Output
    - 2025-05-26 - Jojobit: Added Service Principal support, with secure string handling and parameter descriptions, as supported by the original FabTools module

.LINK
    Connect-AzAccount https://learn.microsoft.com/de-de/powershell/module/az.accounts/connect-azaccount?view=azps-12.4.0
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false, HelpMessage = "Azure AD Tenant ID.")]
        [string]$tenantId,

        [Parameter(Mandatory = $false, HelpMessage = "AppId of the service principal.")]
        [string]$servicePrincipalId,

        [Parameter(Mandatory = $false, HelpMessage = "Secure secret of the service principal.")]
        [SecureString]$servicePrincipalSecret,

        [Parameter(Mandatory = $false, HelpMessage = "User credential.")]
        [PSCredential]$credential
    )

    begin {
    }

    process {
        Write-Verbose "Connect to Azure Account"

        if ($servicePrincipalId) {
            $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $servicePrincipalId, $servicePrincipalSecret
            $null = Connect-AzAccount -ServicePrincipal -TenantId $tenantId -Credential $credential
        }
        elseif ($null -ne $credential) {
            $null = Connect-AzAccount -Credential $credential -Tenant $tenantId
        }
        else {
            $null = Connect-AzAccount
        }
        
        $azContext = Get-AzContext

        Write-Verbose "Connected: $($azContext.Account)"
        
        if ($PSCmdlet.ShouldProcess("Setting Fabric authentication token for $($azContext.Account)")) {
            
            Write-Verbose "Get authentication token"
            $FabricSession.FabricToken = (Get-AzAccessToken -ResourceUrl $FabricSession.ResourceUrl).Token
            Write-Verbose "Token: $($FabricSession.FabricToken)"
            }
            
         if ($PSCmdlet.ShouldProcess("Setting Fabric headers for $($azContext.Account)")) {
            Write-Verbose "Setup headers for API calls"
            $FabricSession.HeaderParams = @{'Authorization' = "Bearer {0}" -f $FabricSession.FabricToken }
            Write-Verbose "HeaderParams: $($FabricSession.HeaderParams)"
        }
    }
    end {
    }
}
