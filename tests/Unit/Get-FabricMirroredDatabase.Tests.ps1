#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'Get-FabricMirroredDatabase'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'Get-FabricMirroredDatabase'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "Get-FabricMirroredDatabase" -Tag "UnitTests" {

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
    }

    Context "Get Mirrored Database successfully" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @{
                    value = @(
                        [pscustomobject]@{
                            id          = "00000000-0000-0000-0000-000000000001"
                            displayName = "TestMirroredDatabase"
                            description = "Test Mirrored Database Description"
                            type        = "MirroredDatabase"
                        }
                    )
                }
            }
        }

        It "Should return mirrored databases" {
            $result = Get-FabricMirroredDatabase -WorkspaceId ([guid]::NewGuid())
            $result | Should -Not -BeNullOrEmpty
            $result.displayName | Should -Be "TestMirroredDatabase"

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }

        It "Should return specific mirrored database by Id" {
            $result = Get-FabricMirroredDatabase -WorkspaceId ([guid]::NewGuid()) -MirroredDatabaseId ([guid]::NewGuid())
            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw "API Error"
            }
        }

        It "Should handle errors gracefully" {
            { Get-FabricMirroredDatabase -WorkspaceId ([guid]::NewGuid()) } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to retrieve*"
            }
        }
    }
}
