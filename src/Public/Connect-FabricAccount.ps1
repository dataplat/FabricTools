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

.PARAMETER UseDeviceAuthentication
    A switch parameter. Forces device code authentication instead of the interactive broker/browser flow.
    Use this when the interactive account picker cannot be displayed by the host terminal (for example Warp on Windows,
    which does not expose a window handle the WAM broker can parent its UI to). When this switch is not specified,
    Connect-FabricAccount still falls back to device code authentication automatically if interactive sign-in fails.

.EXAMPLE
    Connects to the stated Tenant with existing credentials

    ```powershell
    Connect-FabricAccount -TenantId '12345678-1234-1234-1234-123456789012'
    ```

.EXAMPLE
    Prompts for Service Principal id and secret and connects as that Service Principal

    ```powershell
    $credential = Get-Credential
    Connect-FabricAccount -TenantId 'xxx' -credential $credential
    ```

.EXAMPLE
    Connects as Service Principal using AppId and secret

    ```powershell
    $TenantID               = '12345678-1234-1234-1234-123456789012'
    $ServicePrincipalId     = '4cbbe76e-1234-1234-0000-ffffffffffff'
    $ServicePrincipalSecret = 'xyz'

    $ServicePrincipalSecretSecure = ($ServicePrincipalSecret | ConvertTo-SecureString -AsPlainText -Force)
    Connect-FabricAccount -TenantId $TenantID -ServicePrincipalId $ServicePrincipalId -ServicePrincipalSecret $ServicePrincipalSecretSecure -Reset
    ```

.EXAMPLE
    Connects using device code authentication (useful in terminals such as Warp where the account picker cannot render)

    ```powershell
    Connect-FabricAccount -UseDeviceAuthentication
    ```

.EXAMPLE
    Connects as Service Principal using credential object

    ```powershell
    $TenantID               = '12345678-1234-1234-1234-123456789012'
    $ServicePrincipalId     = '4cbbe76e-1234-1234-0000-ffffffffffff'
    $ServicePrincipalSecret = 'xyz'

    $ServicePrincipalSecretSecure = ($ServicePrincipalSecret | ConvertTo-SecureString -AsPlainText -Force)
    $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ServicePrincipalId, $ServicePrincipalSecretSecure
    Connect-FabricAccount -TenantId $TenantID -Credential $credential -Verbose -Reset
    ```

.OUTPUTS
    None. This function does not return any output.

.NOTES

    Revision History:

    - 2024-12-22 - FGE: Added Verbose Output
    - 2025-05-26 - Jojobit: Added Service Principal support, with secure string handling and parameter descriptions, as supported by the original FabTools module
    - 2025-06-02 - KNO: Added Reset switch to force re-authentication and token refresh
    - 2026-08-23 - PBO: Added UseDeviceAuthentication switch and automatic fallback to device code auth when interactive/broker sign-in fails (e.g. Warp terminal)

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
        [switch] $Reset,

        [Parameter(Mandatory = $false, HelpMessage = "Use device code authentication instead of the interactive broker/browser flow.")]
        [switch] $UseDeviceAuthentication
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
            throw "AppId is required when using AppSecret."
        }
        # Warn if both Credential and AppId are provided
        if ($PSBoundParameters.ContainsKey('Credential') -and $PSBoundParameters.ContainsKey('AppId'))
        {
            Write-Message -Message "Provided Credential will be ignored when AppId/ServicePrincipalId is also provided." -Level Warning
        }
    }

    process {
        if (!$Reset)
        {
            $azContext = Get-AzContext
        }
        if (!$azContext) {
            if ($ServicePrincipalId) {
                Write-Message "Connecting to Azure Account using provided ServicePrincipalId..." -Level Verbose
                $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ServicePrincipalId, $ServicePrincipalSecret
                $null = Connect-AzAccount -ServicePrincipal -TenantId $TenantId -Credential $credential
            }
            elseif ($null -ne $Credential) {
                Write-Message "Connecting to Azure Account using provided credential..." -Level Verbose
                $null = Connect-AzAccount -ServicePrincipal -Credential $Credential -Tenant $TenantId
            }
            else {
                Write-Message "Connecting to Azure Account using current user..." -Level Verbose
                $connectAzAccountParams = @{}
                if ($TenantId) {
                    $connectAzAccountParams['Tenant'] = $TenantId
                }
                else {
                    Write-Message "No TenantId provided, connecting to default tenant..." -Level Verbose
                }

                if ($UseDeviceAuthentication) {
                    Write-Message "Using device code authentication as requested..." -Level Verbose
                    $null = Connect-AzAccount @connectAzAccountParams -UseDeviceAuthentication
                }
                else {
                    try {
                        $null = Connect-AzAccount @connectAzAccountParams -ErrorAction Stop
                    }
                    catch {
                        # Interactive/broker (WAM) sign-in can silently fail to render its account picker in some
                        # terminal hosts (e.g. Warp on Windows does not expose a window handle for WAM to parent
                        # its UI to). Fall back to device code authentication instead of failing outright.
                        Write-Message "Interactive sign-in failed, possibly because this terminal does not support the account picker (e.g. Warp): $($_.Exception.Message). Falling back to device code authentication..." -Level Warning
                        $null = Connect-AzAccount @connectAzAccountParams -UseDeviceAuthentication
                    }
                }
            }
            $azContext = Get-AzContext
        }

        Write-Message "Connected: $($azContext.Account)" -Level Info

        if ($PSCmdlet.ShouldProcess("Setting Fabric authentication token and headers for $($azContext.Account)")) {
            $ResourceUrl = Get-PSFConfigValue -FullName 'FabricTools.FabricApi.ResourceUrl'
            Write-Message "Get authentication token from $ResourceUrl" -Level Verbose
            try {
                $accessToken = Get-AzAccessToken -ResourceUrl $ResourceUrl -ErrorAction Stop
            } catch {
                Write-Message "Token acquisition failed for $ResourceUrl (MFA or conditional access may have expired). Re-authenticating with resource scope..." -Level Warning
                $reconnectTenantId = if ($TenantId) { $TenantId } else { $azContext.Tenant.Id }
                $null = Connect-AzAccount -Tenant $reconnectTenantId -AuthScope $ResourceUrl
                $accessToken = Get-AzAccessToken -ResourceUrl $ResourceUrl -ErrorAction Stop
            }
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
            try {
                $accessToken = Get-AzAccessToken -ResourceUrl $BaseApiUrl -ErrorAction Stop
            } catch {
                Write-Message "Token acquisition failed for $BaseApiUrl (MFA or conditional access may have expired). Re-authenticating with resource scope..." -Level Warning
                $reconnectTenantId = if ($TenantId) { $TenantId } else { $azContext.Tenant.Id }
                $null = Connect-AzAccount -Tenant $reconnectTenantId -AuthScope $BaseApiUrl
                $accessToken = Get-AzAccessToken -ResourceUrl $BaseApiUrl -ErrorAction Stop
            }
            Set-PSFConfig -FullName 'FabricTools.AzureSession.AccessToken' -Value $accessToken
            $plainTextToken = $accessToken.Token | ConvertFrom-SecureString -AsPlainText
            Write-Message "Setup headers for Azure API calls" -Level Debug
            $headerParams = @{'Authorization' = "Bearer {0}" -f $plainTextToken }
            Set-PSFConfig -FullName 'FabricTools.AzureSession.Headers' -Value $headerParams
        }

    }
    end { }
}
