function Load-FabricLakehouseTable {
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
Load-FabricLakehouseTable -WorkspaceId "your-workspace-id" -LakehouseId "your-lakehouse-id" -TableName "your-table-name" -PathType "File" -RelativePath "path/to/your/file.csv" -FileFormat "CSV" -CsvDelimiter "," -CsvHeader $true -Mode "append" -Recursive $false
This example loads data from a CSV file into the specified table in the Lakehouse.
.EXAMPLE
Load-FabricLakehouseTable -WorkspaceId "your-workspace-id" -LakehouseId "your-lakehouse-id" -TableName "your-table-name" -PathType "Folder" -RelativePath "path/to/your/folder" -FileFormat "Parquet" -Mode "overwrite" -Recursive $true
This example loads data from a folder into the specified table in the Lakehouse, overwriting any existing data.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$LakehouseId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[a-zA-Z0-9_]*$')]
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

    try {
        # Step 1: Ensure token validity
        Write-Message -Message "Validating token..." -Level Debug
        Test-TokenExpired
        Write-Message -Message "Token validation completed." -Level Debug

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/lakehouses/{2}/tables/{3}/load" -f $FabricConfig.BaseUrl, $WorkspaceId, $LakehouseId, $TableName
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            relativePath  = $RelativePath
            pathType      = $PathType
            mode          = $Mode
            recursive     = $Recursive
            formatOptions = @{
                format = $FileFormat
            }
        }

        if ($FileFormat -eq "CSV") {
            $body.formatOptions.delimiter = $CsvDelimiter
            $body.formatOptions.hasHeader = $CsvHeader
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        # Step 4: Make the API request
        $response = Invoke-RestMethod `
            -Headers $FabricConfig.FabricHeaders `
            -Uri $apiEndpointUrl `
            -Method Post `
            -Body $bodyJson `
            -ContentType "application/json" `
            -ErrorAction Stop `
            -SkipHttpErrorCheck `
            -ResponseHeadersVariable "responseHeader" `
            -StatusCodeVariable "statusCode"

        # Step 5: Validate the response code
        if ($statusCode -ne 202) {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        # Step 5: Handle and log the response
        switch ($statusCode) {
            202 {
                Write-Message -Message "Load table '$TableName' request accepted. Load table operation in progress!" -Level Info

                [string]$operationId = $responseHeader["x-ms-operation-id"]
                Write-Message -Message "Operation ID: '$operationId'" -Level Debug
                Write-Message -Message "Getting Long Running Operation status" -Level Debug

                $operationStatus = Get-FabricLongRunningOperation -operationId $operationId
                Write-Message -Message "Long Running Operation status: $operationStatus" -Level Debug
                # Handle operation result
                if ($operationStatus.status -eq "Succeeded") {
                    Write-Message -Message "Operation Succeeded" -Level Debug
                    Write-Message -Message "Load table '$TableName' operation complete successfully!" -Level Info
                    return $operationStatus
                } else {
                    Write-Message -Message "Operation failed. Status: $($operationStatus)" -Level Debug
                    Write-Message -Message "Operation failed. Status: $($operationStatus)" -Level Error
                    return $operationStatus
                }
            }
            default {
                Write-Message -Message "Unexpected response code: $statusCode" -Level Error
                Write-Message -Message "Error: $($response.message)" -Level Error
                Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
                throw "API request failed with status code $statusCode."
            }
        }

        # Step 6: Handle results

    } catch {
        # Step 7: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update Lakehouse. Error: $errorDetails" -Level Error
    }
}