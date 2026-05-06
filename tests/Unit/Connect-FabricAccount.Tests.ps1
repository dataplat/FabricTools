#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Connect-FabricAccount'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Connect-FabricAccount
}

Describe "Connect-FabricAccount" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'TenantId'; ExpectedParameterType = 'guid'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'ServicePrincipalId'; ExpectedParameterType = 'guid'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'ServicePrincipalSecret'; ExpectedParameterType = 'securestring'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'Credential'; ExpectedParameterType = 'pscredential'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'Reset'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }
}
