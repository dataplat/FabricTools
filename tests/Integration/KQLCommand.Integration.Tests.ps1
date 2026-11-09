#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}
<#
.SYNOPSIS
    Integration tests for Invoke-FabricKQLCommand against a live KQL Database.

.DESCRIPTION
    Exercises Invoke-FabricKQLCommand (and Invoke-FabricRestMethod -ApiType Kusto) end-to-end:
      1. Create a temporary workspace (with capacity assignment)
      2. Create an Eventhouse and wait for its default KQL Database to get a query service URI
      3. Run a query by KQL Database name and convert the rows to PowerShell objects
      4. Run a query by KQL Database Id and return the raw response (-Raw)
      5. Run a query that returns no rows
      6. Run a management command (create a table) and verify it via a query
      7. Run an invalid query and expect an error
      8. Remove the Eventhouse
      9. Delete the workspace

    Prerequisites:
      - An authenticated Fabric session (run Connect-FabricAccount first)
      - At least one Fabric capacity accessible to the authenticated principal
      - Permission to get an access token for the Kusto API (FabricTools.KustoApi.ResourceUrl)

    Run:
      Invoke-Pester -Path "tests/Integration/KQLCommand.Integration.Tests.ps1" -Tag "Integration" -Output Detailed
#>

BeforeAll {
    $timestamp = Get-Date -Format 'yyyyMMddHHmmss'
    $script:WorkspaceId     = $null
    $script:CapacityId      = $null
    $script:EventhouseId    = $null
    $script:KQLDatabase     = $null
    $script:WorkspaceName   = "IntTest_KQLCommand_$timestamp"
    $script:EventhouseName  = "IntTest_EH_$timestamp"
    $script:TableName       = "IntTestTable_$timestamp"

    # Discover first available capacity (required to create Fabric items)
    $capacity = Get-FabricCapacity | Select-Object -First 1
    if (-not $capacity) {
        Write-Warning "No Fabric capacity found. Integration tests will be skipped."
    } else {
        $script:CapacityId = $capacity.Id
        Write-Host "Using capacity: '$($capacity.DisplayName)' ($($capacity.Id))"
    }
}

AfterAll {
    # Guaranteed cleanup - runs even when tests fail
    if ($script:EventhouseId -and $script:WorkspaceId) {
        try {
            Remove-FabricEventhouse -WorkspaceId $script:WorkspaceId -EventhouseId $script:EventhouseId -Confirm:$false -ErrorAction SilentlyContinue
            Write-Host "Cleanup: eventhouse '$($script:EventhouseId)' deleted."
        } catch {
            Write-Warning "Cleanup failed for eventhouse '$($script:EventhouseId)': $_"
        }
    }

    if ($script:WorkspaceId) {
        try {
            Remove-FabricWorkspace -WorkspaceId $script:WorkspaceId -Confirm:$false -ErrorAction SilentlyContinue
            Write-Host "Cleanup: workspace '$($script:WorkspaceId)' deleted."
        } catch {
            Write-Warning "Cleanup failed for workspace '$($script:WorkspaceId)': $_"
        }
    }
}

