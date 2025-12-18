#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricDatasetRefreshes'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Get-FabricDatasetRefreshes
}

Describe "Get-FabricDatasetRefreshes" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'DatasetID'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'workspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    Context "Successful dataset refreshes retrieval" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return [pscustomobject]@{
                    value = @(
                        [pscustomobject]@{ id = 'refresh-guid'; status = 'Completed'; startTime = '2024-01-01T00:00:00Z'; refreshType = 'Manual' }
                    )
                }
            }
            Mock -CommandName Get-PowerBIDataset -MockWith {
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    Name = 'TestDataset'
                    isrefreshable = 'True'
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { }
        }

        It 'Should return dataset refreshes when DatasetID is provided' {
            $mockDatasetId = [guid]::NewGuid()
            $mockWorkspaceId = [guid]::NewGuid()

            $result = Get-FabricDatasetRefreshes -DatasetID $mockDatasetId -workspaceId $mockWorkspaceId

            Should -Invoke -CommandName Get-PowerBIDataset -Times 1 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Get-PowerBIDataset -MockWith {
                throw "API Error"
            }
            Mock -CommandName Confirm-TokenState -MockWith { }
        }

        It 'Should throw an error when API call fails' {
            $mockDatasetId = [guid]::NewGuid()
            $mockWorkspaceId = [guid]::NewGuid()

            { Get-FabricDatasetRefreshes -DatasetID $mockDatasetId -workspaceId $mockWorkspaceId } | Should -Throw
        }
    }
}
