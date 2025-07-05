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

.PARAMETER Reset
    A switch parameter. If provided, the function resets the Fabric authentication token.

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

.OUTPUTS
    None. This function does not return any output.

.NOTES

    Revision History:

    - 2024-12-22 - FGE: Added Verbose Output
    - 2025-05-26 - Jojobit: Added Service Principal support, with secure string handling and parameter descriptions, as supported by the original FabTools module
    - 2025-06-02 - KNO: Added Reset switch to force re-authentication and token refresh

    Author: Frank Geisler, Kamil Nowinski

.LINK
    Connect-AzAccount https://learn.microsoft.com/de-de/powershell/module/az.accounts/connect-azaccount?view=azps-12.4.0
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false, HelpMessage = "Azure AD Tenant ID.")]
        [guid] $TenantId,

        [Parameter(Mandatory = $false, HelpMessage = "AppId of the service principal.")]
        [Alias('AppId')]
        [guid] $ServicePrincipalId,

        [Parameter(Mandatory = $false, HelpMessage = "Secure secret of the service principal.")]
        [Alias('AppSecret')]
        [SecureString] $ServicePrincipalSecret,

        [Parameter(Mandatory = $false, HelpMessage = "User credential.")]
        [PSCredential] $Credential,

        [Parameter(Mandatory = $false, HelpMessage = "Refresh current session.")]
        [switch] $Reset
    )

    begin {
        # Checks if 'AppId' is provided without 'AppSecret' and vice versa.
        if ($PSBoundParameters.ContainsKey('AppId') -and -not $PSBoundParameters.ContainsKey('AppSecret'))
        {
            Write-Message -Message "AppSecret is required when using AppId: $AppId" -Level Error
            throw "AppSecret is required when using AppId."
        }
        if ($PSBoundParameters.ContainsKey('AppSecret') -and -not $PSBoundParameters.ContainsKey('AppId'))
        {
            Write-Message -Message "AppId is required when using AppSecret." -Level Error
            throw "AppId is required when using AppId."
        }
    }

    process {
        if (!$Reset)
        {
            $azContext = Get-AzContext
        }
        if (!$azContext) {
            if ($ServicePrincipalId) {
                Write-Message "Connecting to Azure Account using provided servicePrincipalId..." -Level Verbose
                $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ServicePrincipalId, $ServicePrincipalSecret
                $null = Connect-AzAccount -ServicePrincipal -TenantId $TenantId -Credential $credential
            }
            elseif ($null -ne $Credential) {
                Write-Message "Connecting to Azure Account using provided credential..." -Level Verbose
                $null = Connect-AzAccount -Credential $Credential -Tenant $TenantId
            }
            else {
                Write-Message "Connecting to Azure Account using current user..." -Level Verbose
                if ($TenantId) {
                    $null = Connect-AzAccount -Tenant $TenantId
                }
                else {
                    # If no TenantId is provided, connect to the default tenant
                    Write-Message "No TenantId provided, connecting to default tenant..." -Level Verbose
                    $null = Connect-AzAccount
                }
            }
            $azContext = Get-AzContext
        }

        Write-Message "Connected: $($azContext.Account)" -Level Verbose

        if ($PSCmdlet.ShouldProcess("Setting Fabric authentication token and headers for $($azContext.Account)")) {
            $ResourceUrl = Get-PSFConfigValue -FullName 'FabricTools.FabricApi.ResourceUrl'
            Write-Message "Get authentication token from $ResourceUrl" -Level Verbose
            $accessToken = (Get-AzAccessToken -ResourceUrl $ResourceUrl)
            Set-PSFConfig -FullName 'FabricTools.FabricSession.AccessToken' -Value $accessToken
            $plainTextToken = $accessToken.Token | ConvertFrom-SecureString -AsPlainText
            Write-Message "Setup headers for Fabric API calls" -Level Debug
            $headerParams = @{'Authorization' = "Bearer {0}" -f $plainTextToken }
            Set-PSFConfig -FullName 'FabricTools.FabricSession.Headers' -Value $headerParams
            Set-PSFConfig -FullName 'FabricTools.FabricApi.TenantId' -Value $accessToken.TenantId
            Set-PSFConfig -FullName 'FabricTools.FabricSession.TokenExpiresOn' -Value $accessToken.ExpiresOn
        }

        if ($PSCmdlet.ShouldProcess("Setting Azure authentication token and headers for $($azContext.Account)")) {
            $BaseApiUrl = Get-PSFConfigValue -FullName 'FabricTools.AzureApi.BaseUrl'
            Write-Message "Get authentication token from $BaseApiUrl" -Level Verbose
            $accessToken = (Get-AzAccessToken -ResourceUrl $BaseApiUrl)
            Set-PSFConfig -FullName 'FabricTools.AzureSession.AccessToken' -Value $accessToken
            $plainTextToken = $accessToken.Token | ConvertFrom-SecureString -AsPlainText
            Write-Message "Setup headers for Azure API calls" -Level Debug
            $headerParams = @{'Authorization' = "Bearer {0}" -f $plainTextToken }
            Set-PSFConfig -FullName 'FabricTools.AzureSession.Headers' -Value $headerParams
        }

    }
    end {
    }
}
