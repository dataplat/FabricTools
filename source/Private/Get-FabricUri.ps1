<#
.SYNOPSIS
Internal function to connect to Fabric and setup the uri and headers for commands.

.DESCRIPTION
Internal function to connect to Fabric and setup the uri and headers for commands.

Requires the Workspace and DataWarehouse GUIDs to connect to.

.PARAMETER BaseUrl
Defaults to api.powerbi.com

.PARAMETER WorkspaceGUID
This is the workspace GUID in which the data warehouse resides.

.PARAMETER DataWarehouseGUID
The GUID for the data warehouse which we want to retrieve restore points for.

.PARAMETER BatchId
The BatchId to use for the request. If this is set then the batches endpoint will be used.

.EXAMPLE
Get-FabricUri -WorkspaceGUID 'GUID-GUID-GUID-GUID' -DataWarehouseGUID 'GUID-GUID-GUID-GUID'

Connects to the specified Fabric Data Warehouse and sets up the headers and uri for future commands.

.EXAMPLE
Get-FabricUri -WorkspaceGUID 'GUID-GUID-GUID-GUID' -DataWarehouseGUID 'GUID-GUID-GUID-GUID' -BatchId 'GUID-GUID-GUID-GUID'

Connects to the specified Fabric Data Warehouse and sets up the headers and uri for checking the progress of an operation with a specific batchId.

#>
function Get-FabricUri {
    param (
        $BaseUrl = 'api.powerbi.com',
        [parameter(Mandatory)]
        [String]$WorkspaceGUID,
        [parameter(Mandatory)]
        [String]$DataWarehouseGUID,

        [String]$BatchId
    )

    try {
        $headers = Get-PowerBIAccessToken
    } catch {
        try {
            Stop-PSFFunction -Message ('Not able to get a token - execute Connect-PowerBIServiceAccount manually first') -EnableException
            # Write-PSFMessage -Level Warning -Message ('Not able to get a token - will execute Connect-PowerBIServiceAccount')
            #TODO: This doesn't work the first time - is it waiting for response?
            # $conn = Connect-PowerBIServiceAccount
            # if($conn) {
            #     Write-PSFMessage -Level Info -Message ('Successfully connected to PowerBI')
            # }
        } catch {
            throw 'Not able to get a token - manually try and run Connect-PowerBIServiceAccount'
        }
    }

    if($BatchId) {
        $Uri = ('https://{0}/v1.0/myorg/groups/{1}/datawarehouses/{2}/batches/{3}' -f $baseurl, $workspaceGUID, $dataWarehouseGUID, $BatchId)
        $method = 'Get'
    } else {
        $Uri = ('https://{0}/v1.0/myorg/groups/{1}/datawarehouses/{2}/' -f $baseurl, $workspaceGUID, $dataWarehouseGUID)
        $method = 'Post'
    }

    return @{
        Uri = $Uri
        Headers = $headers
        Method = $method
        ContentType = 'application/json'
    }
    #TODO: Change this to be a saved config property?
}
