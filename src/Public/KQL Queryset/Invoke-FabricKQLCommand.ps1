function Invoke-FabricKQLCommand {
    <#
.SYNOPSIS
    Executes a KQL command in a Kusto Database.

.DESCRIPTION
    Executes a KQL command in the KQL Database specified by the KQLDatabaseName or KQLDatabaseId parameter.
    The command is sent to the query service of the database (the 'queryServiceUri' property of the KQL Database)
    using an access token for the Kusto API (configuration key 'FabricTools.KustoApi.BaseUrl').

    The cmdlet distinguishes between management commands and queries: a command starting with a dot is a management
    command and is sent to the management endpoint (/v1/rest/mgmt), anything else is a query and is sent to the
    query endpoint (/v1/rest/query).
    Management commands are wrapped in '.execute database script <|' unless the command already contains it.

    Query results are returned as an array of PowerShell objects (one per row) by default.
    Use -ReturnRawResult to get the raw response of the Kusto API.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace that contains the KQL Database. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER KQLDatabaseName
    The name of the KQL Database in which the KQL command should be executed. Cannot be used together with KQLDatabaseId.

.PARAMETER KQLDatabaseId
    The Id of the KQL Database in which the KQL command should be executed. Cannot be used together with KQLDatabaseName.
    The value for KQLDatabaseId is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER KQLCommand
    The KQL command or query that should be executed in the KQL Database.
    An example is '.create table MyTable (MyColumn: string)'.

.PARAMETER ReturnRawResult
    When this switch is used, the raw response of the Kusto API is returned instead of an array of PowerShell objects.
    Management commands always return the raw response.

.EXAMPLE
    $params = @{
        WorkspaceId     = '12345678-1234-1234-1234-123456789012'
        KQLDatabaseName = 'MyKQLDatabase'
        KQLCommand      = '.create table MyTable (MyColumn: string)'
    }
    Invoke-FabricKQLCommand @params

    Creates a table named 'MyTable' with a column named 'MyColumn' in the KQL Database 'MyKQLDatabase'.

.EXAMPLE
    $params = @{
        WorkspaceId     = '12345678-1234-1234-1234-123456789012'
        KQLDatabaseName = 'MyEventhouse'
        KQLCommand      = 'productcategory | take 100'
    }
    Invoke-FabricKQLCommand @params

    Runs the query in the KQL Database 'MyEventhouse' and returns the rows as an array of PowerShell objects.

.EXAMPLE
    $params = @{
        WorkspaceId     = '12345678-1234-1234-1234-123456789012'
        KQLDatabaseId   = '87654321-4321-4321-4321-210987654321'
        KQLCommand      = 'StormEvents | count'
        ReturnRawResult = $true
    }
    Invoke-FabricKQLCommand @params

    Runs the query in the KQL Database with the given Id and returns the raw response of the Kusto API.

.NOTES
    Author: Frank Geisler, Kamil Nowinski
    #>
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param (
        [Parameter(Mandatory = $true)]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [string]$KQLDatabaseName,

        [Parameter(Mandatory = $true, ParameterSetName = 'ById')]
        [guid]$KQLDatabaseId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLCommand,

        [switch]$ReturnRawResult
    )

    Confirm-TokenState

    # Resolve the KQL Database
    $getDatabaseParams = @{ WorkspaceId = $WorkspaceId }
    if ($PSCmdlet.ParameterSetName -eq 'ById') {
        $getDatabaseParams.KQLDatabaseId = $KQLDatabaseId
    } else {
        $getDatabaseParams.KQLDatabaseName = $KQLDatabaseName
    }
    $kqlDatabase = Get-FabricKQLDatabase @getDatabaseParams | Select-Object -First 1
    if ($null -eq $kqlDatabase) {
        throw "KQL Database '$($KQLDatabaseName)$($KQLDatabaseId)' not found in workspace '$WorkspaceId'."
    }

    $queryServiceUri = $kqlDatabase.properties.queryServiceUri
    if ([string]::IsNullOrWhiteSpace($queryServiceUri)) {
        throw "KQL Database '$($kqlDatabase.displayName)' has no query service URI."
    }
    Write-Message -Message "Query service URI: $queryServiceUri" -Level Debug

    # The Kusto query service requires a token issued for the Kusto API, not the Fabric API
    $kustoResourceUrl = Get-PSFConfigValue -FullName 'FabricTools.KustoApi.BaseUrl'
    Write-Message -Message "Get authentication token from $kustoResourceUrl" -Level Verbose
    $kustoToken = (Get-AzAccessToken -ResourceUrl $kustoResourceUrl -ErrorAction Stop).Token
    if ($kustoToken -is [securestring]) {
        $kustoToken = [System.Net.NetworkCredential]::new('', $kustoToken).Password
    }
    $kustoHeaders = @{ Authorization = "Bearer $kustoToken" }

    # Commands starting with a dot are management commands, everything else is a query
    $isManagementCommand = $KQLCommand.TrimStart().StartsWith('.')
    if ($isManagementCommand) {
        $endpoint = 'mgmt'
        if ($KQLCommand -notmatch '\.execute database script <\|') {
            $KQLCommand = ".execute database script <| $KQLCommand"
        }
    } else {
        $endpoint = 'query'
    }
    Write-Message -Message "Executing KQL $($endpoint) command: $KQLCommand" -Level Verbose

    $apiEndpointUrl = "{0}/v1/rest/{1}" -f $queryServiceUri.TrimEnd('/'), $endpoint

    $body = @{
        db  = $kqlDatabase.displayName
        csl = $KQLCommand
    }
    $bodyJson = $body | ConvertTo-Json -Depth 10

    $apiParams = @{
        Uri            = $apiEndpointUrl
        Method         = 'Post'
        Body           = $bodyJson
        Headers        = $kustoHeaders
        TypeName       = 'KQL Database'
        ObjectIdOrName = $kqlDatabase.displayName
        HandleResponse = $true
        ExtractValue   = 'False'
    }
    $response = Invoke-FabricRestMethod @apiParams

    if ($isManagementCommand -or $ReturnRawResult) {
        return $response
    }

    # Convert the primary result table into PowerShell objects
    $table = @($response.Tables)[0]
    if ($null -eq $table) {
        return
    }
    $columnNames = @($table.Columns | ForEach-Object { $_.ColumnName })
    foreach ($row in $table.Rows) {
        $record = [ordered]@{}
        for ($i = 0; $i -lt $columnNames.Count; $i++) {
            $record[$columnNames[$i]] = $row[$i]
        }
        [PSCustomObject]$record
    }
}
