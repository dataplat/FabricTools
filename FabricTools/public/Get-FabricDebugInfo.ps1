function Get-FabricDebugInfo {
    #Requires -Version 7.1

<#
.SYNOPSIS
    Shows internal debug information about the current session.

.DESCRIPTION
    Shows internal debug information about the current session. It is useful for troubleshooting purposes.
    It will show you the current session object. This includes the bearer token. This can be useful
    for connecting to the REST API directly via Postman.

.Example
    Get-FabricDebugInfo

    This example shows the current session object.

.NOTES

    Revsion History:

    - 2024-12-22 - FGE: Added Verbose Output

#>

[CmdletBinding()]
    param (

    )

begin {}

process {
    Write-Verbose "Show current session object"

    return @{
        FabricSession = $script:FabricSession
        AzureSession = $script:AzureSession
    }

}

end {}

}