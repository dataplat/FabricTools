function New-FabricConnection {
    <#
    .SYNOPSIS
        Creates a cloud Web connection in Microsoft Fabric.

    .DESCRIPTION
        Creates a ShareableCloud WebForPipeline connection. Service principal
        and Basic credentials are supplied as a PSCredential; the credential
        username is the application ID for service principal authentication.

    .PARAMETER ConnectionName
        The display name of the connection.

    .PARAMETER BaseUrl
        The base URL for the Web connection.

    .PARAMETER Audience
        The audience for the Web connection.

    .PARAMETER CredentialType
        The credential type: ServicePrincipal, Anonymous, or Basic.

    .PARAMETER Credential
        Service principal application ID and secret, or Basic username and password.

    .PARAMETER TenantId
        The tenant ID used with ServicePrincipal credentials.

    .PARAMETER PrivacyLevel
        Optional privacy level for the connection.

    .PARAMETER SkipTestConnection
        Skips testing the connection when creating it.

    .EXAMPLE
        ```powershell
        $credential = Get-Credential
        New-FabricConnection -ConnectionName 'FUAM API' -BaseUrl 'https://api.contoso.com' -Audience 'api://contoso' -CredentialType ServicePrincipal -TenantId '11111111-1111-1111-1111-111111111111' -Credential $credential
        ```
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Name', 'DisplayName')]
        [string]$ConnectionName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ $_.IsAbsoluteUri -and $_.Scheme -eq 'https' })]
        [uri]$BaseUrl,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Audience,

        [Parameter(Mandatory = $true)]
        [ValidateSet('ServicePrincipal', 'Anonymous', 'Basic')]
        [string]$CredentialType,

        [Parameter()]
        [System.Management.Automation.PSCredential]$Credential,

        [Parameter()]
        [guid]$TenantId,

        [Parameter()]
        [ValidateSet('None', 'Public', 'Organizational', 'Private')]
        [string]$PrivacyLevel,

        [Parameter()]
        [switch]$SkipTestConnection
    )

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

    $connectionDetails = @{
        type           = 'WebForPipeline'
        creationMethod = 'WebForPipeline.Contents'
        parameters     = @(
            @{ dataType = 'Text'; name = 'baseUrl'; value = $BaseUrl.AbsoluteUri.TrimEnd('/') }
            @{ dataType = 'Text'; name = 'audience'; value = $Audience }
        )
    }
    $credentialValue = @{}
    if ($CredentialType -eq 'ServicePrincipal') {
        $credentialValue = @{
            tenantId                   = $TenantId.ToString()
            servicePrincipalClientId   = $Credential.UserName
            servicePrincipalSecret     = $Credential.GetNetworkCredential().Password
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
    $body = @{
        displayName       = $ConnectionName
        connectivityType  = 'ShareableCloud'
        connectionDetails = $connectionDetails
        credentialDetails = $credentialDetails
    }
    if ($PrivacyLevel) {
        $body.privacyLevel = $PrivacyLevel
    }
    if ($SkipTestConnection) {
        $body.skipTestConnection = $true
    }

    if (-not $PSCmdlet.ShouldProcess("Connection '$ConnectionName'", 'Create connection')) {
        return
    }

    $apiParams = @{
        Uri                  = 'connections'
        Method               = 'Post'
        Body                 = $body
        TypeName             = 'Connection'
        ObjectIdOrName       = $ConnectionName
        HandleResponse       = $true
        SuppressBodyLogging  = $true
        TestTokenExpired     = $true
    }
    Invoke-FabricRestMethod @apiParams
}
