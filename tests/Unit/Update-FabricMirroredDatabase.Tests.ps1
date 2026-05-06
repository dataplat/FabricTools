#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'Update-FabricMirroredDatabase'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'Update-FabricMirroredDatabase'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "Update-FabricMirroredDatabase" -Tag "UnitTests" {

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

        It "Command <CommandName> should have MirroredDatabaseId parameter" {
            $command | Should -HaveParameter 'MirroredDatabaseId' -Type [guid]
        }

        It "Command <CommandName> should have MirroredDatabaseName parameter" {
            $command | Should -HaveParameter 'MirroredDatabaseName' -Type [string]
        }

        It "Command <CommandName> should have MirroredDatabaseDescription parameter" {
            $command | Should -HaveParameter 'MirroredDatabaseDescription' -Type [string]
        }

        It "Command <CommandName> should support ShouldProcess" {
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
        }
    }

    Context "Update Mirrored Database successfully" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    id          = "00000000-0000-0000-0000-000000000001"
                    displayName = "UpdatedMirroredDatabase"
                    description = "Updated Mirrored Database Description"
                    type        = "MirroredDatabase"
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It "Should update a mirrored database" {
            $result = Update-FabricMirroredDatabase -WorkspaceId "00000000-0000-0000-0000-000000000000" -MirroredDatabaseId "00000000-0000-0000-0000-000000000001" -MirroredDatabaseName "UpdatedMirroredDatabase" -Confirm:$false
            $result | Should -Not -BeNullOrEmpty
            $result.displayName | Should -Be "UpdatedMirroredDatabase"

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
            { Update-FabricMirroredDatabase -WorkspaceId "00000000-0000-0000-0000-000000000000" -MirroredDatabaseId "00000000-0000-0000-0000-000000000001" -MirroredDatabaseName "UpdatedMirroredDatabase" -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            } -Times 1 -Exactly
        }
    }
}
