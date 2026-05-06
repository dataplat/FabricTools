#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'Remove-FabricKQLDashboard'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'Remove-FabricKQLDashboard'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "Remove-FabricKQLDashboard" -Tag "UnitTests" {

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

        It "Command <CommandName> should have KQLDashboardId parameter" {
            $command | Should -HaveParameter 'KQLDashboardId' -Type [guid]
        }

        It "Command <CommandName> should support ShouldProcess" {
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
        }
    }

    Context "Remove KQL Dashboard successfully" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return $null
            }
        }

        It "Should remove a KQL dashboard" {
            { Remove-FabricKQLDashboard -WorkspaceId "00000000-0000-0000-0000-000000000000" -KQLDashboardId "00000000-0000-0000-0000-000000000001" -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -like "*workspaces/*/kqlDashboards/*" -and
                $Method -eq "Delete"
            }
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw "API Error"
            }
        }

        It "Should handle error gracefully and write error message" {
            { Remove-FabricKQLDashboard -WorkspaceId "00000000-0000-0000-0000-000000000000" -KQLDashboardId "00000000-0000-0000-0000-000000000001" -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }
}
