#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'Update-FabricEventstream'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'Update-FabricEventstream'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "Update-FabricEventstream" -Tag "UnitTests" {

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

        It "Command <CommandName> should have EventstreamId parameter" {
            $command | Should -HaveParameter 'EventstreamId' -Type [guid]
        }

        It "Command <CommandName> should have EventstreamName parameter" {
            $command | Should -HaveParameter 'EventstreamName' -Type [string]
        }

        It "Command <CommandName> should have EventstreamDescription parameter" {
            $command | Should -HaveParameter 'EventstreamDescription' -Type [string]
        }

        It "Command <CommandName> should support ShouldProcess" {
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
        }
    }

    Context "Update Eventstream successfully" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    id          = "00000000-0000-0000-0000-000000000001"
                    displayName = "UpdatedEventstream"
                    description = "Updated Eventstream Description"
                    type        = "Eventstream"
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It "Should update an eventstream" {
            $result = Update-FabricEventstream -WorkspaceId "00000000-0000-0000-0000-000000000000" -EventstreamId "00000000-0000-0000-0000-000000000001" -EventstreamName "UpdatedEventstream" -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            $result.displayName | Should -Be "UpdatedEventstream"

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
            { Update-FabricEventstream -WorkspaceId "00000000-0000-0000-0000-000000000000" -EventstreamId "00000000-0000-0000-0000-000000000001" -EventstreamName "UpdatedEventstream" -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            } -Times 1 -Exactly
        }
    }
}
