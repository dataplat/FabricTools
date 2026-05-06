#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'Update-FabricSemanticModel'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'Update-FabricSemanticModel'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "Update-FabricSemanticModel" -Tag "UnitTests" {

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

        It "Command <CommandName> should have SemanticModelId parameter" {
            $command | Should -HaveParameter 'SemanticModelId' -Type [guid]
        }

        It "Command <CommandName> should have SemanticModelName parameter" {
            $command | Should -HaveParameter 'SemanticModelName' -Type [string]
        }

        It "Command <CommandName> should have SemanticModelDescription parameter" {
            $command | Should -HaveParameter 'SemanticModelDescription' -Type [string]
        }

        It "Command <CommandName> should support ShouldProcess" {
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
        }
    }

    Context "Update Semantic Model successfully" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    id          = "00000000-0000-0000-0000-000000000001"
                    displayName = "UpdatedSemanticModel"
                    description = "Updated Semantic Model Description"
                    type        = "SemanticModel"
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It "Should update a semantic model" {
            $result = Update-FabricSemanticModel -WorkspaceId "00000000-0000-0000-0000-000000000000" -SemanticModelId "00000000-0000-0000-0000-000000000001" -SemanticModelName "UpdatedSemanticModel" -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            $result.displayName | Should -Be "UpdatedSemanticModel"

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
            { Update-FabricSemanticModel -WorkspaceId "00000000-0000-0000-0000-000000000000" -SemanticModelId "00000000-0000-0000-0000-000000000001" -SemanticModelName "UpdatedSemanticModel" -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Error' } -Times 1 -Exactly -Scope It
        }
    }
}
