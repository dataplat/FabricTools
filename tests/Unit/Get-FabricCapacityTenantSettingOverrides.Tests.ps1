#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricCapacityTenantSettingOverrides'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricCapacityTenantSettingOverrides" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricCapacityTenantSettingOverrides
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'capacityId'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When getting capacity tenant setting overrides successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @(
                    [pscustomobject]@{ settingName = 'Setting1'; tenantSettingGroup = 'Group1' }
                    [pscustomobject]@{ settingName = 'Setting2'; tenantSettingGroup = 'Group2' }
                )
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockCapacityId = [guid]::NewGuid()

            Get-FabricCapacityTenantSettingOverrides -capacityId $mockCapacityId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*admin/capacities/*/delegatedTenantSettingOverrides*"
            }
        }

        It 'Should return the list of setting overrides' {
            $mockCapacityId = [guid]::NewGuid()

            $result = Get-FabricCapacityTenantSettingOverrides -capacityId $mockCapacityId

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
            $mockCapacityId = [guid]::NewGuid()

            $result = Get-FabricCapacityTenantSettingOverrides -capacityId $mockCapacityId

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

        It 'Should handle exceptions gracefully' {
            $mockCapacityId = [guid]::NewGuid()

            { Get-FabricCapacityTenantSettingOverrides -capacityId $mockCapacityId } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Error retrieving capacity tenant setting overrides*"
            }
        }
    }
}
