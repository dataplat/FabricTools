function Get-FabricConnection {
    <#
.SYNOPSIS
Retrieves Fabric connections.

.DESCRIPTION
The Get-FabricConnection function retrieves Fabric connections. It can retrieve all connections or the specified one only.

.PARAMETER connectionId
The ID of the connection to retrieve.

.EXAMPLE
Get-FabricConnection

This example retrieves all connections from Fabric

.EXAMPLE
Get-FabricConnection -connectionId "12345"

This example retrieves specific connection from Fabric with ID "12345".

.NOTES
https://learn.microsoft.com/en-us/rest/api/fabric/core/connections/get-connection?tabs=HTTP
https://learn.microsoft.com/en-us/rest/api/fabric/core/connections/list-connections?tabs=HTTP
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false)]
        [string]$connectionId
    )

    begin {
        Confirm-FabricAuthToken | Out-Null
    }

    process {
        if ($connectionId) {
            $result = Invoke-FabricAPIRequest -Uri "/connections/$($connectionId)" -Method GET
        } else {
            $result = Invoke-FabricAPIRequest -Uri "/connections" -Method GET
        }

        return $result.value
    }
}