#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $ModuleName = 'FabricTools'
    $CommandName = 'Get-FabricNotebookDefinition'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $CommandName = 'Get-FabricNotebookDefinition'

    # Set default parameters for module scope
    $PSDefaultParameterValues = @{
        "Mock:ModuleName"          = $ModuleName
        "InModuleScope:ModuleName" = $ModuleName
        "Should:ModuleName"        = $ModuleName
    }
}

Describe "Get-FabricNotebookDefinition" -Tag "UnitTests" {

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

        It "Command <CommandName> should have NotebookId parameter" {
            $command | Should -HaveParameter 'NotebookId' -Type [guid]
        }

        It "Command <CommandName> should have NotebookFormat parameter" {
            $command | Should -HaveParameter 'NotebookFormat' -Type [string]
        }
    }

    Context "Get Notebook Definition successfully" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return [pscustomobject]@{
                    definition = @{
                        parts = @(
                            @{
                                path        = "notebook-content.py"
                                payload     = "cHJpbnQoJ2hlbGxvJyk="
                                payloadType = "InlineBase64"
                            }
                        )
                    }
                }
            }
        }

        It "Should return notebook definition" {
            $result = Get-FabricNotebookDefinition -WorkspaceId ([guid]::NewGuid()) -NotebookId ([guid]::NewGuid())
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
            { Get-FabricNotebookDefinition -WorkspaceId ([guid]::NewGuid()) -NotebookId ([guid]::NewGuid()) } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }
}
