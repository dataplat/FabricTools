#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}
<#
.SYNOPSIS
    Integration tests for pagination (continuation tokens) in Invoke-FabricRestMethod.

.DESCRIPTION
    Proves against the live Fabric REST API that Invoke-FabricRestMethod follows continuation tokens
    (issue #228). The Lakehouse "List Tables" API is used because it is the only Fabric list API that
    documents a page-size parameter (maxResults), so multiple pages can be forced with only a few tables.

      1. Create a temporary workspace (with capacity assignment)
      2. Create a Lakehouse (without schemas - List Tables does not support schema-enabled lakehouses)
      3. Upload three small CSV files to the Lakehouse Files via the OneLake DFS API and load them as tables
      4. Precondition: the raw API returns one table and a continuation token with maxResults=1
      5. Baseline: Get-FabricLakehouseTable returns all tables (single page)
      6. Pagination: Invoke-FabricRestMethod with maxResults=1 returns every table exactly once
      7. Remove the Lakehouse
      8. Delete the workspace

    Step 6 fails until #228 is fixed: the continuation token is never sent, so the first page is requested
    again and again. The call is bounded by -Timeout 1 (one minute), so expect up to a minute of repeated
    requests and the error "API request timed out after 1 minutes."

    Prerequisites:
      - An authenticated Fabric session (run Connect-FabricAccount first)
      - At least one active Fabric capacity accessible to the authenticated principal
      - Permission to get an access token for OneLake storage (https://storage.azure.com)

    Run:
      Invoke-Pester -Path "tests/Integration/Pagination.Integration.Tests.ps1" -Tag "Integration" -Output Detailed
#>

BeforeAll {
    $timestamp = Get-Date -Format 'yyyyMMddHHmmss'
    $script:WorkspaceId   = $null
    $script:CapacityId    = $null
    $script:LakehouseId   = $null
    $script:WorkspaceName = "IntTest_Pagination_$timestamp"
    $script:LakehouseName = "IntTest_LH_$timestamp"
    $script:TableNames    = @('pagetest_a', 'pagetest_b', 'pagetest_c')

    # Discover first active Fabric capacity (required to create Fabric items)
    $capacity = Get-FabricCapacity | Where-Object { $_.state -eq 'Active' } | Select-Object -First 1
    if (-not $capacity) {
        Write-Warning "No active Fabric capacity found. Integration tests will be skipped."
    } else {
        $script:CapacityId = $capacity.Id
        Write-Host "Using capacity: '$($capacity.DisplayName)' ($($capacity.Id))"
    }

    # Uploads a small text file to the Lakehouse Files area using the OneLake (ADLS Gen2 compatible) DFS API
    function Send-OneLakeTestFile {
        param (
            [guid]$WorkspaceId,
            [guid]$LakehouseId,
            [string]$FileName,
            [string]$Content
        )
        $token = (Get-AzAccessToken -ResourceUrl 'https://storage.azure.com' -ErrorAction Stop).Token
        if ($token -is [securestring]) {
            $token = [System.Net.NetworkCredential]::new('', $token).Password
        }
        $headers = @{
            Authorization  = "Bearer $token"
            'x-ms-version' = '2023-11-03'
        }
        $fileUrl = "https://onelake.dfs.fabric.microsoft.com/{0}/{1}/Files/{2}" -f $WorkspaceId, $LakehouseId, $FileName
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Content)

        $null = Invoke-RestMethod -Method Put -Uri "$($fileUrl)?resource=file" -Headers $headers
        $null = Invoke-RestMethod -Method Patch -Uri "$($fileUrl)?action=append&position=0" -Headers $headers -Body $bytes -ContentType 'application/octet-stream'
        $null = Invoke-RestMethod -Method Patch -Uri "$($fileUrl)?action=flush&position=$($bytes.Length)" -Headers $headers
    }
}

AfterAll {
    # Guaranteed cleanup - runs even when tests fail
    if ($script:LakehouseId -and $script:WorkspaceId) {
        try {
            Remove-FabricLakehouse -WorkspaceId $script:WorkspaceId -LakehouseId $script:LakehouseId -Confirm:$false -ErrorAction SilentlyContinue
            Write-Host "Cleanup: lakehouse '$($script:LakehouseId)' deleted."
        } catch {
            Write-Warning "Cleanup failed for lakehouse '$($script:LakehouseId)': $_"
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

Describe "Pagination with continuation tokens" -Tag "Integration" {

    # -----------------------------------------------------------------------
    Context "Step 1 - Create Workspace" {

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
            if (-not $script:CapacityId) {
                Set-ItResult -Skipped -Because "No active Fabric capacity is available"
                return
            }
            $script:WorkspaceId | Should -Not -BeNullOrEmpty
            { [guid]$script:WorkspaceId } | Should -Not -Throw
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 2 - Create Lakehouse" {

        BeforeAll {
            if (-not $script:WorkspaceId) { return }
            $lakehouseParams = @{
                WorkspaceId            = $script:WorkspaceId
                LakehouseName          = $script:LakehouseName
                LakehouseDescription   = 'Created by pagination integration test'
                LakehouseEnableSchemas = $false
                Confirm                = $false
            }
            $script:CreateLakehouseResult = New-FabricLakehouse @lakehouseParams
            if ($script:CreateLakehouseResult) {
                $script:LakehouseId = $script:CreateLakehouseResult.Id
            }
        }

        It "Should create the lakehouse with a valid Id" {
            $script:LakehouseId | Should -Not -BeNullOrEmpty
            { [guid]$script:LakehouseId } | Should -Not -Throw
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 3 - Upload files and load them as tables" {

        BeforeAll {
            if (-not $script:LakehouseId) { return }
            $script:LoadError = $null
            try {
                foreach ($tableName in $script:TableNames) {
                    $fileName = "$tableName.csv"

                    # OneLake may need a moment after the Lakehouse is created; retry the upload briefly
                    $attempt = 0
                    while ($true) {
                        try {
                            Send-OneLakeTestFile -WorkspaceId $script:WorkspaceId -LakehouseId $script:LakehouseId -FileName $fileName -Content "Id,Name`n1,$tableName`n"
                            break
                        } catch {
                            $attempt++
                            if ($attempt -ge 6) { throw }
                            Start-Sleep -Seconds 10
                        }
                    }

                    $loadParams = @{
                        WorkspaceId  = $script:WorkspaceId
                        LakehouseId  = $script:LakehouseId
                        TableName    = $tableName
                        PathType     = 'File'
                        RelativePath = "Files/$fileName"
                        FileFormat   = 'CSV'
                        CsvHeader    = $true
                        Mode         = 'overwrite'
                        Confirm      = $false
                    }
                    $null = Write-FabricLakehouseTableData @loadParams
                }
            } catch {
                $script:LoadError = $_
            }
        }

        It "Should upload the files and load the tables without throwing" {
            $script:LoadError | Should -BeNullOrEmpty
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 4 - Precondition: the API returns multiple pages with maxResults=1" {

        BeforeAll {
            if (-not $script:LakehouseId) { return }
            $baseUrl = Get-PSFConfigValue -FullName 'FabricTools.FabricApi.BaseUrl'
            $headers = Get-PSFConfigValue -FullName 'FabricTools.FabricSession.Headers'
            $script:TablesUrl = "{0}/workspaces/{1}/lakehouses/{2}/tables" -f $baseUrl, $script:WorkspaceId, $script:LakehouseId
            $script:FirstPage = Invoke-RestMethod -Method Get -Uri "$($script:TablesUrl)?maxResults=1" -Headers $headers
        }

        It "Should return a single table on the first page" {
            @($script:FirstPage.data).Count | Should -Be 1
        }

        It "Should return a continuation token for the next page" {
            $script:FirstPage.continuationToken | Should -Not -BeNullOrEmpty
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 5 - Baseline: Get-FabricLakehouseTable (single page)" {

        BeforeAll {
            if (-not $script:LakehouseId) { return }
            $script:AllTables = @(Get-FabricLakehouseTable -WorkspaceId $script:WorkspaceId -LakehouseId $script:LakehouseId)
        }

        It "Should return all loaded tables" {
            @($script:AllTables.name | Sort-Object) | Should -Be $script:TableNames
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 6 - Invoke-FabricRestMethod follows continuation tokens (#228)" {

        BeforeAll {
            if (-not $script:LakehouseId) { return }
            $script:PagingError = $null
            $script:PagedTables = $null
            $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
            try {
                $apiParams = @{
                    Uri            = "workspaces/{0}/lakehouses/{1}/tables?maxResults=1" -f $script:WorkspaceId, $script:LakehouseId
                    Method         = 'Get'
                    TypeName       = 'Lakehouse Table'
                    HandleResponse = $true
                    Timeout        = 1   # minutes - bounds the endless loop caused by #228
                }
                # The tables endpoint returns rows under .data instead of .value
                $script:PagedTables = @(Invoke-FabricRestMethod @apiParams | ForEach-Object { $_.data })
            } catch {
                $script:PagingError = $_
            }
            $stopwatch.Stop()
            Write-Host "Paging took $([int]$stopwatch.Elapsed.TotalSeconds)s and returned $(@($script:PagedTables).Count) row(s)."
        }

        It "Should complete without timing out" {
            $script:PagingError | Should -BeNullOrEmpty
        }

        It "Should return every table exactly once across all pages" {
            @($script:PagedTables.name | Sort-Object) | Should -Be $script:TableNames
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 7 - Remove Lakehouse" {

        BeforeAll {
            if (-not $script:WorkspaceId -or -not $script:LakehouseId) { return }
            $script:RemoveError = $null
            try {
                Remove-FabricLakehouse -WorkspaceId $script:WorkspaceId -LakehouseId $script:LakehouseId -Confirm:$false
            } catch {
                $script:RemoveError = $_
            }
            # Clear Id so AfterAll does not attempt a double-delete
            $script:LakehouseId = $null
        }

        It "Should remove the lakehouse without throwing" {
            $script:RemoveError | Should -BeNullOrEmpty
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 8 - Delete Workspace" {

        BeforeAll {
            if (-not $script:WorkspaceId) { return }
            $script:DeleteWorkspaceError = $null
            try {
                Remove-FabricWorkspace -WorkspaceId $script:WorkspaceId -Confirm:$false
            } catch {
                $script:DeleteWorkspaceError = $_
            }
            $script:WorkspaceId = $null
        }

        It "Should delete the workspace without throwing" {
            $script:DeleteWorkspaceError | Should -BeNullOrEmpty
        }
    }
}
