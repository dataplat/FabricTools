#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Update-FabricCapacityTenantSettingOverrides'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Update-FabricCapacityTenantSettingOverrides
}

Describe "Update-FabricCapacityTenantSettingOverrides" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'CapacityId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'SettingTitle'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'EnableTenantSetting'; ExpectedParameterType = 'bool'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'DelegateToWorkspace'; ExpectedParameterType = 'bool'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'EnabledSecurityGroups'; ExpectedParameterType = 'Object'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'ExcludedSecurityGroups'; ExpectedParameterType = 'Object'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Successful tenant setting override update" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{ success = $true }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should update tenant setting overrides with valid parameters' {
            $result = Update-FabricCapacityTenantSettingOverrides -CapacityId (New-Guid) -SettingTitle 'TestSetting' -EnableTenantSetting $true -Confirm:$false
            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Info' -and $Message -like '*Successfully updated*' } -Times 1 -Exactly -Scope It
        }

        It 'Should include DelegateToWorkspace in request when specified' {
            $result = Update-FabricCapacityTenantSettingOverrides -CapacityId (New-Guid) -SettingTitle 'TestSetting' -EnableTenantSetting $true -DelegateToWorkspace $true -Confirm:$false
            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -Scope It
        }

        It 'Should include EnabledSecurityGroups in request when specified' {
            $securityGroups = @(
                [pscustomobject]@{ graphId = "group-1"; name = "TestGroup1" }
                [pscustomobject]@{ graphId = "group-2"; name = "TestGroup2" }
            )
            $result = Update-FabricCapacityTenantSettingOverrides -CapacityId (New-Guid) -SettingTitle 'TestSetting' -EnableTenantSetting $true -EnabledSecurityGroups $securityGroups -Confirm:$false
            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -Scope It
        }

        It 'Should include ExcludedSecurityGroups in request when specified' {
            $securityGroups = @(
                [pscustomobject]@{ graphId = "group-1"; name = "TestGroup1" }
            )
            $result = Update-FabricCapacityTenantSettingOverrides -CapacityId (New-Guid) -SettingTitle 'TestSetting' -EnableTenantSetting $true -ExcludedSecurityGroups $securityGroups -Confirm:$false
            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -Scope It
        }
    }

    Context "Security group validation" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should throw error when EnabledSecurityGroups is missing graphId property' {
            $invalidGroups = @(
                [pscustomobject]@{ name = "TestGroup1" }
            )
            { Update-FabricCapacityTenantSettingOverrides -CapacityId (New-Guid) -SettingTitle 'TestSetting' -EnableTenantSetting $true -EnabledSecurityGroups $invalidGroups -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Error' -and $Message -like "*enabled security group*" } -Times 1 -Exactly -Scope It
        }

        It 'Should throw error when ExcludedSecurityGroups is missing name property' {
            $invalidGroups = @(
                [pscustomobject]@{ graphId = "group-1" }
            )
            { Update-FabricCapacityTenantSettingOverrides -CapacityId (New-Guid) -SettingTitle 'TestSetting' -EnableTenantSetting $true -ExcludedSecurityGroups $invalidGroups -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Error' -and $Message -like "*excluded security group*" } -Times 1 -Exactly -Scope It
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

        It 'Should handle errors gracefully and write error message' {
            { Update-FabricCapacityTenantSettingOverrides -CapacityId (New-Guid) -SettingTitle 'TestSetting' -EnableTenantSetting $true -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Error' -and $Message -like '*Error updating tenant settings*' } -Times 1 -Exactly -Scope It
        }
    }
}
