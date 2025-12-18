#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'New-FabricWorkspaceUsageMetricsReport'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name New-FabricWorkspaceUsageMetricsReport
}

Describe "New-FabricWorkspaceUsageMetricsReport" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'workspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Successful workspace usage metrics report creation" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Get-FabricAPIclusterURI -MockWith {
                return 'https://api.fabric.microsoft.com/v1.0/myorg/groups'
            }
            Mock -CommandName Invoke-WebRequest -MockWith {
                return [pscustomobject]@{
                    Content = '{"models": [{"dbName": "dataset-guid-123"}]}'
                }
            }
        }

        It 'Should create workspace usage metrics report with valid parameters' {
            $result = New-FabricWorkspaceUsageMetricsReport -workspaceId (New-Guid) -Confirm:$false

            Should -Invoke -CommandName Invoke-WebRequest -Times 1 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Get-FabricAPIclusterURI -MockWith {
                return 'https://api.fabric.microsoft.com/v1.0/myorg/groups'
            }
            Mock -CommandName Invoke-WebRequest -MockWith {
                throw "API Error"
            }
        }

        It 'Should throw an error when API call fails' {
            {
                New-FabricWorkspaceUsageMetricsReport -workspaceId (New-Guid) -Confirm:$false
            } | Should -Throw
        }
    }
}