Describe "KQL Command Execution" -Tag "Integration" {

    # -----------------------------------------------------------------------
    Context "Step 1 - Create Workspace" {

        It "Should skip all tests when no capacity is available" -Skip:($null -ne $script:CapacityId) {
            Set-ItResult -Skipped -Because "No Fabric capacity is available in this tenant"
        }

        BeforeAll {
            if (-not $script:CapacityId) { return }
            $script:CreateWorkspaceResult = New-FabricWorkspace -WorkspaceName $script:WorkspaceName
            if ($script:CreateWorkspaceResult) {
                $script:WorkspaceId = $script:CreateWorkspaceResult.Id
                Add-FabricWorkspaceCapacity -WorkspaceId $script:WorkspaceId -CapacityId $script:CapacityId
                Start-Sleep -Seconds 3
            }
        }

        It "Should create the workspace with a valid Id" {
            $script:WorkspaceId | Should -Not -BeNullOrEmpty
            { [guid]$script:WorkspaceId } | Should -Not -Throw
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 2 - Create Eventhouse and wait for its KQL Database" {

        BeforeAll {
            if (-not $script:WorkspaceId) { return }
            $eventhouseParams = @{
                WorkspaceId           = $script:WorkspaceId
                EventhouseName        = $script:EventhouseName
                EventhouseDescription = 'Created by integration test'
                Confirm               = $false
            }
            $script:CreateEventhouseResult = New-FabricEventhouse @eventhouseParams
            if ($script:CreateEventhouseResult) {
                $script:EventhouseId = $script:CreateEventhouseResult.Id
            }

            # The default KQL Database is provisioned with the Eventhouse; wait until it has a query service URI
            $deadline = (Get-Date).AddMinutes(3)
            while (-not $script:KQLDatabase -and (Get-Date) -lt $deadline) {
                $script:KQLDatabase = Get-FabricKQLDatabase -WorkspaceId $script:WorkspaceId |
                    Where-Object { $_.properties.parentEventhouseItemId -eq $script:EventhouseId -and $_.properties.queryServiceUri } |
                    Select-Object -First 1
                if (-not $script:KQLDatabase) { Start-Sleep -Seconds 10 }
            }
            if ($script:KQLDatabase) {
                Write-Host "Using KQL Database: '$($script:KQLDatabase.displayName)' ($($script:KQLDatabase.id))"
                Write-Host "Query service URI: $($script:KQLDatabase.properties.queryServiceUri)"
            }
        }

        It "Should create the eventhouse with a valid Id" {
            $script:EventhouseId | Should -Not -BeNullOrEmpty
            { [guid]$script:EventhouseId } | Should -Not -Throw
        }

        It "Should provision a KQL Database with a query service URI" {
            $script:KQLDatabase | Should -Not -BeNullOrEmpty
            $script:KQLDatabase.properties.queryServiceUri | Should -Match '^https://'
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 3 - Query by KQL Database name" {

        BeforeAll {
            if (-not $script:KQLDatabase) { return }
            $script:QueryError = $null
            try {
                $queryParams = @{
                    WorkspaceId     = $script:WorkspaceId
                    KQLDatabaseName = $script:KQLDatabase.displayName
                    KQLCommand      = 'range Number from 1 to 3 step 1 | extend Label = strcat("item", Number)'
                }
                $script:QueryResult = @(Invoke-FabricKQLCommand @queryParams)
            } catch {
                $script:QueryError = $_
            }
        }

        It "Should run the query without throwing" {
            $script:QueryError | Should -BeNullOrEmpty
        }

        It "Should return one PowerShell object per row" {
            $script:QueryResult.Count | Should -Be 3
        }

        It "Should map the columns to properties" {
            $script:QueryResult[0].Number | Should -Be 1
            $script:QueryResult[2].Number | Should -Be 3
            $script:QueryResult[1].Label | Should -Be 'item2'
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 4 - Query by KQL Database Id with -Raw" {

        BeforeAll {
            if (-not $script:KQLDatabase) { return }
            $script:RawError = $null
            try {
                $rawParams = @{
                    WorkspaceId   = $script:WorkspaceId
                    KQLDatabaseId = $script:KQLDatabase.id
                    KQLCommand    = 'print Name = "test", Value = 42'
                    Raw           = $true
                }
                $script:RawResult = Invoke-FabricKQLCommand @rawParams
            } catch {
                $script:RawError = $_
            }
        }

        It "Should run the query without throwing" {
            $script:RawError | Should -BeNullOrEmpty
        }

        It "Should return the raw Kusto response with result tables" {
            $script:RawResult.Tables | Should -Not -BeNullOrEmpty
        }

        It "Should contain the expected columns and row in the primary table" {
            $table = $script:RawResult.Tables[0]
            $table.Columns.ColumnName | Should -Be @('Name', 'Value')
            $table.Rows[0][0] | Should -Be 'test'
            $table.Rows[0][1] | Should -Be 42
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 5 - Query returning no rows" {

        BeforeAll {
            if (-not $script:KQLDatabase) { return }
            $script:EmptyError = $null
            try {
                $emptyParams = @{
                    WorkspaceId     = $script:WorkspaceId
                    KQLDatabaseName = $script:KQLDatabase.displayName
                    KQLCommand      = 'range Number from 1 to 3 step 1 | where Number > 10'
                }
                $script:EmptyResult = @(Invoke-FabricKQLCommand @emptyParams)
            } catch {
                $script:EmptyError = $_
            }
        }

        It "Should run the query without throwing" {
            $script:EmptyError | Should -BeNullOrEmpty
        }

        It "Should return no objects" {
            $script:EmptyResult.Count | Should -Be 0
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 6 - Management command" {

        BeforeAll {
            if (-not $script:KQLDatabase) { return }
            $script:MgmtError = $null
            try {
                $mgmtParams = @{
                    WorkspaceId     = $script:WorkspaceId
                    KQLDatabaseName = $script:KQLDatabase.displayName
                    KQLCommand      = ".create table $($script:TableName) (Name: string, Value: int)"
                }
                $script:MgmtResult = Invoke-FabricKQLCommand @mgmtParams

                $schemaParams = @{
                    WorkspaceId     = $script:WorkspaceId
                    KQLDatabaseName = $script:KQLDatabase.displayName
                    KQLCommand      = "$($script:TableName) | getschema"
                }
                $script:SchemaResult = @(Invoke-FabricKQLCommand @schemaParams)
            } catch {
                $script:MgmtError = $_
            }
        }

        It "Should run the management command without throwing" {
            $script:MgmtError | Should -BeNullOrEmpty
        }

        It "Should return the raw response of the management command" {
            $script:MgmtResult.Tables | Should -Not -BeNullOrEmpty
        }

        It "Should have created the table with the expected columns" {
            $script:SchemaResult.ColumnName | Should -Be @('Name', 'Value')
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 7 - Invalid query" {

        It "Should throw when the query references a table that does not exist" {
            if (-not $script:KQLDatabase) {
                Set-ItResult -Skipped -Because "No KQL Database was provisioned"
                return
            }
            $invalidParams = @{
                WorkspaceId     = $script:WorkspaceId
                KQLDatabaseName = $script:KQLDatabase.displayName
                KQLCommand      = 'ThisTableDoesNotExist | take 1'
            }
            { Invoke-FabricKQLCommand @invalidParams } | Should -Throw
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 8 - Remove Eventhouse" {

        BeforeAll {
            if (-not $script:WorkspaceId -or -not $script:EventhouseId) { return }
            $script:RemoveError = $null
            try {
                Remove-FabricEventhouse -WorkspaceId $script:WorkspaceId -EventhouseId $script:EventhouseId -Confirm:$false
            } catch {
                $script:RemoveError = $_
            }
            # Clear Id so AfterAll does not attempt a double-delete
            $script:EventhouseId = $null
        }

        It "Should remove the eventhouse without throwing" {
            $script:RemoveError | Should -BeNullOrEmpty
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 9 - Delete Workspace" {

        BeforeAll {
            if (-not $script:WorkspaceId) { return }
            $script:DeleteWorkspaceError = $null
            try {
                Remove-FabricWorkspace -WorkspaceId $script:WorkspaceId -Confirm:$false
            } catch {
                $script:DeleteWorkspaceError = $_
            }
            $script:DeletedWorkspaceId = $script:WorkspaceId
            $script:WorkspaceId = $null
        }

        It "Should delete the workspace without throwing" {
            $script:DeleteWorkspaceError | Should -BeNullOrEmpty
        }

        It "Should not find the workspace after deletion" {
            $gone = Get-FabricWorkspace -WorkspaceId $script:DeletedWorkspaceId
            $gone | Should -BeNullOrEmpty
        }
    }
}
