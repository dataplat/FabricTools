<#
.SYNOPSIS
Register the configuration for use with all functions in the PSFabricTools module.

.DESCRIPTION
Register the configuration for use with all functions in the PSFabricTools module.

.PARAMETER WorkspaceGUID
This is the workspace GUID in which the Data Warehouse resides.

.PARAMETER DataWarehouseGUID
The GUID for the Data Warehouse which we want to retrieve restore points for.

.PARAMETER BaseUrl
Defaults to api.powerbi.com

.PARAMETER SkipPersist
If set, the configuration will not be persisted to the registry.

.EXAMPLE
PS> Set-FabricConfig -WorkspaceGUID 'GUID-GUID-GUID-GUID' -DataWarehouseGUID 'GUID-GUID-GUID-GUID'

Registers the specified Fabric Data Warehouse configuration for use with all functions in the PSFabricTools module.

.EXAMPLE
PS> Set-FabricConfig -WorkspaceGUID 'GUID-GUID-GUID-GUID' -DataWarehouseGUID 'GUID-GUID-GUID-GUID' -SkipPersist

Registers the specified Fabric Data Warehouse configuration for use with all functions in the PSFabricTools module - but it does not persist the values, only uses them for the current session.

.NOTES

Author: Jess Pomfret
#>

function Set-FabricConfig {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [guid]$WorkspaceGUID,

        [guid]$DataWarehouseGUID,

        $BaseUrl = 'api.powerbi.com',

        [switch]$SkipPersist
    )

    if ($PSCmdlet.ShouldProcess("Setting Fabric Configuration")) {

        if ($BaseUrl) {
            Set-PSFConfig -Module PSFabricTools -Name BaseUrl -Value $BaseUrl
        }
        if ($WorkspaceGUID) {
            Set-PSFConfig -Module PSFabricTools -Name WorkspaceGUID -Value $WorkspaceGUID
        }
        if ($DataWarehouseGUID) {
            Set-PSFConfig -Module PSFabricTools -Name DataWarehouseGUID -Value $DataWarehouseGUID
        }

        # Register the config values in the registry if skip persist is not set
        if (-not $SkipPersist) {
            Register-PSFConfig -Module PSFabricTools -Scope SystemMandatory
        }
    }
}
