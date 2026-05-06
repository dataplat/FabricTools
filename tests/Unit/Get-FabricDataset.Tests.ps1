#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricDataset'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Get-FabricDataset
}

Describe "Get-FabricDataset" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'DatasetId';   ExpectedParameterType = 'guid'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'DatasetName'; ExpectedParameterType = 'string'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should have GroupId as an alias for WorkspaceId' {
            $Command.Parameters['WorkspaceId'].Aliases | Should -Contain 'GroupId'
        }
    }

    Context "My Workspace (no WorkspaceId)" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            $mockDatasetId1 = [guid]'11111111-1111-1111-1111-111111111111'
            $mockDatasetId2 = [guid]'22222222-2222-2222-2222-222222222222'
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @(
                    [pscustomobject]@{ id = $mockDatasetId1; name = 'Sales Model' }
                    [pscustomobject]@{ id = $mockDatasetId2; name = 'HR Model' }
                )
            }
        }

        It 'Should call the datasets endpoint without a group prefix' {
            $result = Get-FabricDataset

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -eq 'datasets'
            }
        }

        It 'Should return all datasets when no filter is provided' {
            $result = Get-FabricDataset
            @($result).Count | Should -Be 2
        }

        It 'Should filter by DatasetName' {
            $result = Get-FabricDataset -DatasetName 'Sales Model'
            $result.name | Should -Be 'Sales Model'
        }

        It 'Should filter by DatasetId' {
            $result = Get-FabricDataset -DatasetId $mockDatasetId1
            $result.id | Should -Be $mockDatasetId1
        }
    }

    Context "Specific workspace (WorkspaceId provided)" {
        BeforeAll {
            $mockWorkspaceId = [guid]'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @(
                    [pscustomobject]@{ id = 'ds-3'; name = 'Finance Model' }
                )
            }
        }

        It 'Should call the groups endpoint when WorkspaceId is supplied' {
            $result = Get-FabricDataset -WorkspaceId $mockWorkspaceId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -eq "groups/$mockWorkspaceId/datasets"
            }
        }
    }

    Context "Ambiguous input (DatasetId and DatasetName both provided)" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }
        }

        It 'Should return null and not call the API' {
            $result = Get-FabricDataset -DatasetId ([guid]::NewGuid()) -DatasetName 'Some Name'

            $result | Should -BeNullOrEmpty
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0
        }
    }

    Context "No matching dataset" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @()
            }
        }

        It 'Should return null when no dataset matches the filter' {
            $result = Get-FabricDataset -DatasetName 'NonExistent'
            $result | Should -BeNullOrEmpty
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { throw "API Error" }
        }

        It 'Should not throw and write an error message on API failure' {
            { Get-FabricDataset } | Should -Not -Throw
            Should -Invoke -CommandName Write-Message -Times 1 -ParameterFilter { $Level -eq 'Error' }
        }
    }
}
