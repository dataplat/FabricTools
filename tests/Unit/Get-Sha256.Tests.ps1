#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-Sha256'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Get-Sha256
}

Describe "Get-Sha256" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'string'; ExpectedParameterType = 'object'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    Context "Successful SHA256 hash computation" {
        It 'Should compute SHA256 hash for a string' {
            $result = Get-Sha256 -string 'Hello World'
            $result | Should -Not -BeNullOrEmpty
            $result | Should -BeOfType [string]
            $result.Length | Should -Be 64  # SHA256 produces 64 hex characters
        }

        It 'Should produce consistent hash for same input' {
            $result1 = Get-Sha256 -string 'Test'
            $result2 = Get-Sha256 -string 'Test'
            $result1 | Should -Be $result2
        }

        It 'Should produce different hash for different input' {
            $result1 = Get-Sha256 -string 'Hello'
            $result2 = Get-Sha256 -string 'World'
            $result1 | Should -Not -Be $result2
        }
    }
}
