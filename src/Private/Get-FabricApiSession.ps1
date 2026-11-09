<#
.SYNOPSIS
Returns the base URL and request headers for the given API type.

.DESCRIPTION
The `Get-FabricApiSession` function resolves, from the FabricTools configuration, the base URL and the
authentication headers that `Invoke-FabricRestMethod` uses for a request to the given API type:

- Fabric:  FabricTools.FabricApi.BaseUrl  + FabricTools.FabricSession.Headers
- PowerBI: FabricTools.PowerBiApi.BaseUrl + FabricTools.FabricSession.Headers
- Azure:   FabricTools.AzureApi.BaseUrl   + FabricTools.AzureSession.Headers
- Kusto:   no base URL (each KQL Database has its own query service URI) + FabricTools.KustoSession.Headers

The Kusto token is acquired on first use (and again when it has expired) for the resource
FabricTools.KustoApi.ResourceUrl, and cached in the FabricTools.KustoSession.* configuration.

.PARAMETER ApiType
The API the request is sent to. Valid values are 'Fabric', 'PowerBI', 'Kusto' and 'Azure'.

.EXAMPLE
Get-FabricApiSession -ApiType Kusto

Returns an object with an empty BaseUrl and the Headers for the Kusto API, acquiring a Kusto token if needed.

.NOTES
This is an internal function used by Invoke-FabricRestMethod.

Author: Kamil Nowinski
#>
function Get-FabricApiSession {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Fabric', 'PowerBI', 'Kusto', 'Azure')]
        [string] $ApiType
    )

    switch ($ApiType) {
        'Fabric' {
            $baseUrl = $script:FabricConfig.BaseUrl
            $headers = Get-PSFConfigValue -FullName 'FabricTools.FabricSession.Headers'
        }
        'PowerBI' {
            $baseUrl = Get-PSFConfigValue -FullName 'FabricTools.PowerBiApi.BaseUrl'
            $headers = Get-PSFConfigValue -FullName 'FabricTools.FabricSession.Headers'
        }
        'Azure' {
            $baseUrl = Get-PSFConfigValue -FullName 'FabricTools.AzureApi.BaseUrl'
            $headers = Get-PSFConfigValue -FullName 'FabricTools.AzureSession.Headers'
        }
        'Kusto' {
            $baseUrl = $null
            $headers = Get-PSFConfigValue -FullName 'FabricTools.KustoSession.Headers'
            $tokenExpiresOn = Get-PSFConfigValue -FullName 'FabricTools.KustoSession.TokenExpiresOn'

            $isTokenValid = $headers -is [hashtable] -and $headers.ContainsKey('Authorization') -and
                $null -ne $tokenExpiresOn -and ([DateTimeOffset]$tokenExpiresOn) -gt [DateTimeOffset]::Now.AddMinutes(1)

            if (-not $isTokenValid) {
                $resourceUrl = Get-PSFConfigValue -FullName 'FabricTools.KustoApi.ResourceUrl'
                Write-Message -Message "Get authentication token from $resourceUrl" -Level Verbose
                $accessToken = Get-AzAccessToken -ResourceUrl $resourceUrl -ErrorAction Stop

                $plainTextToken = $accessToken.Token
                if ($plainTextToken -is [securestring]) {
                    $plainTextToken = [System.Net.NetworkCredential]::new('', $plainTextToken).Password
                }
                $headers = @{ 'Authorization' = "Bearer {0}" -f $plainTextToken }

                Set-PSFConfig -FullName 'FabricTools.KustoSession.AccessToken' -Value $accessToken
                Set-PSFConfig -FullName 'FabricTools.KustoSession.Headers' -Value $headers
                Set-PSFConfig -FullName 'FabricTools.KustoSession.TokenExpiresOn' -Value $accessToken.ExpiresOn
            }
        }
    }

    Write-Message -Message "Using '$ApiType' API session. Base URL: '$baseUrl'" -Level Debug

    [PSCustomObject]@{
        ApiType = $ApiType
        BaseUrl = $baseUrl
        Headers = $headers
    }
}
