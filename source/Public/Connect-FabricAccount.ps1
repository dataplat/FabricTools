function Connect-FabricAccount
{

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
    Connects to the stated Tenant with existing credentials

    ```powershell
    Connect-FabricAccount -TenantId '12345678-1234-1234-1234-123456789012'
    ```

.EXAMPLE
    Prompts for Service Principal id and secret and connects as that Service Principal

    ```powershell
    $credential = Get-Credential
    Connect-FabricAccount -TenantId '12345678-1234-1234-1234-123456789012' -credential $credential
    ```

.EXAMPLE
    Connects as Service Principal using id and secret

    ```powershell
    Connect-FabricAccount `
        -TenantId '12345678-1234-1234-1234-123456789012' `
        -ServicePrincipalId 'appId' `
        -ServicePrincipalSecret $secret
    ```

.OUTPUTS
    None. This function does not return any output.

.NOTES

    Revision History:

    - 2024-12-22 - FGE: Added Verbose Output
    - 2025-05-26 - Jojobit: Added Service Principal support, with secure string handling and parameter descriptions, as supported by the original FabTools module
    - 2025-06-02 - KNO: Added Reset switch to force re-authentication and token refresh
    - 2025-08-21 - FGE: Fixed Bug #164 Login with Service Principal fails with "Connect-FabricAccount: Cannot process
                        argument transformation on parameter 'ServicePrincipalSecret'.
                        Cannot convert the value of type "System.String" to type "System.Security.SecureString"." when passing in a
                        String as ServicePrincipalSecret (AppSecret). Now it will convert the String to a SecureString if there is only
                        String
                        Fixed another bug on the Parameters. You can only access a parameter by its name, not by its alias.

    Author: Frank Geisler, Kamil Nowinski

.LINK
    Connect-AzAccount https://learn.microsoft.com/de-de/powershell/module/az.accounts/connect-azaccount?view=azps-12.4.0
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false, HelpMessage = 'Azure AD Tenant ID.')]
        [guid] $TenantId,

        [Parameter(Mandatory = $false, HelpMessage = 'AppId of the service principal.')]
        [Alias('AppId')]
        [guid] $ServicePrincipalId,

        [Parameter(Mandatory = $false, HelpMessage = 'Secure secret of the service principal.')]
        [Alias('AppSecret')]
        [Object] $ServicePrincipalSecret,

        [Parameter(Mandatory = $false, HelpMessage = 'User credential.')]
        [PSCredential] $Credential,

        [Parameter(Mandatory = $false, HelpMessage = 'Refresh current session.')]
        [switch] $Reset
    )

    begin
    {
        Write-Message `
            -Message "Function $($MyInvocation.MyCommand.Name) started." `
            -Level Verbose

        # Checks if 'AppId' is provided without 'AppSecret' and vice versa.
        # FGE: At this point we have to check ServicePrincipalId and ServicePrincipalSecret, because only they
        #      will be filled, regardless if AppId or AppSecret is used. Checking for them will never match
        if ($PSBoundParameters.ContainsKey('ServicePrincipalId') -and -not $PSBoundParameters.ContainsKey('ServicePrincipalSecret'))
        {
            Write-Message `
                -Message "ServicePrincipalSecret (AppSecret) is required when using ServicePrincipalId (AppId): $ServicePrincipalId" `
                -Level Error

            throw "ServicePrincipalSecret (AppSecret) is required when using ServicePrincipalId (AppId): $ServicePrincipalId"
        }
        if ($PSBoundParameters.ContainsKey('ServicePrincipalSecret') -and -not $PSBoundParameters.ContainsKey('ServicePrincipalId'))
        {
            Write-Message `
                -Message 'ServicePrincipalId (AppId) is required when using ServicePrincipalSecret (AppSecret).' `
                -Level Error

            throw 'ServicePrincipalId (AppId) is required when using ServicePrincipalSecret (AppSecret).'
        }
        if ($PSBoundParameters.ContainsKey('ServicePrincipalSecret'))
        {
            # FGE: If the $ServicePrincipalSecret is not a SecureString, we convert it to one.
            if ($ServicePrincipalSecret -is [string])
            {
                Write-Message `
                    -Message 'Converting ServicePrincipalSecret (AppSecret) to SecureString' `
                    -Level Verbose

                $SecureServicePrincipalSecret = ConvertTo-SecureString $ServicePrincipalSecret `
                    -AsPlainText `
                    -Force
            }
            elseif ($ServicePrincipalSecret -is [SecureString])
            {
                Write-Message `
                    -Message 'ServicePrincipalSecret (AppSecret) is already a SecureString' `
                    -Level Verbose

                $SecureServicePrincipalSecret = $ServicePrincipalSecret
            }
            else
            {
                Write-Message `
                    -Message 'ServicePrincipalSecret (AppSecret) must be a string or SecureString.' `
                    -Level Error

                throw 'ServicePrincipalSecret (AppSecret) must be a string or SecureString.'
            }
        }
    }

    process
    {
        if (!$Reset)
        {
            $azContext = Get-AzContext
        }
        if (!$azContext)
        {
            if ($ServicePrincipalId)
            {
                Write-Message `
                    -Message "Connecting to Azure Account using provided servicePrincipalId: $ServicePrincipalId" `
                    -Level Verbose

                Write-Message `
                    -Message "Converting $ServicePrincipalSecret to SecureString" `
                    -Level Verbose

                $ServicePrincipalCredential = New-Object `
                    -TypeName System.Management.Automation.PSCredential `
                    -ArgumentList `
                    $ServicePrincipalId, `
                    $SecureServicePrincipalSecret

                Connect-AzAccount `
                    -ServicePrincipal `
                    -TenantId $TenantId `
                    -Credential $ServicePrincipalCredential | `
                        Out-Null
            }
            elseif ($null -ne $Credential)
            {
                # FGE: Question is should we deprecate this? It will not be possible in the future anyway
                #      https://github.com/dataplat/FabricTools/issues/165
                Write-Message `
                    -Message 'Connecting to Azure Account using provided credential...' `
                    -Level Verbose

                Connect-AzAccount `
                    -Tenant $TenantId `
                    -Credential $Credential
            }
            else
            {
                Write-Message `
                    -Message 'Connecting to Azure Account using current user...' `
                    -Level Verbose

                if ($TenantId)
                {
                    Connect-AzAccount `
                        -Tenant $TenantId | `
                            Out-Null
                }
                else
                {
                    # If no TenantId is provided, connect to the default tenant
                    Write-Message `
                        -Message 'No TenantId provided, connecting to default tenant...' `
                        -Level Verbose

                    Connect-AzAccount | `
                            Out-Null
                }
            }
            $azContext = Get-AzContext
        }

        Write-Message `
            -Message "Connected: $($azContext.Account)" `
            -Level Verbose

        if ($PSCmdlet.ShouldProcess("Setting Fabric authentication token and headers for $($azContext.Account)"))
        {
            Write-Message `
                -Message "Get authentication token from $($FabricSession.ResourceUrl)" `
                -Level Verbose

            $FabricSession.AccessToken = (Get-AzAccessToken `
                    -ResourceUrl $FabricSession.ResourceUrl)

            $plainTextToken = $FabricSession.AccessToken.Token | `
                    ConvertFrom-SecureString `
                    -AsPlainText

            Write-Message `
                -Message 'Setup headers for Fabric API calls' `
                -Level Debug

            $FabricSession.HeaderParams = @{'Authorization' = 'Bearer {0}' -f $plainTextToken }

            # Copy session values to exposed $FabricConfig
            $FabricConfig.TenantId = $FabricSession.AccessToken.TenantId
            $FabricConfig.TokenExpiresOn = $FabricSession.AccessToken.ExpiresOn
            $FabricConfig.FabricHeaders = $FabricSession.HeaderParams    # Remove this;
        }

        if ($PSCmdlet.ShouldProcess("Setting Azure authentication token and headers for $($azContext.Account)"))
        {
            Write-Message `
                -Message "Get authentication token from $($AzureSession.BaseApiUrl)" `
                -Level Verbose

            $AzureSession.AccessToken = (Get-AzAccessToken `
                    -ResourceUrl $AzureSession.BaseApiUrl)

            $plainTextToken = $AzureSession.AccessToken.Token | `
                    ConvertFrom-SecureString `
                    -AsPlainText

            Write-Message `
                -Message 'Setup headers for Azure API calls' `
                -Level Debug

            $AzureSession.HeaderParams = @{'Authorization' = 'Bearer {0}' -f $plainTextToken }
        }

    }
    end
    {
        Write-Message `
            -Message "Function $($MyInvocation.MyCommand.Name) ended." `
            -Level Verbose
    }
}
