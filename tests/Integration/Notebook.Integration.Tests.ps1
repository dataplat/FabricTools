#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}
<#
.SYNOPSIS
    Integration tests for Notebook item lifecycle operations.

.DESCRIPTION
    Exercises the Fabric REST API end-to-end across six steps:
      1. Create a temporary workspace (with capacity assignment)
      2. Create a notebook in that workspace
      3. Get the notebook by Id
      4. Get the notebook by Name
      5. Update the notebook name and description
      6. Verify the update via Get
      7. Remove the notebook
      8. Verify the notebook is gone
      9. Delete the workspace

    Prerequisites:
      - An authenticated Fabric session (run Connect-FabricAccount first)
      - At least one Fabric capacity accessible to the authenticated principal

    Run:
      Invoke-Pester -Path "tests/Integration/" -Tag "Integration" -Output Detailed
#>

BeforeAll {
    $script:WorkspaceId    = $null
    $script:CapacityId     = $null
    $script:NotebookId     = $null
    $script:WorkspaceName  = "IntTest_Notebook_$(Get-Date -Format 'yyyyMMddHHmmss')"
    $script:NotebookName   = "IntTest_NB_$(Get-Date -Format 'yyyyMMddHHmmss')"
    $script:NotebookNameUpdated = "$($script:NotebookName)_Updated"

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
    # Guaranteed cleanup — runs even when tests fail
    if ($script:NotebookId -and $script:WorkspaceId) {
        try {
            Remove-FabricNotebook -WorkspaceId $script:WorkspaceId -NotebookId $script:NotebookId -Confirm:$false -ErrorAction SilentlyContinue
            Write-Host "Cleanup: notebook '$($script:NotebookId)' deleted."
        } catch {
            Write-Warning "Cleanup failed for notebook '$($script:NotebookId)': $_"
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

Describe "Notebook Lifecycle" -Tag "Integration" {

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

        It "Should create the workspace and return a non-null result" {
            $script:CreateWorkspaceResult | Should -Not -BeNullOrEmpty
        }

        It "Should return a workspace with a valid Id" {
            $script:WorkspaceId | Should -Not -BeNullOrEmpty
            { [guid]$script:WorkspaceId } | Should -Not -Throw
        }

        It "Should return a workspace with the expected display name" {
            $script:CreateWorkspaceResult.DisplayName | Should -Be $script:WorkspaceName
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 2 - Create Notebook" {

        BeforeAll {
            if (-not $script:WorkspaceId) { return }
            $script:CreateNotebookResult = New-FabricNotebook `
                -WorkspaceId $script:WorkspaceId `
                -NotebookName $script:NotebookName `
                -NotebookDescription "Created by integration test" `
                -Confirm:$false
            if ($script:CreateNotebookResult) {
                $script:NotebookId = $script:CreateNotebookResult.Id
            }
        }

        It "Should create the notebook without returning null" {
            $script:CreateNotebookResult | Should -Not -BeNullOrEmpty
        }

        It "Should return a notebook with a valid Id" {
            $script:NotebookId | Should -Not -BeNullOrEmpty
            { [guid]$script:NotebookId } | Should -Not -Throw
        }

        It "Should return a notebook with the expected display name" {
            $script:CreateNotebookResult.DisplayName | Should -Be $script:NotebookName
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 3 - Get Notebook by Id" {

        BeforeAll {
            if (-not $script:WorkspaceId -or -not $script:NotebookId) { return }
            $script:GetByIdResult = Get-FabricNotebook `
                -WorkspaceId $script:WorkspaceId `
                -NotebookId $script:NotebookId
        }

        It "Should retrieve the notebook by Id" {
            $script:GetByIdResult | Should -Not -BeNullOrEmpty
        }

        It "Should return the correct Id" {
            $script:GetByIdResult.Id | Should -Be $script:NotebookId.ToString()
        }

        It "Should return the correct display name" {
            $script:GetByIdResult.DisplayName | Should -Be $script:NotebookName
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 4 - Get Notebook by Name" {

        BeforeAll {
            if (-not $script:WorkspaceId) { return }
            $script:GetByNameResult = Get-FabricNotebook `
                -WorkspaceId $script:WorkspaceId `
                -NotebookName $script:NotebookName
        }

        It "Should retrieve the notebook by Name" {
            $script:GetByNameResult | Should -Not -BeNullOrEmpty
        }

        It "Should return the correct Id when retrieved by Name" {
            $script:GetByNameResult.Id | Should -Be $script:NotebookId.ToString()
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 5 - Update Notebook" {

        BeforeAll {
            if (-not $script:WorkspaceId -or -not $script:NotebookId) { return }
            $script:UpdateError = $null
            $script:UpdateResult = $null
            try {
                $script:UpdateResult = Update-FabricNotebook `
                    -WorkspaceId $script:WorkspaceId `
                    -NotebookId $script:NotebookId `
                    -NotebookName $script:NotebookNameUpdated `
                    -NotebookDescription "Updated by integration test" `
                    -Confirm:$false
            } catch {
                $script:UpdateError = $_
            }
        }

        It "Should update the notebook without throwing" {
            $script:UpdateError | Should -BeNullOrEmpty
        }

        It "Should return the updated notebook object" {
            $script:UpdateResult | Should -Not -BeNullOrEmpty
        }

        It "Should return the updated display name" {
            $script:UpdateResult.DisplayName | Should -Be $script:NotebookNameUpdated
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 6 - Verify Update via Get" {

        BeforeAll {
            if (-not $script:WorkspaceId -or -not $script:NotebookId) { return }
            $script:GetAfterUpdateResult = Get-FabricNotebook `
                -WorkspaceId $script:WorkspaceId `
                -NotebookId $script:NotebookId
        }

        It "Should find the notebook under its updated name" {
            $script:GetAfterUpdateResult | Should -Not -BeNullOrEmpty
            $script:GetAfterUpdateResult.DisplayName | Should -Be $script:NotebookNameUpdated
        }

        It "Should not find the notebook under its original name" {
            $gone = Get-FabricNotebook -WorkspaceId $script:WorkspaceId -NotebookName $script:NotebookName
            $gone | Should -BeNullOrEmpty
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 7 - Remove Notebook" {

        BeforeAll {
            if (-not $script:WorkspaceId -or -not $script:NotebookId) { return }
            $script:RemoveError = $null
            try {
                Remove-FabricNotebook `
                    -WorkspaceId $script:WorkspaceId `
                    -NotebookId $script:NotebookId `
                    -Confirm:$false
            } catch {
                $script:RemoveError = $_
            }
            # Clear Id so AfterAll does not attempt a double-delete
            $script:DeletedNotebookId = $script:NotebookId
            $script:NotebookId = $null
        }

        It "Should remove the notebook without throwing" {
            $script:RemoveError | Should -BeNullOrEmpty
        }

        It "Should not find the notebook after removal" {
            $gone = Get-FabricNotebook -WorkspaceId $script:WorkspaceId -NotebookId $script:DeletedNotebookId
            $gone | Should -BeNullOrEmpty
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
