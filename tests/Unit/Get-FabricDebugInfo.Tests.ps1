#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricDebugInfo'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Get-FabricDebugInfo
}

Describe "Get-FabricDebugInfo" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have no mandatory custom parameters' {
            # This command has no custom parameters, only common parameters
            $Command | Should -Not -BeNullOrEmpty
        }
    }

    Context "Successful debug info retrieval" {
        It 'Should return debug information' {
            $result = Get-FabricDebugInfo
            $result | Should -Not -BeNullOrEmpty
        }
    }
}
