#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}
<#
.SYNOPSIS
    Integration tests for workspace-capacity lifecycle operations.

.DESCRIPTION
    Exercises the Fabric REST API end-to-end across four steps:
      1. Create a temporary workspace
      2. Assign it to the first available capacity
      3. Unassign it from the capacity
      4. Delete the workspace

    Prerequisites:
      - An authenticated Fabric session (run Connect-FabricAccount first)
      - At least one Fabric capacity accessible to the authenticated principal

    Run:
      Invoke-Pester -Path "tests/Integration/" -Tag "Integration" -Output Detailed
#>

BeforeAll {
    $script:WorkspaceId = $null
    $script:CapacityId  = $null
    $script:WorkspaceName = "IntTest_WsCapacity_$(Get-Date -Format 'yyyyMMddHHmmss')"

    # Discover first available capacity
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
    if ($script:WorkspaceId) {
        try {
            Remove-FabricWorkspace -WorkspaceId $script:WorkspaceId -Confirm:$false -ErrorAction SilentlyContinue
            Write-Host "Cleanup: workspace '$($script:WorkspaceId)' deleted."
        } catch {
            Write-Warning "Cleanup failed for workspace '$($script:WorkspaceId)': $_"
        }
    }
}

Describe "Workspace Capacity Lifecycle" -Tag "Integration" {

    # -----------------------------------------------------------------------
    Context "Step 1 - Create Workspace" {

        BeforeAll {
            if (-not $script:CapacityId) {
                return
            }
            $script:CreateResult = New-FabricWorkspace -WorkspaceName $script:WorkspaceName
        }

        It "Should skip when no capacity is available" -Skip:($null -ne $script:CapacityId) {
            Set-ItResult -Skipped -Because "No Fabric capacity is available in this tenant"
        }

        It "Should create the workspace and return a non-null result" {
            $script:CreateResult | Should -Not -BeNullOrEmpty
        }

        It "Should return a workspace object with a valid Id" {
            $script:CreateResult.Id | Should -Not -BeNullOrEmpty
            { [guid]$script:CreateResult.Id } | Should -Not -Throw
            $script:WorkspaceId = $script:CreateResult.Id
        }

        It "Should return a workspace with the expected display name" {
            $script:CreateResult.DisplayName | Should -Be $script:WorkspaceName
        }

        AfterAll {
            # Persist the Id for subsequent contexts even if It blocks are skipped
            if ($script:CreateResult) {
                $script:WorkspaceId = $script:CreateResult.Id
            }
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 2 - Assign Capacity" {

        BeforeAll {
            if (-not $script:WorkspaceId -or -not $script:CapacityId) {
                return
            }
            $script:AssignError = $null
            try {
                Add-FabricWorkspaceCapacity -WorkspaceId $script:WorkspaceId -CapacityId $script:CapacityId
            } catch {
                $script:AssignError = $_
            }

            # Allow a short moment for the async assignment to propagate
            Start-Sleep -Seconds 3
            $script:WorkspaceAfterAssign = Get-FabricWorkspace -WorkspaceId $script:WorkspaceId
        }

        It "Should assign the workspace to the capacity without throwing" {
            $script:AssignError | Should -BeNullOrEmpty
        }

        It "Should reflect capacityId on the workspace after assignment" {
            $script:WorkspaceAfterAssign | Should -Not -BeNullOrEmpty
            $script:WorkspaceAfterAssign.capacityId | Should -Not -BeNullOrEmpty
        }

        It "Should reflect the correct capacityId on the workspace" {
            $script:WorkspaceAfterAssign.capacityId | Should -Be $script:CapacityId.ToString()
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 3 - Unassign Capacity" {

        BeforeAll {
            if (-not $script:WorkspaceId) {
                return
            }
            $script:UnassignError = $null
            try {
                Remove-FabricWorkspaceCapacity -WorkspaceId $script:WorkspaceId -Confirm:$false
            } catch {
                $script:UnassignError = $_
            }

            # Allow a short moment for the async unassignment to propagate
            Start-Sleep -Seconds 3
            $script:WorkspaceAfterUnassign = Get-FabricWorkspace -WorkspaceId $script:WorkspaceId
        }

        It "Should unassign the workspace from the capacity without throwing" {
            $script:UnassignError | Should -BeNullOrEmpty
        }

        It "Should have no capacityId on the workspace after unassignment" {
            $script:WorkspaceAfterUnassign | Should -Not -BeNullOrEmpty
            $script:WorkspaceAfterUnassign.capacityId | Should -BeNullOrEmpty
        }
    }

    # -----------------------------------------------------------------------
    Context "Step 4 - Delete Workspace" {

        BeforeAll {
            if (-not $script:WorkspaceId) {
                return
            }
            $script:DeleteError = $null
            try {
                Remove-FabricWorkspace -WorkspaceId $script:WorkspaceId -Confirm:$false
            } catch {
                $script:DeleteError = $_
            }

            # Clear the Id so AfterAll cleanup does not attempt a double-delete
            $script:DeletedWorkspaceId = $script:WorkspaceId
            $script:WorkspaceId = $null
        }

        It "Should delete the workspace without throwing" {
            $script:DeleteError | Should -BeNullOrEmpty
        }

        It "Should not find the workspace via Get-FabricWorkspace after deletion" {
            $gone = Get-FabricWorkspace -WorkspaceId $script:DeletedWorkspaceId
            $gone | Should -BeNullOrEmpty
        }
    }
}
