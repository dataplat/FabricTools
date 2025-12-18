#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Invoke-FabricKQLCommand'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Invoke-FabricKQLCommand
}

Describe "Invoke-FabricKQLCommand" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'KQLDatabaseName'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'KQLDatabaseId'; ExpectedParameterType = 'guid'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'KQLCommand'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'ReturnRawResult'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    Context "Successful KQL command invocation" {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -MockWith {
                return [pscustomobject]@{
                    results = @()
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Get-FabricKQLDatabase -MockWith {
                return [pscustomobject]@{
                    queryServiceUri = 'https://test.kusto.fabric.microsoft.com'
                    displayName = 'TestDB'
                }
            }
        }

        It 'Should invoke KQL command with valid parameters' {
            $result = Invoke-FabricKQLCommand -WorkspaceId (New-Guid) -KQLDatabaseId (New-Guid) -KQLCommand '.show tables'

            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -MockWith {
                throw "API Error"
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Get-FabricKQLDatabase -MockWith {
                return [pscustomobject]@{
                    queryServiceUri = 'https://test.kusto.fabric.microsoft.com'
                    displayName = 'TestDB'
                }
            }
        }

        It 'Should throw an error when API call fails' {
            {
                Invoke-FabricKQLCommand -WorkspaceId (New-Guid) -KQLDatabaseId (New-Guid) -KQLCommand '.show tables'
            } | Should -Throw
        }
    }
}
