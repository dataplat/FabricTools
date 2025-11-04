Set-PSFConfig -Name 'FabricTools.FabricApi.BaseApiUrl'         -Value 'https://api.fabric.microsoft.com/v1'
Set-PSFConfig -Name 'FabricTools.FabricApi.ResourceUrl'        -Value 'https://api.fabric.microsoft.com'
Set-PSFConfig -Name 'FabricTools.FabricApi.TenantId'
Set-PSFConfig -Name 'FabricTools.FabricApi.ContentType'        -Value 'application/json; charset=utf-8'

Set-PSFConfig -Name 'FabricTools.FabricSession.Headers'        -Value @{}
Set-PSFConfig -Name 'FabricTools.FabricSession.TokenExpiresOn' -Value $null
Set-PSFConfig -Name 'FabricTools.FabricSession.AccessToken'    -Value $null

Set-PSFConfig -Name 'FabricTools.KustoApi.BaseUrl'             -Value 'https://api.kusto.windows.net'
Set-PSFConfig -Name 'FabricTools.AzureApi.BaseUrl'             -Value "https://management.azure.com"

Set-PSFConfig -Name 'FabricTools.AzureSession.AccessToken'     -Value $null
Set-PSFConfig -Name 'FabricTools.AzureSession.Headers'         -Value @{}

Set-PSFConfig -Name 'FabricTools.PowerBiApi.BaseUrl'           -Value "https://api.powerbi.com/v1.0/myorg"

# Remain backwards compatible with scripts relying on $FabricConfig variable
$script:FabricConfig = @{
    BaseUrl        = "https://api.fabric.microsoft.com/v1"
}

# Feature Flags
Set-PSFConfig -Name 'FabricTools.FeatureFlags.EnableTokenRefresh' -Value $true -Validation bool
