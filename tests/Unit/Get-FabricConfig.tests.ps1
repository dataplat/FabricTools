#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricConfig'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Get-FabricConfig
}

Describe "Get-FabricConfig" -Tag 'UnitTests' {

    Context "Command definition" {
        It 'Should have ConfigName parameter' {
            $Command | Should -HaveParameter 'ConfigName' -Type [string]
        }

        It 'ConfigName parameter should not be mandatory' {
            $Command | Should -HaveParameter 'ConfigName' -Not -Mandatory
        }
    }

    Context "Get all configuration" {
        BeforeAll {
            Mock -CommandName Get-PSFConfig -MockWith {
                return @(
                    [pscustomobject]@{ Name = 'BaseUrl'; Value = 'https://api.fabric.microsoft.com/v1' }
                    [pscustomobject]@{ Name = 'Timeout'; Value = 300 }
                )
            }
        }

        It 'Should return all config when no ConfigName specified' {
            $result = Get-FabricConfig
            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Get-PSFConfig -ParameterFilter {
                $Module -eq 'FabricTools' -and $null -eq $Name
            } -Times 1 -Exactly
        }
    }

    Context "Get specific configuration" {
        BeforeAll {
            Mock -CommandName Get-PSFConfig -MockWith {
                return [pscustomobject]@{ Name = 'BaseUrl'; Value = 'https://api.fabric.microsoft.com/v1' }
            }
        }

        It 'Should return specific config when ConfigName is specified' {
            $result = Get-FabricConfig -ConfigName 'BaseUrl'
            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Get-PSFConfig -ParameterFilter {
                $Module -eq 'FabricTools' -and $Name -eq 'BaseUrl'
            } -Times 1 -Exactly
        }
    }
}
