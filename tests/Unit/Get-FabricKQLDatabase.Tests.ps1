#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'Get-FabricKQLDatabase'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'Get-FabricKQLDatabase'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "Get-FabricKQLDatabase" -Tag "UnitTests" {

    Context "Command definition" {
        BeforeAll {
            $command = Get-Command -Name $CommandName -Module $ModuleName
        }

        It "Command <CommandName> should exist" {
            $command | Should -Not -BeNullOrEmpty
        }

        It "Command <CommandName> should have WorkspaceId parameter" {
            $command | Should -HaveParameter 'WorkspaceId' -Type [guid]
        }

        It "Command <CommandName> should have KQLDatabaseId parameter" {
            $command | Should -HaveParameter 'KQLDatabaseId' -Type [guid]
        }

        It "Command <CommandName> should have KQLDatabaseName parameter" {
            $command | Should -HaveParameter 'KQLDatabaseName' -Type [string]
        }
    }

    Context "Get KQL Database successfully" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @(
                    [pscustomobject]@{
                        id          = "00000000-0000-0000-0000-000000000001"
                        displayName = "TestKQLDatabase"
                        description = "Test KQL Database Description"
                        type        = "KQLDatabase"
                    }
                )
            }
        }

        It "Should return KQL databases" {
            $result = Get-FabricKQLDatabase -WorkspaceId ([guid]::NewGuid())
            $result | Should -Not -BeNullOrEmpty
            $result.displayName | Should -Be "TestKQLDatabase"

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }

        It "Should return specific KQL database by Id" {
            $result = Get-FabricKQLDatabase -WorkspaceId ([guid]::NewGuid()) -KQLDatabaseId "00000000-0000-0000-0000-000000000001"
            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }

        It "Should accept workspace pipeline input by <InputType>" -ForEach @(
            @{ InputType = 'value' }
            @{ InputType = 'WorkspaceId property' }
            @{ InputType = 'Id property' }
        ) {
            $workspaceId = [guid]::NewGuid()
            $workspace = switch ($InputType) {
                'value' { $workspaceId }
                'WorkspaceId property' { [pscustomobject]@{ WorkspaceId = $workspaceId } }
                'Id property' { [pscustomobject]@{ Id = $workspaceId.ToString(); DisplayName = 'TestWorkspace' } }
            }

            $result = $workspace | Get-FabricKQLDatabase -ErrorAction Stop

            $result.displayName | Should -Be "TestKQLDatabase"
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -like "*/workspaces/$workspaceId/kqlDatabases" -and $Method -eq 'Get'
            }
        }

        It "Should retrieve KQL databases for every workspace returned by Get-FabricWorkspace" {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                if ($Uri -eq 'workspaces') {
                    return @(
                        [pscustomobject]@{ Id = '00000000-0000-0000-0000-000000000002'; DisplayName = 'Workspace1' }
                        [pscustomobject]@{ Id = '00000000-0000-0000-0000-000000000003'; DisplayName = 'Workspace2' }
                    )
                }
                return [pscustomobject]@{ Id = '00000000-0000-0000-0000-000000000001'; DisplayName = 'TestKQLDatabase' }
            }

            $result = @(Get-FabricWorkspace | Get-FabricKQLDatabase -KQLDatabaseName 'TestKQLDatabase' -ErrorAction Stop)

            $result.Count | Should -Be 2
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -like '*/workspaces/00000000-0000-0000-0000-000000000002/kqlDatabases'
            }
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -like '*/workspaces/00000000-0000-0000-0000-000000000003/kqlDatabases'
            }
        }
    }

}
