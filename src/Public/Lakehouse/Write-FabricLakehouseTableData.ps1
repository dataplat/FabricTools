function Write-FabricLakehouseTableData
{

    <#

    .SYNOPSIS
    Loads data into a specified table in a Lakehouse within a Fabric workspace.

    .DESCRIPTION
    Loads data into a specified table in a Lakehouse within a Fabric workspace. The function supports loading data from files or folders, with options for file format and CSV settings.

    .PARAMETER WorkspaceId
    The ID of the workspace containing the Lakehouse.

    .PARAMETER LakehouseId
    The ID of the Lakehouse where the table resides.

    .PARAMETER TableName
    The name of the table to load data into.

    .PARAMETER PathType
    The type of path to load data from (File or Folder).

    .PARAMETER RelativePath
    The relative path to the file or folder to load data from.

    .PARAMETER FileFormat
    The format of the file to load data from (CSV or Parquet).

    .PARAMETER CsvDelimiter
    The delimiter used in the CSV file (default is comma).

    .PARAMETER CsvHeader
    Indicates whether the CSV file has a header row (default is false).

    .PARAMETER Mode
    The mode for loading data (append or overwrite).

    .PARAMETER Recursive
    Indicates whether to load data recursively from subfolders (default is false).

    .EXAMPLE
    This example loads data from a CSV file into the specified table in the Lakehouse.

    ```powershell
    Import-FabricLakehouseTableData -WorkspaceId "your-workspace-id" -LakehouseId "your-lakehouse-id" -TableName "your-table-name" -PathType "File" -RelativePath "path/to/your/file.csv" -FileFormat "CSV" -CsvDelimiter "," -CsvHeader $true -Mode "append" -Recursive $false
    ```

    .EXAMPLE
    This example loads data from a folder into the specified table in the Lakehouse, overwriting any existing data.

    ```powershell
    Import-FabricLakehouseTableData -WorkspaceId "your-workspace-id" -LakehouseId "your-lakehouse-id" -TableName "your-table-name" -PathType "Folder" -RelativePath "path/to/your/folder" -FileFormat "Parquet" -Mode "overwrite" -Recursive $true
    ```

    .NOTES

    Author: Tiago Balabuch, Kamil Nowinski

    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias("Import-FabricLakehouseTableData")]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$LakehouseId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TableName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('File', 'Folder')]
        [string]$PathType,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$RelativePath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('CSV', 'Parquet')]
        [string]$FileFormat,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$CsvDelimiter = ",",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]$CsvHeader = $false,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('append', 'overwrite')]
        [string]$Mode = "append",

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]$Recursive = $false
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/lakehouses/{2}/tables/{3}/load" -f $FabricConfig.BaseUrl, $WorkspaceId, $LakehouseId, $TableName
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            relativePath  = $RelativePath
            pathType      = $PathType
            mode          = $Mode
            recursive     = $Recursive
            formatOptions = @{
                format = $FileFormat
            }
        }

        if ($FileFormat -eq "CSV")
        {
            $body.formatOptions.delimiter = $CsvDelimiter
            $body.formatOptions.hasHeader = $CsvHeader
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Load Lakehouse Table Data"))
        {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                TypeName       = 'Lakehouse Table'
                ObjectIdOrName = $TableName
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
        Write-Message -Message "Failed to update Lakehouse. Error: $errorDetails" -Level Error
    }
}
