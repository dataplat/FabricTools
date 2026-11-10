function Get-FabricConnection {
    <#
.SYNOPSIS
Retrieves Fabric connections.

.DESCRIPTION
The Get-FabricConnection function retrieves Fabric connections. It can retrieve all connections or the specified one only.

.PARAMETER connectionId
The ID of the connection to retrieve.

.PARAMETER ConnectionName
The exact display name of the connection to retrieve. The name must match a single connection.

.EXAMPLE
Get-FabricConnection

This example retrieves all connections from Fabric

.EXAMPLE
Get-FabricConnection -connectionId "12345"

This example retrieves specific connection from Fabric with ID "12345".

.EXAMPLE
Get-FabricConnection -ConnectionName "Finance API"

This example retrieves the connection with the exact display name "Finance API".
.NOTES
https://learn.microsoft.com/en-us/rest/api/fabric/core/connections/get-connection?tabs=HTTP
https://learn.microsoft.com/en-us/rest/api/fabric/core/connections/list-connections?tabs=HTTP

Author: Kamil Nowinski

#>

    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param
    (
        [Parameter(Mandatory = $false)]
        [Alias('Id')]
        [guid]$connectionId,

        [Parameter(Mandatory = $false)]
        [Alias('Name', 'DisplayName')]
        [string]$ConnectionName
    )

    begin {
        Confirm-TokenState
    }

    process {
        if ($connectionId -and $ConnectionName) {
            throw 'Specify either connectionId or ConnectionName, not both.'
        }

        $apiParams = @{
            Method         = 'Get'
            TypeName       = 'Connection'
            HandleResponse = $true
        }
        if ($connectionId) {
            # Single connection: the response is the connection object itself
            $apiParams.Uri = "connections/$($connectionId)"
            $apiParams.ObjectIdOrName = $connectionId
            return Invoke-FabricRestMethod @apiParams
        }

        $apiParams.Uri = "connections"
        $apiParams.ExtractValue = 'True'
        $connections = @(Invoke-FabricRestMethod @apiParams)
        if ($ConnectionName) {
            $matchingConnections = @($connections | Where-Object { $_.DisplayName -eq $ConnectionName })
            if ($matchingConnections.Count -gt 1) {
                throw "Connection name '$ConnectionName' is ambiguous. Specify connectionId."
            }
            return $matchingConnections
        }
        $connections
    }
}
