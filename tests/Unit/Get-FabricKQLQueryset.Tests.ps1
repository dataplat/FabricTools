#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'Get-FabricKQLQueryset'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'Get-FabricKQLQueryset'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "Get-FabricKQLQueryset" -Tag "UnitTests" {

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

        It "Command <CommandName> should have KQLQuerysetId parameter" {
            $command | Should -HaveParameter 'KQLQuerysetId' -Type [guid]
        }

        It "Command <CommandName> should have KQLQuerysetName parameter" {
            $command | Should -HaveParameter 'KQLQuerysetName' -Type [string]
        }
    }

    Context "Get KQL Queryset successfully" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @{
                    value = @(
                        [pscustomobject]@{
                            id          = "00000000-0000-0000-0000-000000000001"
                            displayName = "TestKQLQueryset"
                            description = "Test KQL Queryset Description"
                            type        = "KQLQueryset"
                        }
                    )
                }
            }
        }

        It "Should return KQL querysets" {
            $result = Get-FabricKQLQueryset -WorkspaceId ([guid]::NewGuid())
            $result | Should -Not -BeNullOrEmpty
            $result.displayName | Should -Be "TestKQLQueryset"

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }

        It "Should return specific KQL queryset by Id" {
            $result = Get-FabricKQLQueryset -WorkspaceId ([guid]::NewGuid()) -KQLQuerysetId ([guid]::NewGuid())
            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw "API Error"
            }
        }

        It "Should handle errors gracefully" {
            { Get-FabricKQLQueryset -WorkspaceId ([guid]::NewGuid()) } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to retrieve*"
            }
        }
    }
}
