# this is a workaround to get the variables set for now
# TODO: change to use PSFConfig?

$script:FabricSession = [ordered]@{
    BaseApiUrl   = 'https://api.fabric.microsoft.com/v1'
    ResourceUrl  = 'https://api.fabric.microsoft.com'
    HeaderParams = $null
    ContentType  = @{'Content-Type' = "application/json" }
    KustoURL     = "https://api.kusto.windows.net"
    AccessToken  = $null
}

$script:AzureSession = [ordered]@{
    BaseApiUrl   = "https://management.azure.com"
    AccessToken  = $null
    HeaderParams = $null
}

$script:PowerBI = [ordered]@{
    BaseApiUrl = "https://api.powerbi.com/v1.0/myorg"
}

$FabricTools = @{
    FeatureFlags = @{
        AutoRenewExpiredToken = $true
    }
}

$FabricConfig = @{
    BaseUrl        = "https://api.fabric.microsoft.com/v1"
    ResourceUrl    = "https://api.fabric.microsoft.com"
    FabricHeaders  = @{}
    TenantIdGlobal = ""
    TokenExpiresOn = ""
}
