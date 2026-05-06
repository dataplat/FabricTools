#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricAuthToken'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Get-FabricAuthToken
}

Describe "Get-FabricAuthToken" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have no mandatory custom parameters' {
            # This command has no custom parameters, only common parameters
            $Command | Should -Not -BeNullOrEmpty
        }
    }
}
