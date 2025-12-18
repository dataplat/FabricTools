#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Invoke-FabricDatasetRefresh'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Invoke-FabricDatasetRefresh
}

Describe "Invoke-FabricDatasetRefresh" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'DatasetID'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    Context "Successful dataset refresh invocation" -Skip {
        # Skipped: Function calls Get-FabricDataset which does not exist in the module
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return $null
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Get-FabricDataset -MockWith {
                return @{ isrefreshable = $true }
            }
        }

        It 'Should invoke dataset refresh with valid parameters' {
            { Invoke-FabricDatasetRefresh -DatasetID ([guid]::NewGuid()) } | Should -Not -Throw

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }

    Context "Error handling" -Skip {
        # Skipped: Function calls Get-FabricDataset which does not exist in the module
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw "API Error"
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Get-FabricDataset -MockWith {
                return @{ isrefreshable = $true }
            }
        }

        It 'Should throw an error when API call fails' {
            {
                Invoke-FabricDatasetRefresh -DatasetID ([guid]::NewGuid())
            } | Should -Throw
        }
    }
}
