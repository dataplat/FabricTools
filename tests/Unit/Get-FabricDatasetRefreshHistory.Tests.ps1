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
            @{ ExpectedParameterName = 'DatasetId';   ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'Top';         ExpectedParameterType = 'int';  Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should have GroupId as an alias for WorkspaceId' {
            $Command.Parameters['WorkspaceId'].Aliases | Should -Contain 'GroupId'
        }
    }

    Context "My Workspace (no WorkspaceId)" {
        BeforeAll {
            $mockDatasetId = [guid]'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
            Mock -CommandName Confirm-TokenState -MockWith { }
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
        }
    }

    Context "Specific workspace (WorkspaceId provided)" {
        BeforeAll {
            $mockDatasetId   = [guid]'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
            $mockWorkspaceId = [guid]'11111111-2222-3333-4444-555555555555'
            Mock -CommandName Confirm-TokenState -MockWith { }
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
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { throw "API Error" }
        }

        It 'Should not throw and write an error message on API failure' {
            { Get-FabricDatasetRefreshHistory -DatasetId $mockDatasetId } | Should -Not -Throw
            Should -Invoke -CommandName Write-Message -Times 1 -ParameterFilter { $Level -eq 'Error' }
        }
    }
}
