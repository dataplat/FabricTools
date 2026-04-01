function Set-FabricConfig {
    <#
.SYNOPSIS
Register the configuration for use with all functions in the FabricTools module.

.DESCRIPTION
Register the configuration for use with all functions in the FabricTools module.

.PARAMETER WorkspaceGUID
This is the workspace GUID in which the Data Warehouse resides.

.PARAMETER DataWarehouseGUID
The GUID for the Data Warehouse which we want to retrieve restore points for.

.PARAMETER BaseUrl
Defaults to api.powerbi.com

.PARAMETER SkipPersist
If set, the configuration will not be persisted to the registry.

.EXAMPLE
    Registers the specified Fabric Data Warehouse configuration for use with all functions in the FabricTools module.

    ```powershell
    Set-FabricConfig -WorkspaceGUID 'GUID-GUID-GUID-GUID' -DataWarehouseGUID 'GUID-GUID-GUID-GUID'
    ```

.EXAMPLE
    Registers the specified Fabric Data Warehouse configuration for use with all functions in the FabricTools module, but does not persist the values.

    ```powershell
    Set-FabricConfig -WorkspaceGUID 'GUID-GUID-GUID-GUID' -DataWarehouseGUID 'GUID-GUID-GUID-GUID' -SkipPersist
    ```

.NOTES

Author: Jess Pomfret
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [guid]$WorkspaceGUID,

        [guid]$DataWarehouseGUID,

        $BaseUrl = 'api.powerbi.com',

        [switch]$SkipPersist
    )

    if ($PSCmdlet.ShouldProcess("Setting Fabric Configuration")) {

        if ($BaseUrl) {
            Set-PSFConfig -Module 'FabricTools' -Name BaseUrl -Value $BaseUrl
        }
        if ($WorkspaceGUID) {
            Set-PSFConfig -Module 'FabricTools' -Name WorkspaceGUID -Value $WorkspaceGUID
        }
        if ($DataWarehouseGUID) {
            Set-PSFConfig -Module 'FabricTools' -Name DataWarehouseGUID -Value $DataWarehouseGUID
        }

        # Register the config values in the registry if skip persist is not set
        if (-not $SkipPersist) {
            Register-PSFConfig -Module 'FabricTools' -Scope SystemMandatory
        }
    }
}
