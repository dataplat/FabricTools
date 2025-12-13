#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'New-FabricKQLDashboard'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'New-FabricKQLDashboard'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "New-FabricKQLDashboard" -Tag "UnitTests" {

    Context "Command definition" {
        BeforeAll {
            $command = Get-Command -Name $CommandName -Module $ModuleName
        }

        It "Command <CommandName> should exist" {
            $command | Should -Not -BeNullOrEmpty
        }

        It "Command <CommandName> should have WorkspaceId parameter" {
            $command | Should -HaveParameter 'WorkspaceId' -Type [guid]
        }

        It "Command <CommandName> should have KQLDashboardName parameter" {
            $command | Should -HaveParameter 'KQLDashboardName' -Type [string]
        }

        It "Command <CommandName> should have KQLDashboardDescription parameter" {
            $command | Should -HaveParameter 'KQLDashboardDescription' -Type [string]
        }

        It "Command <CommandName> should support ShouldProcess" {
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
        }
    }

    Context "Create KQL Dashboard successfully" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 201
                }
                return [pscustomobject]@{
                    id          = "00000000-0000-0000-0000-000000000001"
                    displayName = "TestKQLDashboard"
                    description = "Test KQL Dashboard Description"
                    type        = "KQLDashboard"
                }
            }
        }

        It "Should create a KQL dashboard" {
            $result = New-FabricKQLDashboard -WorkspaceId "00000000-0000-0000-0000-000000000000" -KQLDashboardName "TestKQLDashboard"
            $result | Should -Not -BeNullOrEmpty
            $result.displayName | Should -Be "TestKQLDashboard"

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -like "*workspaces/00000000-0000-0000-0000-000000000000/kqlDashboards" -and
                $Method -eq "Post"
            }
        }
    }

    Context "Long-running operation" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 202
                    $script:responseHeader = @{
                        'x-ms-operation-id' = "00000000-0000-0000-0000-000000000099"
                        'Location'          = "https://api.fabric.microsoft.com/operations/00000000-0000-0000-0000-000000000099"
                        'Retry-After'       = 1
                    }
                }
                return $null
            }

            Mock -CommandName Get-FabricLongRunningOperation -MockWith {
                return [pscustomobject]@{
                    status = "Succeeded"
                }
            }

            Mock -CommandName Get-FabricLongRunningOperationResult -MockWith {
                return [pscustomobject]@{
                    id          = "00000000-0000-0000-0000-000000000001"
                    displayName = "TestKQLDashboard"
                    type        = "KQLDashboard"
                }
            }
        }

        It "Should handle long-running operation" {
            $result = New-FabricKQLDashboard -WorkspaceId "00000000-0000-0000-0000-000000000000" -KQLDashboardName "TestKQLDashboard"
            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Get-FabricLongRunningOperation -Times 1 -Exactly
            Should -Invoke -CommandName Get-FabricLongRunningOperationResult -Times 1 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 400
                }
                throw "API Error"
            }
            Mock -CommandName Write-Message -MockWith { } -ParameterFilter { $Level -eq 'Error' }
        }

        It "Should log error when API returns error" {
            { New-FabricKQLDashboard -WorkspaceId "00000000-0000-0000-0000-000000000000" -KQLDashboardName "TestKQLDashboard" } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Error' } -Times 1 -Exactly
        }
    }
}
