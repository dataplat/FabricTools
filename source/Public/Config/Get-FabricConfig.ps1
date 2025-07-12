function Get-FabricConfig {
    <#
.SYNOPSIS
Gets the configuration for use with all functions in the PSFabricTools module.

.DESCRIPTION
Gets the configuration for use with all functions in the PSFabricTools module.

.PARAMETER ConfigName
The name of the configuration to be retrieved.

.EXAMPLE
    Gets all configuration values for the PSFabricTools module and outputs them.

    ```powershell
    Get-FabricConfig
    ```

.EXAMPLE
    Gets the BaseUrl configuration value for the PSFabricTools module.

    ```powershell
    Get-FabricConfig -ConfigName BaseUrl
    ```

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
