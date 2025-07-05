# this is a workaround to get the variables set for now
# TODO: change to use PSFConfig?

Set-PSFConfig -Name 'FabricTools.FabricApi.BaseApiUrl'         -Value 'https://api.fabric.microsoft.com/v1'
Set-PSFConfig -Name 'FabricTools.FabricApi.ResourceUrl'        -Value 'https://api.fabric.microsoft.com'
Set-PSFConfig -Name 'FabricTools.FabricApi.TenantId'
Set-PSFConfig -Name 'FabricTools.FabricApi.ContentType'        -Value 'application/json; charset=utf-8'

Set-PSFConfig -Name 'FabricTools.FabricSession.Headers'        -Value @{}
Set-PSFConfig -Name 'FabricTools.FabricSession.TokenExpiresOn' -Value $null -Validation DateTimeOffset
Set-PSFConfig -Name 'FabricTools.FabricSession.AccessToken'    -Value $null

Set-PSFConfig -Name 'FabricTools.KustoApi.BaseUrl'             -Value 'https://api.kusto.windows.net'

$script:FabricSession = [ordered]@{
    BaseApiUrl   = 'https://api.fabric.microsoft.com/v1'
    ResourceUrl  = 'https://api.fabric.microsoft.com'
    HeaderParams = $null
    ContentType  = @{'Content-Type' = "application/json" }
    KustoURL     = "https://api.kusto.windows.net"
    AccessToken  = $null
}

Set-PSFConfig -Name 'FabricTools.AzureApi.BaseUrl'           -Value "https://management.azure.com"

Set-PSFConfig -Name 'FabricTools.AzureSession.AccessToken'   -Value $null
Set-PSFConfig -Name 'FabricTools.AzureSession.Headers'       -Value @{}


$script:AzureSession = [ordered]@{
    BaseApiUrl   = "https://management.azure.com"
    AccessToken  = $null
    HeaderParams = $null
}

Set-PSFConfig -Name 'FabricTools.PowerBiApi.BaseUrl'      -Value "https://api.powerbi.com/v1.0/myorg"

# $script:PowerBI = [ordered]@{
#     BaseApiUrl = "https://api.powerbi.com/v1.0/myorg"
# }

$FabricConfig = @{
    BaseUrl        = "https://api.fabric.microsoft.com/v1"
    # ResourceUrl    = "https://api.fabric.microsoft.com"
    # FabricHeaders  = @{}
    # TenantId = ""
    # TokenExpiresOn = ""
    # FeatureFlags = @{
    #     EnableTokenRefresh = $true
    # }
}

Set-PSFConfig -Name 'FabricTools.FeatureFlags.EnableTokenRefresh' -Value $true -Validation bool
