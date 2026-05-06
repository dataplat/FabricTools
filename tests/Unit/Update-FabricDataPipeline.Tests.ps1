#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'Update-FabricDataPipeline'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'Update-FabricDataPipeline'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "Update-FabricDataPipeline" -Tag "UnitTests" {

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

        It "Command <CommandName> should have DataPipelineId parameter" {
            $command | Should -HaveParameter 'DataPipelineId' -Type [guid]
        }

        It "Command <CommandName> should have DataPipelineName parameter" {
            $command | Should -HaveParameter 'DataPipelineName' -Type [string]
        }

        It "Command <CommandName> should have DataPipelineDescription parameter" {
            $command | Should -HaveParameter 'DataPipelineDescription' -Type [string]
        }

        It "Command <CommandName> should support ShouldProcess" {
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
        }
    }

    Context "Update Data Pipeline successfully" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    id          = "00000000-0000-0000-0000-000000000001"
                    displayName = "UpdatedDataPipeline"
                    description = "Updated Data Pipeline Description"
                    type        = "DataPipeline"
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It "Should update a data pipeline" {
            $result = Update-FabricDataPipeline -WorkspaceId "00000000-0000-0000-0000-000000000000" -DataPipelineId "00000000-0000-0000-0000-000000000001" -DataPipelineName "UpdatedDataPipeline" -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            $result.displayName | Should -Be "UpdatedDataPipeline"

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
            { Update-FabricDataPipeline -WorkspaceId "00000000-0000-0000-0000-000000000000" -DataPipelineId "00000000-0000-0000-0000-000000000001" -DataPipelineName "UpdatedDataPipeline" -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            } -Times 1 -Exactly
        }
    }
}
