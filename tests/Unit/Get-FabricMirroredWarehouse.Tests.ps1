#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'Get-FabricMirroredWarehouse'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'Get-FabricMirroredWarehouse'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "Get-FabricMirroredWarehouse" -Tag "UnitTests" {

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

        It "Command <CommandName> should have MirroredWarehouseId parameter" {
            $command | Should -HaveParameter 'MirroredWarehouseId' -Type [guid]
        }

        It "Command <CommandName> should have MirroredWarehouseName parameter" {
            $command | Should -HaveParameter 'MirroredWarehouseName' -Type [string]
        }
    }

    Context "Get Mirrored Warehouse successfully" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @{
                    value = @(
                        [pscustomobject]@{
                            id          = "00000000-0000-0000-0000-000000000001"
                            displayName = "TestMirroredWarehouse"
                            description = "Test Mirrored Warehouse Description"
                            type        = "MirroredWarehouse"
                        }
                    )
                }
            }
        }

        It "Should return mirrored warehouses" {
            $result = Get-FabricMirroredWarehouse -WorkspaceId ([guid]::NewGuid())
            $result | Should -Not -BeNullOrEmpty
            $result.displayName | Should -Be "TestMirroredWarehouse"

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }

        It "Should return specific mirrored warehouse by Id" {
            $result = Get-FabricMirroredWarehouse -WorkspaceId ([guid]::NewGuid()) -MirroredWarehouseId ([guid]::NewGuid())
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
            { Get-FabricMirroredWarehouse -WorkspaceId ([guid]::NewGuid()) } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to retrieve*"
            }
        }
    }
}
