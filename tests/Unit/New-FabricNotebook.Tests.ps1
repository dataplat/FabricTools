#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'New-FabricNotebook'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "New-FabricNotebook" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name New-FabricNotebook
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'NotebookName'; Mandatory = $true }
            @{ Name = 'NotebookDescription'; Mandatory = $false }
            @{ Name = 'NotebookPathDefinition'; Mandatory = $false }
            @{ Name = 'NotebookPathPlatformDefinition'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'When creating notebook successfully with immediate completion (201)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 201
                }
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    displayName = 'TestNotebook'
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()

            New-FabricNotebook -WorkspaceId $mockWorkspaceId -NotebookName 'TestNotebook' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/notebooks" -and
                $Method -eq 'Post'
            }
        }

        It 'Should return the created notebook' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = New-FabricNotebook -WorkspaceId $mockWorkspaceId -NotebookName 'TestNotebook' -Confirm:$false

            $result.displayName | Should -Be 'TestNotebook'
        }
    }

    Context 'When an exception is thrown' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw 'API connection failed'
            }
        }

        It 'Should handle exceptions gracefully' {
            $mockWorkspaceId = [guid]::NewGuid()

            { New-FabricNotebook -WorkspaceId $mockWorkspaceId -NotebookName 'TestNotebook' -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to create notebook*"
            }
        }
    }
}
