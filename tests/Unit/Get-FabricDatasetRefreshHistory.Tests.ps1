#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricDatasetRefreshHistory'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Get-FabricDatasetRefreshHistory
}

Describe "Get-FabricDatasetRefreshHistory" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'DatasetId';   ExpectedParameterType = 'guid' }
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid' }
            @{ ExpectedParameterName = 'Top';         ExpectedParameterType = 'int' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType
        }

        It 'Should have GroupId as an alias for WorkspaceId' {
            $Command.Parameters['WorkspaceId'].Aliases | Should -Contain 'GroupId'
        }

        It 'Should require a dataset ID or workspace ID' {
            $Command.ParameterSets.Name | Should -Contain 'DatasetInMyWorkspace'
            $Command.ParameterSets.Name | Should -Contain 'DatasetInWorkspace'
            $Command.ParameterSets.Name | Should -Contain 'Workspace'
            ($Command.ParameterSets | Where-Object Name -eq 'DatasetInMyWorkspace').Parameters |
                Where-Object Name -eq 'DatasetId' | Select-Object -ExpandProperty IsMandatory | Should -BeTrue
            ($Command.ParameterSets | Where-Object Name -eq 'DatasetInWorkspace').Parameters |
                Where-Object Name -in @('DatasetId', 'WorkspaceId') | Where-Object IsMandatory |
                Measure-Object | Select-Object -ExpandProperty Count | Should -Be 2
            ($Command.ParameterSets | Where-Object Name -eq 'Workspace').Parameters |
                Where-Object Name -eq 'WorkspaceId' | Select-Object -ExpandProperty IsMandatory | Should -BeTrue
        }
    }

    Context "My Workspace (no WorkspaceId)" {
        BeforeAll {
            $mockDatasetId = [guid]'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Get-FabricDataset -MockWith {
                return [pscustomobject]@{ Id = $mockDatasetId; Name = 'Test Dataset' }
            }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @(
                    [pscustomobject]@{ id = 'r-1'; status = 'Completed'; startTime = '2024-01-01T00:00:00Z' }
                    [pscustomobject]@{ id = 'r-2'; status = 'Failed';    startTime = '2024-01-02T00:00:00Z' }
                )
            }
        }

        It 'Should call the My Workspace refreshes endpoint' {
            $result = Get-FabricDatasetRefreshHistory -DatasetId $mockDatasetId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -eq "datasets/$mockDatasetId/refreshes"
            }
        }

        It 'Should return all refresh history entries' {
            $result = Get-FabricDatasetRefreshHistory -DatasetId $mockDatasetId
            @($result).Count | Should -Be 2
            $result[0].DatasetId | Should -Be $mockDatasetId
            $result[0].DatasetName | Should -Be 'Test Dataset'
            $result[0].WorkspaceId | Should -BeNullOrEmpty
        }
    }

    Context "Specific workspace (WorkspaceId provided)" {
        BeforeAll {
            $mockDatasetId   = [guid]'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
            $mockWorkspaceId = [guid]'11111111-2222-3333-4444-555555555555'
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Get-FabricDataset -MockWith {
                return [pscustomobject]@{ Id = $mockDatasetId; Name = 'Test Dataset' }
            }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @(
                    [pscustomobject]@{ id = 'r-3'; status = 'Completed'; startTime = '2024-03-01T00:00:00Z' }
                )
            }
        }

        It 'Should call the groups refreshes endpoint' {
            $result = Get-FabricDatasetRefreshHistory -DatasetId $mockDatasetId -WorkspaceId $mockWorkspaceId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -eq "groups/$mockWorkspaceId/datasets/$mockDatasetId/refreshes"
            }
        }
    }

    Context "Top parameter" {
        BeforeAll {
            $mockDatasetId = [guid]'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Get-FabricDataset -MockWith {
                return [pscustomobject]@{ Id = $mockDatasetId; Name = 'Test Dataset' }
            }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @(
                    [pscustomobject]@{ id = 'r-4'; status = 'Completed' }
                )
            }
        }

        It 'Should append $top query parameter to the URI' {
            $result = Get-FabricDatasetRefreshHistory -DatasetId $mockDatasetId -Top 10

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -eq "datasets/$mockDatasetId/refreshes?`$top=10"
            }
        }
    }

    Context "No refresh history found" {
        BeforeAll {
            $mockDatasetId = [guid]'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Get-FabricDataset -MockWith {
                return [pscustomobject]@{ Id = $mockDatasetId; Name = 'Test Dataset' }
            }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { return @() }
        }

        It 'Should return null when no entries exist' {
            $result = Get-FabricDatasetRefreshHistory -DatasetId $mockDatasetId
            $result | Should -BeNullOrEmpty
        }
    }

    Context "Error handling" {
        BeforeAll {
            $mockDatasetId = [guid]'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Get-FabricDataset -MockWith {
                return [pscustomobject]@{ Id = $mockDatasetId; Name = 'Test Dataset' }
            }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { throw "API Error" }
        }

        It 'Should not throw and write an error message on API failure' {
            { Get-FabricDatasetRefreshHistory -DatasetId $mockDatasetId } | Should -Not -Throw
            Should -Invoke -CommandName Write-Message -Times 1 -ParameterFilter { $Level -eq 'Error' }
        }
    }

    Context "Workspace-wide refresh history" {
        BeforeAll {
            $mockWorkspaceId = [guid]'11111111-2222-3333-4444-555555555555'
            $mockDataset1 = [pscustomobject]@{ Id = [guid]'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'; Name = 'Dataset One' }
            $mockDataset2 = [pscustomobject]@{ Id = [guid]'bbbbbbbb-cccc-dddd-eeee-ffffffffffff'; Name = 'Dataset Two' }
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Get-FabricDataset -MockWith { return @($mockDataset1, $mockDataset2) }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @([pscustomobject]@{ id = "r-$($ObjectIdOrName)"; status = 'Completed' })
            }
        }

        It 'Should retrieve and annotate refresh history for each workspace dataset' {
            $result = @(Get-FabricDatasetRefreshHistory -WorkspaceId $mockWorkspaceId)

            $result.Count | Should -Be 2
            $result[0].WorkspaceId | Should -Be $mockWorkspaceId
            $result[0].DatasetId | Should -Be $mockDataset1.Id
            $result[0].DatasetName | Should -Be $mockDataset1.Name
            $result[1].DatasetId | Should -Be $mockDataset2.Id
            $result[1].DatasetName | Should -Be $mockDataset2.Name
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 2 -Exactly
        }

        It 'Should apply Top to every workspace dataset request' {
            $null = Get-FabricDatasetRefreshHistory -WorkspaceId $mockWorkspaceId -Top 1

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 2 -Exactly -ParameterFilter {
                $Uri -like '*?$top=1'
            }
        }

        It 'Should stop when a dataset refresh request fails' {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw 'API Error'
            }

            { Get-FabricDatasetRefreshHistory -WorkspaceId $mockWorkspaceId } | Should -Throw
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }
}
