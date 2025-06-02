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
        if ($servicePrincipalId) {
            Write-Message "Connecting to Azure Account using provided servicePrincipalId..." -Level Verbose
            $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $servicePrincipalId, $servicePrincipalSecret
            $null = Connect-AzAccount -ServicePrincipal -TenantId $tenantId -Credential $credential
        }
        elseif ($null -ne $credential) {
            Write-Message "Connecting to Azure Account using provided credential..." -Level Verbose
            $null = Connect-AzAccount -Credential $credential -Tenant $tenantId
        }
        else {
            Write-Message "Connecting to Azure Account using current context..." -Level Verbose
            $null = Connect-AzAccount
        }

        $azContext = Get-AzContext

        Write-Message "Connected: $($azContext.Account)" -Level Verbose

        if ($PSCmdlet.ShouldProcess("Setting Fabric authentication token and headers for $($azContext.Account)")) {
            Write-Message "Get authentication token from $($FabricSession.ResourceUrl)" -Level Verbose
            $FabricSession.AccessToken = (Get-AzAccessToken -ResourceUrl $FabricSession.ResourceUrl)
            $ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($FabricSession.AccessToken.Token)
            $Token = ([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr))
            Write-Message "Setup headers for Fabric API calls" -Level Debug
            $FabricSession.HeaderParams = @{'Authorization' = "Bearer {0}" -f $Token }

            # Copy session values to exposed $FabricConfig
            $FabricConfig.TenantId = $FabricSession.AccessToken.TenantId
            $FabricConfig.TokenExpiresOn = $FabricSession.AccessToken.ExpiresOn
            $FabricConfig.FabricHeaders = $FabricSession.HeaderParams    # Remove this;
        }

        if ($PSCmdlet.ShouldProcess("Setting Azure authentication token and headers for $($azContext.Account)")) {
            Write-Message "Get authentication token from $($AzureSession.BaseApiUrl)" -Level Verbose
            $AzureSession.AccessToken = (Get-AzAccessToken -ResourceUrl $AzureSession.BaseApiUrl)
            $ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($AzureSession.AccessToken.Token)
            $Token = ([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr))
            Write-Message "Setup headers for Azure API calls" -Level Debug
            $AzureSession.HeaderParams = @{'Authorization' = "Bearer {0}" -f $Token }
        }

    }
    end {
        # return $($FabricSession.FabricToken)
    }
}
