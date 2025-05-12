<#
.SYNOPSIS
Sets the Fabric API headers with a valid token for the specified Azure tenant.

.DESCRIPTION
The `Set-FabricApiHeaders` function logs into the specified Azure tenant, retrieves an access token for the Fabric API, and sets the necessary headers for subsequent API requests. 
It also updates the token expiration time and global tenant ID.

.PARAMETER TenantId
The Azure tenant ID for which the access token is requested.

.PARAMETER AppId
The Azure app ID for which the service principal access token is requested.

.PARAMETER AppSecret
The Azure App secret for which the service principal access token is requested.

.EXAMPLE
Set-FabricApiHeaders -TenantId "your-tenant-id"

Logs in to Azure with the specified tenant ID, retrieves an access token for the current user, and configures the Fabric headers.

.EXAMPLE
$tenantId = "999999999-99999-99999-9999-999999999999"
$appId = "888888888-88888-88888-8888-888888888888"
$appSecret = "your-app-secret"
$secureAppSecret = $appSecret | ConvertTo-SecureString -AsPlainText -Force

Set-FabricApiHeader -TenantId $tenantId -AppId $appId -AppSecret $secureAppSecret
Logs in to Azure with the specified tenant ID, retrieves an access token for the service principal, and configures the Fabric headers.

.NOTES
- Ensure the `Connect-AzAccount` and `Get-AzAccessToken` commands are available (Azure PowerShell module required).
- Relies on a global `$FabricConfig` object for storing headers and token metadata.

.AUTHOR
Tiago Balabuch
#>

function Set-FabricApiHeaders {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TenantId,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$AppId,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Security.SecureString]$AppSecret
    )

    try {
        # Step 1: Connect to the Azure account
        Write-Message -Message "Logging in to Azure tenant: $TenantId" -Level Info

        # Step 2: Performing validation checks on the parameters passed to a function or script.
        # Checks if 'AppId' is provided without 'AppSecret' and vice versa.
        if ($PSBoundParameters.ContainsKey('AppId') -and -not $PSBoundParameters.ContainsKey('AppSecret')) {
            Write-Message -Message "AppSecret is required when using AppId: $AppId" -Level Error
            throw "AppSecret is required when using AppId."
        } 
        if ($PSBoundParameters.ContainsKey('AppSecret') -and -not $PSBoundParameters.ContainsKey('AppId')) {
            Write-Message -Message "AppId is required when using AppSecret." -Level Error
            throw "AppId is required when using AppId."
        }
        # Step 3: Connect to the Azure account
        # Using AppId and AppSecret
        if ($PSBoundParameters.ContainsKey('AppId') -and $PSBoundParameters.ContainsKey('AppSecret')) {
            
            Write-Message -Message "Logging in using the AppId: $AppId" -Level Debug
            Write-Message -Message "Logging in using the AppId: $AppId" -Level Info
            $psCredential = [pscredential]::new($AppId, $AppSecret)
            Connect-AzAccount -ServicePrincipal -Credential $psCredential -Tenant $tenantId

        } 
        # Using the current user
        else {
            
            Write-Message -Message "Logging in using the current user" -Level Debug
            Write-Message -Message "Logging in using the current user" -Level Info
            Connect-AzAccount -Tenant $TenantId -ErrorAction Stop | Out-Null
       }

       ## Step 4: Retrieve the access token for the Fabric API
        Write-Message -Message "Retrieve the access token for the Fabric API: $TenantId" -Level Debug
        $fabricToken = Get-AzAccessToken -AsSecureString -ResourceUrl $FabricConfig.ResourceUrl -ErrorAction Stop -WarningAction SilentlyContinue

        ## Step 5: Extract the plain token from the secure string
        Write-Message -Message "Extract the plain token from the secure string" -Level Debug
        $plainToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($fabricToken.Token)
        )

        ## Step 6: Set the headers in the global configuration
        Write-Message -Message "Set the headers in the global configuration" -Level Debug
        $FabricConfig.FabricHeaders = @{
            'Content-Type'  = 'application/json'
            'Authorization' = "Bearer $plainToken"
        }

        ## Step 7: Update token metadata in the global configuration
        Write-Message -Message "Update token metadata in the global configuration" -Level Debug
        $FabricConfig.TokenExpiresOn = $fabricToken.ExpiresOn
        $FabricConfig.TenantIdGlobal = $TenantId

        Write-Message -Message "Fabric token successfully configured." -Level Info
    }
    catch {
        # Step 8: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to set Fabric token: $errorDetails" -Level Error
        throw "Unable to configure Fabric token. Ensure tenant and API configurations are correct."
    }
}
