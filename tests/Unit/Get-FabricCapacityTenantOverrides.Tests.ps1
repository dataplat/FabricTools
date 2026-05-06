#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricCapacityTenantOverrides'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricCapacityTenantOverrides" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricCapacityTenantOverrides
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }
    }

    Context 'When getting capacity tenant overrides successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @(
                    [pscustomobject]@{ capacityId = [guid]::NewGuid(); tenantSettingName = 'Override1' }
                    [pscustomobject]@{ capacityId = [guid]::NewGuid(); tenantSettingName = 'Override2' }
                )
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            Get-FabricCapacityTenantOverrides

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*admin/capacities/delegatedTenantSettingOverrides*"
            }
        }

        It 'Should return the list of overrides' {
            $result = Get-FabricCapacityTenantOverrides

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 2
        }
    }

    Context 'When no overrides are found' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return $null
            }
        }

        It 'Should return null when no overrides found' {
            $result = Get-FabricCapacityTenantOverrides

            $result | Should -BeNullOrEmpty
        }
    }

    Context 'When an exception is thrown' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw 'API connection failed'
            }
        }

        It 'Should throw an exception when API call fails' {
            { Get-FabricCapacityTenantOverrides } | Should -Throw -ExpectedMessage '*API connection failed*'
        }
    }
}
