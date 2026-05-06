#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricTenantSetting'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricTenantSetting" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricTenantSetting
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'SettingTitle'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When getting tenant settings successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @{
                    tenantSettings = @(
                        [pscustomobject]@{ settingName = 'Setting1'; title = 'Title1'; enabled = $true }
                        [pscustomobject]@{ settingName = 'Setting2'; title = 'Title2'; enabled = $false }
                    )
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            Get-FabricTenantSetting

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*admin/tenantsettings*"
            }
        }

        It 'Should return the list of settings' {
            $result = Get-FabricTenantSetting

            $result | Should -Not -BeNullOrEmpty
        }
    }

    Context 'When filtering by setting title' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @{
                    tenantSettings = @(
                        [pscustomobject]@{ settingName = 'Setting1'; title = 'TestTitle'; enabled = $true }
                        [pscustomobject]@{ settingName = 'Setting2'; title = 'OtherTitle'; enabled = $false }
                    )
                }
            }
        }

        It 'Should filter results by title when SettingTitle is specified' {
            $result = Get-FabricTenantSetting -SettingTitle 'TestTitle'

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1
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
            { Get-FabricTenantSetting } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Error retrieving tenant settings*"
            }
        }
    }
}
