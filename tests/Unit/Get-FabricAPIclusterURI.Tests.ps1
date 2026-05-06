#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricAPIclusterURI'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Get-FabricAPIclusterURI
}

Describe "Get-FabricAPIclusterURI" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should exist as a valid command' {
            $Command | Should -Not -BeNullOrEmpty
        }
    }
}
