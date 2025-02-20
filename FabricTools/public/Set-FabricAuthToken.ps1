<#
.SYNOPSIS
   Sets the Fabric authentication token.

.DESCRIPTION
   The Set-FabricAuthToken function sets the Fabric authentication token. It checks if an Azure context is already available. If not, it connects to the Azure account using either a service principal ID and secret, a provided credential, or interactive login. It then gets the Azure context and sets the Fabric authentication token.

.PARAMETER azContext
   The Azure context. If not provided, the function connects to the Azure account and gets the context.

.PARAMETER servicePrincipalId
   The service principal ID. If provided, the function uses this ID and the service principal secret to connect to the Azure account.

.PARAMETER servicePrincipalSecret
   The service principal secret. Used with the service principal ID to connect to the Azure account.

.PARAMETER tenantId
   The tenant ID. Used with the service principal ID and secret or the credential to connect to the Azure account.

.PARAMETER credential
   The credential. If provided, the function uses this credential to connect to the Azure account.

.EXAMPLE
   Set-FabricAuthToken -servicePrincipalId "12345678-90ab-cdef-1234-567890abcdef" -servicePrincipalSecret "secret" -tenantId "12345678-90ab-cdef-1234-567890abcdef"

   This command sets the Fabric authentication token using the provided service principal ID, secret, and tenant ID.

.INPUTS
   String, SecureString, PSCredential. You can pipe a string that contains the service principal ID, a secure string that contains the service principal secret, and a PSCredential object that contains the credential to Set-FabricAuthToken.

.OUTPUTS
   None. This function does not return any output.

.NOTES
   This function was originally written by Rui Romano.
   https://github.com/RuiRomano/fabricps-pbip
#>

function Set-FabricAuthToken {
   <#
    .SYNOPSIS
        Set authentication token for the Fabric service
    #>
   [CmdletBinding(SupportsShouldProcess)]
   param
   (
      [string]$servicePrincipalId
      ,
      [string]$servicePrincipalSecret
      ,
      [PSCredential]$credential
      ,
      [string]$tenantId
      ,
      [switch]$reset
      ,
      [string]$apiUrl
   )

   if (!$reset) {
      $azContext = Get-AzContext
   }

   if ($apiUrl) {
      $script:apiUrl = $apiUrl
   }

   if (!$azContext) {
      Write-Output "Getting authentication token"
      if ($servicePrincipalId) {
         $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $servicePrincipalId, ($servicePrincipalSecret | ConvertTo-SecureString -AsPlainText -Force)

         Connect-AzAccount -ServicePrincipal -TenantId $tenantId -Credential $credential | Out-Null

         Set-AzContext -Tenant $tenantId | Out-Null
      }
      elseif ($null -ne $credential) {
         Connect-AzAccount -Credential $credential -Tenant $tenantId | Out-Null
      }
      else {
         Connect-AzAccount | Out-Null
      }
      $azContext = Get-AzContext
   }
   if ($PSCmdlet.ShouldProcess("Setting Fabric authentication token for $($azContext.Account)")) {
      Write-output "Connnected: $($azContext.Account)"

      $script:fabricToken = (Get-AzAccessToken -ResourceUrl $script:resourceUrl).Token
   }
}