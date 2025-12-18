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
}
