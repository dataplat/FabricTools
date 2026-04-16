function Start-FabricLakehouseTableMaintenance
{

    <#
    .SYNOPSIS
    Initiates a table maintenance job for a specified Lakehouse in a Fabric workspace.

    .DESCRIPTION
    This function sends a POST request to the Fabric API to start a table maintenance job for a specified Lakehouse.
    It allows for optional parameters such as schema name, table name, and Z-ordering columns.
    The function also handles asynchronous operations and can wait for completion if specified.

    .PARAMETER WorkspaceId
    The unique identifier of the workspace where the Lakehouse resides. This parameter is mandatory.

    .PARAMETER LakehouseId
    The unique identifier of the Lakehouse for which the table maintenance job is to be initiated. This parameter is mandatory.

    .PARAMETER JobType
    The type of job to be initiated. Default is "TableMaintenance". This parameter is optional.

    .PARAMETER SchemaName
    The name of the schema in the Lakehouse. This parameter is optional.

    .PARAMETER TableName
    The name of the table in the Lakehouse. This parameter is optional.

    .PARAMETER IsVOrder
    A boolean flag indicating whether to apply V-ordering. This parameter is optional.

    .PARAMETER ColumnsZOrderBy
    An array of columns to be used for Z-ordering. This parameter is optional.

    .PARAMETER retentionPeriod
    The retention period for the table maintenance job. This parameter is optional.

    .PARAMETER waitForCompletion
    A boolean flag indicating whether to wait for the job to complete. Default is false. This parameter is optional.

    .EXAMPLE
    Initiates a table maintenance job for the specified Lakehouse and waits for its completion.

    ```powershell
    Start-FabricLakehouseTableMaintenance -WorkspaceId "12345" -LakehouseId "67890" -JobType "TableMaintenance" -SchemaName "dbo" -TableName "MyTable" -IsVOrder $true -ColumnsZOrderBy @("Column1", "Column2") -retentionPeriod "7:00:00" -waitForCompletion $true
    ```

    .EXAMPLE
    Initiates a table maintenance job for the specified Lakehouse without waiting for its completion.

    ```powershell
    Start-FabricLakehouseTableMaintenance -WorkspaceId "12345" -LakehouseId "67890" -JobType "TableMaintenance" -SchemaName "dbo" -TableName "MyTable" -IsVOrder $false -ColumnsZOrderBy @("Column1", "Column2") -retentionPeriod "7:00:00"
    ```

    .NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.
    - This function handles asynchronous operations and retrieves operation results if required.
    - The function uses the `Write-Message` function for logging and debugging purposes.
    - The function uses the `Get-FabricLakehouse` function to retrieve Lakehouse details.
    - The function uses the `Get-FabricLongRunningOperation` function to check the status of long-running operations.
    - The function uses the `Invoke-RestMethod` cmdlet to make API requests.

    Author: Tiago Balabuch, Kamil Nowinski

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$LakehouseId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('TableMaintenance')]
        [string]$JobType = "TableMaintenance",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SchemaName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$TableName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]$IsVOrder,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [array]$ColumnsZOrderBy,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^\d+:[0-1][0-9]|2[0-3]:[0-5][0-9]:[0-5][0-9]$")]
        [string]$retentionPeriod,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]$waitForCompletion = $false

    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        $lakehouse = Get-FabricLakehouse -WorkspaceId $WorkspaceId -LakehouseId $LakehouseId
        if ($lakehouse.properties.PSObject.Properties['defaultSchema'] -and -not $SchemaName)
        {
            Write-Error "The Lakehouse '$lakehouse.displayName' has schema enabled, but no schema name was provided. Please specify the 'SchemaName' parameter to proceed."
            return
        }

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/lakehouses/{2}/jobs/instances?jobType={3}" -f $FabricConfig.BaseUrl, $WorkspaceId , $LakehouseId, $JobType
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            executionData = @{
                tableName        = $TableName
                optimizeSettings = @{ }
            }
        }
        if ($lakehouse.properties.PSObject.Properties['defaultSchema'] -and $SchemaName)
        {
            $body.executionData.schemaName = $SchemaName
        }

        if ($IsVOrder)
        {
            $body.executionData.optimizeSettings.vOrder = $IsVOrder
        }

        if ($ColumnsZOrderBy)
        {
            # Ensure $ColumnsZOrderBy is an array
            if (-not ($ColumnsZOrderBy -is [array]))
            {
                $ColumnsZOrderBy = $ColumnsZOrderBy -split ","
            }
            # Add it to the optimizeSettings in the request body
            $body.executionData.optimizeSettings.zOrderBy = $ColumnsZOrderBy
        }

        if ($retentionPeriod)
        {
            if (-not $body.executionData.PSObject.Properties['vacuumSettings'])
            {
                $body.executionData.vacuumSettings = @{
                    retentionPeriod = @()
                }
            }
            $body.executionData.vacuumSettings.retentionPeriod = $retentionPeriod
        }

        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Start Table Maintenance Job"))
        {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                TypeName       = 'Lakehouse Table Maintenance'
                ObjectIdOrName = $LakehouseId
                NoWait         = (-not $waitForCompletion)
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to start table maintenance job. Error: $errorDetails" -Level Error
    }
}
