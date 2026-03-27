#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricUserAgent" -Tag "UnitTests" {

    Context "Return format" {
        It 'Should return a non-empty string' {
            InModuleScope FabricTools {
                $result = Get-FabricUserAgent
                $result | Should -Not -BeNullOrEmpty
            }
        }

        It 'Should match the expected pattern: FabricTools/<ver> powershell/<ver> (<os>; <arch>)' {
            InModuleScope FabricTools {
                $result = Get-FabricUserAgent
                $result | Should -Match '^FabricTools/\S+ powershell/\S+ \(.+;\s*.+\)$'
            }
        }

        It 'Should produce a value accepted as a valid HTTP User-Agent header' {
            InModuleScope FabricTools {
                $result = Get-FabricUserAgent
                {
                    $msg = [System.Net.Http.HttpRequestMessage]::new()
                    $msg.Headers.Add('User-Agent', $result)
                    $msg.Dispose()
                } | Should -Not -Throw
            }
        }
    }

    Context "PowerShell version token" {
        It 'Should include the running PowerShell version' {
            InModuleScope FabricTools {
                $result = Get-FabricUserAgent
                $expected = $PSVersionTable.PSVersion.ToString()
                $result | Should -Match "powershell/$([regex]::Escape($expected))"
            }
        }
    }

    Context "Module version token" {
        It 'Should include a non-empty module version (not unknown) when FabricTools is loaded' {
            InModuleScope FabricTools {
                $result = Get-FabricUserAgent
                $result | Should -Not -Match 'FabricTools/unknown'
            }
        }

        It 'Should include a version token in the FabricTools segment' {
            InModuleScope FabricTools {
                $result = Get-FabricUserAgent
                $result | Should -Match '^FabricTools/\S+'
            }
        }
    }

    Context "OS and architecture tokens" {
        It 'Should include a non-empty OS token inside parentheses' {
            InModuleScope FabricTools {
                $result = Get-FabricUserAgent
                $result | Should -Match '\(.+;'
            }
        }

        It 'Should include a non-empty architecture token inside parentheses' {
            InModuleScope FabricTools {
                $result = Get-FabricUserAgent
                $result | Should -Match ';\s*\S+\)'
            }
        }

        It 'Should collapse multiple spaces in OS description to a single space' {
            InModuleScope FabricTools {
                $result = Get-FabricUserAgent
                $result | Should -Not -Match '\s{2,}'
            }
        }
    }
}
