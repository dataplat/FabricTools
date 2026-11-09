#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Invoke-FabricKQLCommand'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Invoke-FabricKQLCommand
}

Describe "Invoke-FabricKQLCommand" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'KQLDatabaseName'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'KQLDatabaseId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'KQLCommand'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'Raw'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should keep ReturnRawResult as an alias of Raw' {
            $Command.Parameters['Raw'].Aliases | Should -Contain 'ReturnRawResult'
        }

        It 'Should not allow KQLDatabaseName and KQLDatabaseId together' {
            { Invoke-FabricKQLCommand -WorkspaceId (New-Guid) -KQLDatabaseName 'db' -KQLDatabaseId (New-Guid) -KQLCommand 'T' } |
                Should -Throw -ErrorId 'AmbiguousParameterSet,Invoke-FabricKQLCommand'
        }
    }

    Context "Successful KQL command invocation" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Get-FabricKQLDatabase -MockWith {
                [pscustomobject]@{
                    id          = '11111111-1111-1111-1111-111111111111'
                    displayName = 'TestDB'
                    properties  = [pscustomobject]@{
                        queryServiceUri = 'https://test.kusto.fabric.microsoft.com'
                    }
                }
            }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                [pscustomobject]@{
                    Tables = @(
                        [pscustomobject]@{
                            TableName = 'Table_0'
                            Columns   = @(
                                [pscustomobject]@{ ColumnName = 'Name'; DataType = 'String' }
                                [pscustomobject]@{ ColumnName = 'Count'; DataType = 'Int64' }
                            )
                            Rows      = @(
                                , @('a', 1)
                                , @('b', 2)
                            )
                        }
                    )
                }
            }
        }

        It 'Should send a query to the query endpoint of the Kusto API' {
            Invoke-FabricKQLCommand -WorkspaceId (New-Guid) -KQLDatabaseName 'TestDB' -KQLCommand 'T | take 10' | Out-Null

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -eq 'https://test.kusto.fabric.microsoft.com/v1/rest/query' -and
                $Method -eq 'Post' -and
                ($Body | ConvertFrom-Json).db -eq 'TestDB' -and
                ($Body | ConvertFrom-Json).csl -eq 'T | take 10' -and
                $ApiType -eq 'Kusto' -and
                $HandleResponse -eq $true
            }
        }

        It 'Should look up the database by Id' {
            $databaseId = [guid]'22222222-2222-2222-2222-222222222222'
            Invoke-FabricKQLCommand -WorkspaceId (New-Guid) -KQLDatabaseId $databaseId -KQLCommand 'T' | Out-Null

            Should -Invoke -CommandName Get-FabricKQLDatabase -Times 1 -Exactly -ParameterFilter {
                $KQLDatabaseId -eq $databaseId
            }
        }

        It 'Should convert query results to PowerShell objects' {
            $result = @(Invoke-FabricKQLCommand -WorkspaceId (New-Guid) -KQLDatabaseName 'TestDB' -KQLCommand 'T')

            $result.Count | Should -Be 2
            $result[0].Name | Should -Be 'a'
            $result[0].Count | Should -Be 1
            $result[1].Name | Should -Be 'b'
            $result[1].Count | Should -Be 2
        }

        It 'Should return the raw response when <_> is used' -ForEach @('Raw', 'ReturnRawResult') {
            $switchParam = @{ $_ = $true }
            $result = Invoke-FabricKQLCommand -WorkspaceId (New-Guid) -KQLDatabaseName 'TestDB' -KQLCommand 'T' @switchParam

            $result.Tables[0].TableName | Should -Be 'Table_0'
        }

        It 'Should send a management command to the mgmt endpoint wrapped in .execute database script' {
            Invoke-FabricKQLCommand -WorkspaceId (New-Guid) -KQLDatabaseName 'TestDB' -KQLCommand '.create table MyTable (MyColumn: string)' | Out-Null

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -eq 'https://test.kusto.fabric.microsoft.com/v1/rest/mgmt' -and
                ($Body | ConvertFrom-Json).csl -eq '.execute database script <| .create table MyTable (MyColumn: string)'
            }
        }

        It 'Should not wrap a management command that already uses .execute database script' {
            $command = ".execute database script <| .create table MyTable (MyColumn: string)"
            Invoke-FabricKQLCommand -WorkspaceId (New-Guid) -KQLDatabaseName 'TestDB' -KQLCommand $command | Out-Null

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                ($Body | ConvertFrom-Json).csl -eq $command
            }
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
        }

        It 'Should throw when the KQL Database is not found' {
            Mock -CommandName Get-FabricKQLDatabase -MockWith { $null }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }

            { Invoke-FabricKQLCommand -WorkspaceId (New-Guid) -KQLDatabaseName 'Missing' -KQLCommand 'T' } |
                Should -Throw -ExpectedMessage "*not found*"
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0 -Exactly
        }

        It 'Should throw when the KQL Database has no query service URI' {
            Mock -CommandName Get-FabricKQLDatabase -MockWith {
                [pscustomobject]@{ displayName = 'TestDB'; properties = [pscustomobject]@{} }
            }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }

            { Invoke-FabricKQLCommand -WorkspaceId (New-Guid) -KQLDatabaseName 'TestDB' -KQLCommand 'T' } |
                Should -Throw -ExpectedMessage "*no query service URI*"
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0 -Exactly
        }

        It 'Should throw an error when the API call fails' {
            Mock -CommandName Get-FabricKQLDatabase -MockWith {
                [pscustomobject]@{
                    displayName = 'TestDB'
                    properties  = [pscustomobject]@{ queryServiceUri = 'https://test.kusto.fabric.microsoft.com' }
                }
            }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { throw "API Error" }

            { Invoke-FabricKQLCommand -WorkspaceId (New-Guid) -KQLDatabaseName 'TestDB' -KQLCommand 'T' } |
                Should -Throw -ExpectedMessage "API Error"
        }
    }
}
