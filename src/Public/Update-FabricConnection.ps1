function Update-FabricConnection {
    <#
    .SYNOPSIS
        Updates a Fabric connection name or credentials.

    .DESCRIPTION
        Changes a connection display name, replaces credentials, or both.

    .PARAMETER ConnectionId
        The ID of the connection to update.

    .PARAMETER ConnectionName
        The new display name.

    .PARAMETER CredentialType
        The replacement credential type: ServicePrincipal, Anonymous, or Basic.

    .PARAMETER Credential
        Service principal application ID and secret, or Basic username and password.

    .PARAMETER TenantId
        The tenant ID used with ServicePrincipal credentials.

    .PARAMETER PrivacyLevel
        Optional privacy level for replacement credentials.

    .EXAMPLE
        ```powershell
        Update-FabricConnection -ConnectionId '11111111-1111-1111-1111-111111111111' -ConnectionName 'Updated API'
        ```
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [guid]$ConnectionId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Alias('Name', 'DisplayName')]
        [string]$ConnectionName,

        [Parameter()]
        [ValidateSet('ServicePrincipal', 'Anonymous', 'Basic')]
        [string]$CredentialType,

        [Parameter()]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter()]
        [guid]$TenantId,

        [Parameter()]
        [ValidateSet('None', 'Public', 'Organizational', 'Private')]
        [string]$PrivacyLevel
    )

    $body = @{}
    if ($PSBoundParameters.ContainsKey('ConnectionName')) {
        $body.displayName = $ConnectionName
    }
    if ($CredentialType) {
        if ($CredentialType -eq 'Anonymous') {
            if ($Credential -or $TenantId) {
                throw 'Anonymous credentials cannot be combined with Credential or TenantId.'
            }
        } elseif (-not $Credential) {
            throw "Credential is required for $CredentialType authentication."
        } elseif ($CredentialType -eq 'ServicePrincipal' -and -not $TenantId) {
            throw 'TenantId is required for ServicePrincipal authentication.'
        } elseif ($CredentialType -eq 'Basic' -and $TenantId) {
            throw 'TenantId is only valid for ServicePrincipal authentication.'
        }

        $credentialValue = @{}
        if ($CredentialType -eq 'ServicePrincipal') {
            $credentialValue = @{
                tenantId                 = $TenantId.ToString()
                servicePrincipalClientId = $Credential.UserName
                servicePrincipalSecret   = $Credential.GetNetworkCredential().Password
            }
        } elseif ($CredentialType -eq 'Basic') {
            $credentialValue = @{
                username = $Credential.UserName
                password = $Credential.GetNetworkCredential().Password
            }
        }
        $credentialsJson = if ($CredentialType -eq 'Anonymous') {
            '{}'
        } else {
            @{ credentialData = @(
                    foreach ($key in $credentialValue.Keys) {
                        @{ name = $key; value = $credentialValue[$key] }
                    }
                ) } | ConvertTo-Json -Depth 10 -Compress
        }
        $credentialDetails = @{
            credentialType = $CredentialType
            credentials    = $credentialsJson
            singleSignOnType = 'None'
            connectionEncryption = 'NotEncrypted'
        }
        $body.credentialDetails = $credentialDetails
        if ($PrivacyLevel) {
            $body.privacyLevel = $PrivacyLevel
        }
    } elseif ($Credential -or $TenantId -or $PrivacyLevel) {
        throw 'Specify CredentialType when changing credentials or their privacy level.'
    }
    if ($body.Count -eq 0) {
        throw 'Specify a new ConnectionName or replacement CredentialType.'
    }

    if (-not $PSCmdlet.ShouldProcess("Connection '$ConnectionId'", 'Update connection')) {
        return
    }

    $apiParams = @{
        Uri                 = "connections/$ConnectionId"
        Method              = 'Patch'
        Body                = $body
        TypeName            = 'Connection'
        ObjectIdOrName      = $ConnectionId
        HandleResponse      = $true
        SuppressBodyLogging = $true
        TestTokenExpired    = $true
    }
    Invoke-FabricRestMethod @apiParams
}
