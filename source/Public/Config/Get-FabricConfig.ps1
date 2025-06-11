function Get-FabricConfig {
    <#
.SYNOPSIS
Gets the configuration for use with all functions in the PSFabricTools module.

.DESCRIPTION
Gets the configuration for use with all functions in the PSFabricTools module.

.PARAMETER ConfigName
The name of the configuration to retrieve.

.EXAMPLE
PS> Get-FabricConfig

Gets all the configuration values for the PSFabricTools module and outputs them

.EXAMPLE
PS> Get-FabricConfig -ConfigName BaseUrl

Gets the BaseUrl configuration value for the PSFabricTools module.

.NOTES

    Author: Jess Pomfret

#>
    param (
        [String]$ConfigName
    )

    if ($ConfigName) {
        Get-PSFConfig -Module PSFabricTools -Name $ConfigName
    } else {
        Get-PSFConfig -Module PSFabricTools
    }
}
