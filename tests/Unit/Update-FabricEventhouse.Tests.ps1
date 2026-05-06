#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'Update-FabricEventhouse'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'Update-FabricEventhouse'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "Update-FabricEventhouse" -Tag "UnitTests" {

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

        It "Command <CommandName> should have EventhouseId parameter" {
            $command | Should -HaveParameter 'EventhouseId' -Type [guid]
        }

        It "Command <CommandName> should have EventhouseName parameter" {
            $command | Should -HaveParameter 'EventhouseName' -Type [string]
        }

        It "Command <CommandName> should have EventhouseDescription parameter" {
            $command | Should -HaveParameter 'EventhouseDescription' -Type [string]
        }

        It "Command <CommandName> should support ShouldProcess" {
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
        }
    }

    Context "Update Eventhouse successfully" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    id          = "00000000-0000-0000-0000-000000000001"
                    displayName = "UpdatedEventhouse"
                    description = "Updated Eventhouse Description"
                    type        = "Eventhouse"
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It "Should update an eventhouse" {
            $result = Update-FabricEventhouse -WorkspaceId "00000000-0000-0000-0000-000000000000" -EventhouseId "00000000-0000-0000-0000-000000000001" -EventhouseName "UpdatedEventhouse" -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            $result.displayName | Should -Be "UpdatedEventhouse"

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
            { Update-FabricEventhouse -WorkspaceId "00000000-0000-0000-0000-000000000000" -EventhouseId "00000000-0000-0000-0000-000000000001" -EventhouseName "UpdatedEventhouse" -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            } -Times 1 -Exactly
        }
    }
}
