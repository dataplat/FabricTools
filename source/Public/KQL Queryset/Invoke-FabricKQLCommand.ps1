function Invoke-FabricKQLCommand {
    <#
.SYNOPSIS
    Executes a KQL command in a Kusto Database.

.DESCRIPTION
    Executes a KQL command in a Kusto Database. The KQL command is executed in the Kusto Database that is specified by the KQLDatabaseName or KQLDatabaseId parameter. The KQL command is executed in the context of the Fabric Real-Time Intelligence session that is established by the Connect-RTISession cmdlet. The cmdlet distinguishes between management commands and query commands. Management commands are executed in the management API, while query commands are executed in the query API. The distinction is made by checking if the KQL command starts with a dot. If it does, it is a management command else it is a query command. If the KQL command is a management command, it is crucial to have the execute database script <| in the beginning, otherwise the Kusto API will not execute the script. This cmdlet will automatically add the .execute database script <| in the beginning of the KQL command if it is a management command and if it is not already present. If the KQL Command is a query command, the result is returned as an array of PowerShell objects by default. If the parameter -ReturnRawResult is used, the raw result of the KQL query is returned which is a JSON object.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the KQL command should be executed. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER KQLDatabaseName
    The name of the KQLDatabase in which the KQL command should be executed. This parameter cannot be used together with KQLDatabaseId.

.PARAMETER KQLDatabaseId
    The Id of the KQLDatabase in which the KQL command should be executed. This parameter cannot be used together with KQLDatabaseName.
    The value for KQLDatabaseId is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER KQLCommand
    The KQL command that should be executed in the Kusto Database.
    The KQL command is a string. An example of a string is '.create table MyTable (MyColumn: string)'.

.PARAMETER ReturnRawResult
    When this switch is used, the raw result of the KQL command is returned. By default, the result is returned as
    a PowerShell object.

.EXAMPLE
    Invoke-FabricKQLCommand -WorkspaceId '12345678-1234-1234-1234-123456789012' -KQLDatabaseName 'MyKQLDatabase'-KQLCommand '.create table MyTable (MyColumn: string)

    This example will create a table named 'MyTable' with a column named 'MyColumn' in
    the KQLDatabase 'MyKQLDatabase'.

.EXAMPLE
    Invoke-FabricKQLCommand `
                -WorkspaceId '2c4ccbb5-9b13-4495-9ab3-ba41152733d9' `
                -KQLDatabaseName 'MyEventhouse2' `
                -KQLCommand 'productcategory
                            | take 100'

    This example will Execute the Query 'productcategory | take 100' in the KQLDatabase 'MyEventhouse2'
    and it will return the result as an array of PowerShell objects.

.EXAMPLE
    Invoke-FabricKQLCommand `
                -WorkspaceId '2c4ccbb5-9b13-4495-9ab3-ba41152733d9' `
                -KQLDatabaseName 'MyEventhouse2' `
                -ReturnRawResult `
                -KQLCommand 'productcategory
                            | take 100'

    This example will Execute the Query 'productcategory | take 100' in the KQLDatabase 'MyEventhouse2'
    and it will return the result as the raw result of the KQL command, which is a JSON object.

.NOTES
    Revision History:

    2024-12-22 - FGE: Added Verbose Output
    2024-12-27 - FGE: Major Update to support KQL Queries and Management Commands

    #>

    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [string]$KQLDatabaseName,

        [string]$KQLDatabaseId,

        [Parameter(Mandatory = $true)]
        [string]$KQLCommand,

        [switch]$ReturnRawResult
    )

    begin {

        Confirm-TokenState

        Write-Verbose "Check if KQLDatabaseName and KQLDatabaseId are used together"
        if ($PSBoundParameters.ContainsKey("KQLDatabaseName") -and $PSBoundParameters.ContainsKey("KQLDatabaseId")) {
            throw "Parameters KQLDatabaseName and KQLDatabaseId cannot be used together"
        }

        Write-Verbose "Get Kusto Database"
        if ($PSBoundParameters.ContainsKey("KQLDatabaseName")) {
            Write-Verbose "Getting Kusto Database by Name: $KQLDatabaseName"
            $kustDB = Get-FabricKQLDatabase `
                -WorkspaceId $WorkspaceId `
                -KQLDatabaseName $KQLDatabaseName
        }

        if ($PSBoundParameters.ContainsKey("KQLDatabaseId")) {
            Write-Verbose "Getting Kusto Database by Id: $KQLDatabaseId"
            $kustDB = Get-FabricKQLDatabase `
                -WorkspaceId $WorkspaceId `
                -KQLDatabaseId $KQLDatabaseId
        }

        Write-Verbose "Check if Kusto Database was found"
        if ($null -eq $kustDB) {
            throw "Kusto Database not found"
        }

        Write-Verbose "Generate the Management API URL"
        $mgmtAPI = "$($kustDB.queryServiceUri)/v1/rest/mgmt"

        Write-Verbose "Generate the query API URL"
        $queryAPI = "$($kustDB.queryServiceUri)/v1/rest/query"


        $KQLCommand = $KQLCommand | Out-String

        Write-Verbose "Check if the KQL command starts with a dot so it is a management command. Otherwise it is a query command"
        if (-not ($KQLCommand -match "^\.")) {
            $isManamgentCommand = $false
            Write-Verbose "The command is a query command."
        } else {
            $isManamgentCommand = $true
            Write-Verbose "The command is a management command. It is crucial to have the .execute database script <| in the beginning, otherwise the Kusto API will not execute the script."
            if (-not ($KQLCommand -match "\.execute database script <\|")) {
                $KQLCommand = ".execute database script <| $KQLCommand"
            }
        }
    }

    process {

        Write-Verbose "The KQL-Command is: $KQLCommand"

        Write-Verbose "Create body of the request"
        $body = @{
            'csl' = $KQLCommand;
            'db'  = $kustDB.displayName
        } | ConvertTo-Json -Depth 1


        if ($isManamgentCommand) {
            Write-Verbose "Calling Management API"
            Write-Verbose "----------------------"
            Write-Verbose "Sending the following values to the Query API:"
            Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
            Write-Verbose "Method: POST"
            Write-Verbose "URI: $mgmtAPI"
            Write-Verbose "Body of request: $body"
            Write-Verbose "ContentType: application/json"

            $result = Invoke-RestMethod `
                -Headers $headerParams `
                -Method POST `
                -Uri $mgmtAPI `
                -Body ($body) `
                -ContentType "application/json; charset=utf-8"

            Write-Verbose "Result of the Management API: $($result | `
                                                            ConvertTo-Json `
                                                                -Depth 10)"
            $result
        } else {
            Write-Verbose "Calling Query API"
            Write-Verbose "-----------------"
            Write-Verbose "Sending the following values to the Query API:"
            Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
            Write-Verbose "Method: POST"
            Write-Verbose "URI: $queryAPI"
            Write-Verbose "Body of request: $body"
            Write-Verbose "ContentType: application/json"

            $result = Invoke-RestMethod `
                -Headers $headerParams `
                -Method POST `
                -Uri $queryAPI `
                -Body ($body) `
                -ContentType "application/json; charset=utf-8"
            Write-Verbose "Result of the Query API: $($result | `
                                                        ConvertTo-Json `
                                                             -Depth 10)"



            if ($ReturnRawResult) {
                $result
            } else {
                $myRecords = @()

                for ($j = 0; $j -lt $Result.tables[0].rows.Count; $j++) {
                    $myTableRow = [PSCustomObject]@{ }

                    for ($i = 0; $i -lt $Result.tables[0].rows[0].Count; $i++) {
                        $myTableRow | `
                                Add-Member `
                                -MemberType NoteProperty `
                                -Name $Result.Tables[0].Columns[$i].ColumnName `
                                -Value $Result.Tables[0].rows[$j][$i]
                    }
                    $myRecords += $myTableRow
                }

                $myRecords
            }

        }
    }

    end { }

}
