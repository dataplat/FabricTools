#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'Update-FabricSparkJobDefinition'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'Update-FabricSparkJobDefinition'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "Update-FabricSparkJobDefinition" -Tag "UnitTests" {

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

        It "Command <CommandName> should have SparkJobDefinitionId parameter" {
            $command | Should -HaveParameter 'SparkJobDefinitionId' -Type [guid]
        }

        It "Command <CommandName> should have SparkJobDefinitionName parameter" {
            $command | Should -HaveParameter 'SparkJobDefinitionName' -Type [string]
        }

        It "Command <CommandName> should have SparkJobDefinitionDescription parameter" {
            $command | Should -HaveParameter 'SparkJobDefinitionDescription' -Type [string]
        }

        It "Command <CommandName> should support ShouldProcess" {
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
        }
    }

    Context "Update Spark Job Definition successfully" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    id          = "00000000-0000-0000-0000-000000000001"
                    displayName = "UpdatedSparkJobDefinition"
                    description = "Updated Spark Job Definition Description"
                    type        = "SparkJobDefinition"
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It "Should update a spark job definition" {
            $result = Update-FabricSparkJobDefinition -WorkspaceId "00000000-0000-0000-0000-000000000000" -SparkJobDefinitionId "00000000-0000-0000-0000-000000000001" -SparkJobDefinitionName "UpdatedSparkJobDefinition" -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            $result.displayName | Should -Be "UpdatedSparkJobDefinition"

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

        It "Should handle error when API returns error" {
            { Update-FabricSparkJobDefinition -WorkspaceId "00000000-0000-0000-0000-000000000000" -SparkJobDefinitionId "00000000-0000-0000-0000-000000000001" -SparkJobDefinitionName "UpdatedSparkJobDefinition" -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Error' } -Times 1 -Exactly -Scope It
        }
    }
}
