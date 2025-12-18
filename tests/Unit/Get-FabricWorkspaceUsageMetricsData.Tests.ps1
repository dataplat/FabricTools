#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricWorkspaceUsageMetricsData'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Get-FabricWorkspaceUsageMetricsData
}

Describe "Get-FabricWorkspaceUsageMetricsData" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'workspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'username'; ExpectedParameterType = 'string'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    Context "Successful workspace usage metrics data retrieval" {
        BeforeAll {
            Mock -CommandName New-FabricWorkspaceUsageMetricsReport -MockWith {
                return [guid]::NewGuid()
            }
            Mock -CommandName Get-FabricUsageMetricsQuery -MockWith {
                return [pscustomobject]@{
                    results = @()
                }
            }
        }

        It 'Should get workspace usage metrics data with valid parameters' {
            $result = Get-FabricWorkspaceUsageMetricsData -workspaceId (New-Guid)

            $result | Should -Not -BeNullOrEmpty
            Should -Invoke -CommandName New-FabricWorkspaceUsageMetricsReport -Times 1 -Exactly
            Should -Invoke -CommandName Get-FabricUsageMetricsQuery -Times 7 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName New-FabricWorkspaceUsageMetricsReport -MockWith {
                throw "API Error"
            }
        }

        It 'Should throw an error when API call fails' {
            {
                Get-FabricWorkspaceUsageMetricsData -workspaceId (New-Guid)
            } | Should -Throw
        }
    }
}
