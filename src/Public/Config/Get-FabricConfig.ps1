function Get-FabricConfig {
    <#
.SYNOPSIS
Gets the configuration for use with all functions in the FabricTools module.

.DESCRIPTION
Gets the configuration for use with all functions in the FabricTools module.

.PARAMETER ConfigName
The name of the configuration to be retrieved.

.EXAMPLE
    Gets all configuration values for the FabricTools module and outputs them.

    ```powershell
    Get-FabricConfig
    ```

.EXAMPLE
    Gets the BaseUrl configuration value for the FabricTools module.

    ```powershell
    Get-FabricConfig -ConfigName BaseUrl
    ```

.NOTES

    Author: Jess Pomfret

#>
    param (
        [String] $ConfigName
    )

    if ($ConfigName) {
        Get-PSFConfig -Module 'FabricTools' -Name $ConfigName
    } else {
        Get-PSFConfig -Module 'FabricTools'
    }
}
