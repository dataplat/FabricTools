#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'Get-FabricEventstream'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'Get-FabricEventstream'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "Get-FabricEventstream" -Tag "UnitTests" {

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

        It "Command <CommandName> should have EventstreamId parameter" {
            $command | Should -HaveParameter 'EventstreamId' -Type [guid]
        }

        It "Command <CommandName> should have EventstreamName parameter" {
            $command | Should -HaveParameter 'EventstreamName' -Type [string]
        }
    }

    Context "Get Eventstream successfully" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @(
                    [pscustomobject]@{
                        id          = "00000000-0000-0000-0000-000000000001"
                        displayName = "TestEventstream"
                        description = "Test Eventstream Description"
                        type        = "Eventstream"
                    }
                )
            }
        }

        It "Should return eventstreams" {
            $result = Get-FabricEventstream -WorkspaceId ([guid]::NewGuid())
            $result | Should -Not -BeNullOrEmpty
            $result.displayName | Should -Be "TestEventstream"

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }

        It "Should return specific eventstream by Id" {
            $result = Get-FabricEventstream -WorkspaceId ([guid]::NewGuid()) -EventstreamId ([guid]::NewGuid())
            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }
}
