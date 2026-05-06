#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricContinuationToken'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricContinuationToken" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have Response parameter' {
            InModuleScope -ModuleName 'FabricTools' {
                $command = Get-Command -Name Get-FabricContinuationToken
                $command | Should -HaveParameter -ParameterName 'Response' -Not -Mandatory
            }
        }
    }

    Context "When extracting continuation token" {
        It 'Should return continuation token from response' {
            InModuleScope -ModuleName 'FabricTools' {
                Mock -CommandName Write-Message -MockWith { }
                $mockResponse = [pscustomobject]@{
                    continuationToken = 'token123'
                }
                $result = Get-FabricContinuationToken -Response $mockResponse
                $result | Should -Be 'token123'
            }
        }

        It 'Should return null when no continuation token exists' {
            InModuleScope -ModuleName 'FabricTools' {
                Mock -CommandName Write-Message -MockWith { }
                $mockResponse = [pscustomobject]@{
                    data = 'somedata'
                }
                $result = Get-FabricContinuationToken -Response $mockResponse
                $result | Should -BeNullOrEmpty
            }
        }

        It 'Should return null when response is null' {
            InModuleScope -ModuleName 'FabricTools' {
                Mock -CommandName Write-Message -MockWith { }
                $result = Get-FabricContinuationToken -Response $null
                $result | Should -BeNullOrEmpty
            }
        }
    }
}
