<#
.SYNOPSIS
   This script loads necessary modules, sources functions from .ps1 files, and sets aliases for PowerBI functions.

.DESCRIPTION
   The script first tries to load the Az.Accounts and Az.Resources modules. If these modules are not available, it installs and imports them.
   It then gets all .ps1 files in the Functions folder, sources each function, and exports it as a module member.
   Finally, it sets an alias for the PowerBI login function.

.EXAMPLE
   .\FabricTools.psm1

   This command runs the script.

.INPUTS
   None. You cannot pipe inputs to this script.

.OUTPUTS
   None. This script does not return any output.

.NOTES
   This script is part of the FabricTools module.
#>

$script:FabricSession = [ordered]@{
   BaseApiUrl          = 'https://api.fabric.microsoft.com/v1'
   ResourceUrl         = 'https://api.fabric.microsoft.com'
   FabricToken         = $null
   HeaderParams        = $null
   ContentType         = @{'Content-Type' = "application/json"}
   KustoURL            = "https://api.kusto.windows.net"
   AccessToken         = $null
}

$script:AzureSession = [ordered]@{
   BaseApiUrl          = "https://management.azure.com"
   AccessToken         = $null
   Token               = $null
   HeaderParams        = $null
}

$script:PowerBI = [ordered]@{
   BaseApiUrl          = "https://api.powerbi.com/v1.0/myorg"
}

$FabricConfig = @{
   BaseUrl      = "https://api.fabric.microsoft.com/v1"
   ResourceUrl  = "https://api.fabric.microsoft.com"
   FabricHeaders = @{}
   TenantIdGlobal = ""
   TokenExpiresOn = ""
}

Export-ModuleMember -Variable FabricConfig

# Get all .ps1 files in the (public) Functions folder
$publicFunctions = Get-ChildItem -Path "$PSScriptRoot\public" -Filter '*.ps1' -Recurse

# Loop over each function file
foreach ($function in $publicFunctions) {
    # Dot-source the function
    . $function.fullname
    # Export the function as a module member
    Export-ModuleMember -Function $function.basename
}

$privateFunctions = Get-ChildItem -Path "$PSScriptRoot\private" -Filter '*.ps1' -Recurse
$privateFunctions | ForEach-Object { . $_.FullName }

# Set aliases for PowerBI functions
Set-Alias -Name Login-Fabric -Value Login-PowerBI
Export-ModuleMember -Alias Login-Fabric
Set-Alias -Name Get-FabWorkspace -Value Get-FabricWorkspace
Export-ModuleMember -Alias Get-FabDataset
Set-Alias -Name Get-FabricDataset -Value Get-PowerBIDataset
Export-ModuleMember -Alias Get-FabricDataset
Set-Alias -Name Get-FabReport -Value Get-PowerBIReport
Export-ModuleMember -Alias Get-FabReport
Set-Alias -Name Get-FabricReport -Value Get-PowerBIReport
Export-ModuleMember -Alias Get-FabricReport
Set-Alias -Name Logout-Fabric -Value Logout-PowerBI
Export-ModuleMember -Alias Logout-Fabric

$moduleName = 'FabricTools'
Write-Host "Module $moduleName imported."
