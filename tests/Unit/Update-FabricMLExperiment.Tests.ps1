#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'Update-FabricMLExperiment'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'Update-FabricMLExperiment'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "Update-FabricMLExperiment" -Tag "UnitTests" {

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

        It "Command <CommandName> should have MLExperimentId parameter" {
            $command | Should -HaveParameter 'MLExperimentId' -Type [guid]
        }

        It "Command <CommandName> should have MLExperimentName parameter" {
            $command | Should -HaveParameter 'MLExperimentName' -Type [string]
        }

        It "Command <CommandName> should have MLExperimentDescription parameter" {
            $command | Should -HaveParameter 'MLExperimentDescription' -Type [string]
        }

        It "Command <CommandName> should support ShouldProcess" {
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
        }
    }

    Context "Update ML Experiment successfully" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    id          = "00000000-0000-0000-0000-000000000001"
                    displayName = "UpdatedMLExperiment"
                    description = "Updated ML Experiment Description"
                    type        = "MLExperiment"
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It "Should update an ML experiment" {
            $result = Update-FabricMLExperiment -WorkspaceId "00000000-0000-0000-0000-000000000000" -MLExperimentId "00000000-0000-0000-0000-000000000001" -MLExperimentName "UpdatedMLExperiment" -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            $result.displayName | Should -Be "UpdatedMLExperiment"

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 400
                }
                throw "API Error"
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { }
        }

        It "Should handle errors gracefully and write error message" {
            { Update-FabricMLExperiment -WorkspaceId "00000000-0000-0000-0000-000000000000" -MLExperimentId "00000000-0000-0000-0000-000000000001" -MLExperimentName "UpdatedMLExperiment" -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            } -Times 1 -Exactly
        }
    }
}
