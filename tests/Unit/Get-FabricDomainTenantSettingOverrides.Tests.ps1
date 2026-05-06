#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricDomainTenantSettingOverrides'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricDomainTenantSettingOverrides" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricDomainTenantSettingOverrides
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }
    }

    Context 'When getting domain tenant setting overrides successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @(
                    [pscustomobject]@{ id = [guid]::NewGuid(); settingName = 'Setting1' }
                    [pscustomobject]@{ id = [guid]::NewGuid(); settingName = 'Setting2' }
                )
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            Get-FabricDomainTenantSettingOverrides

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*admin/domains/delegatedTenantSettingOverrides*" -and
                $Method -eq 'Get'
            }
        }

        It 'Should return the list of overrides' {
            $result = Get-FabricDomainTenantSettingOverrides

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
            $result = Get-FabricDomainTenantSettingOverrides

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
            { Get-FabricDomainTenantSettingOverrides } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Error retrieving domain tenant setting overrides*"
            }
        }
    }
}
