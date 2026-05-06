function Get-FabricDebugInfo {

    <#
.SYNOPSIS
    Shows internal debug information about the current Azure & Fabric sessions & Fabric config.

.DESCRIPTION
    Shows internal debug information about the current session. It is useful for troubleshooting purposes.
    It will show you the current session object. This includes the bearer token. This can be useful
    for connecting to the REST API directly via Postman.

.Example
    Get-FabricDebugInfo

    This example shows the current session object.

.NOTES

    Author: Frank Geisler, Kamil Nowinski

    #>

    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (   )

    return @{
        FabricSession = $script:FabricSession
        AzureSession  = $script:AzureSession
        FabricConfig  = $script:FabricConfig
    }

}
