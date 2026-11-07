#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe 'Get-FabricGitConnection' -Tag 'UnitTests' {

    BeforeAll {
        $command = Get-Command -Name Get-FabricGitConnection
    }

    Context 'Command definition' {
        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should accept WorkspaceId from the pipeline by property name with alias Id' {
            $param = $command.Parameters['WorkspaceId']
            $param.Aliases | Should -Contain 'Id'
            $param.Attributes.ValueFromPipelineByPropertyName | Should -Contain $true
        }
    }

    Context 'When the workspace is connected' {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                [pscustomobject]@{
                    gitConnectionState = 'ConnectedAndInitialized'
                    gitProviderDetails = [pscustomobject]@{ gitProviderType = 'AzureDevOps' }
                    gitSyncDetails     = [pscustomobject]@{ head = 'abc' }
                }
            }
            $workspaceId = [guid]::NewGuid()
        }

        It 'Should call the connection endpoint with GET' {
            Get-FabricGitConnection -WorkspaceId $workspaceId | Out-Null

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -eq "workspaces/$workspaceId/git/connection" -and $Method -eq 'Get' -and $HandleResponse
            }
        }

        It 'Should return the connection with WorkspaceId added' {
            $result = Get-FabricGitConnection -WorkspaceId $workspaceId

            $result.gitConnectionState | Should -Be 'ConnectedAndInitialized'
            $result.WorkspaceId | Should -Be $workspaceId
        }

        It 'Should accept workspace objects from the pipeline' {
            $result = [pscustomobject]@{ id = $workspaceId } | Get-FabricGitConnection

            $result.WorkspaceId | Should -Be $workspaceId
        }
    }

    Context 'When the API call fails' {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { throw 'API request failed with status code 404.' }
        }

        It 'Should throw' {
            { Get-FabricGitConnection -WorkspaceId ([guid]::NewGuid()) } | Should -Throw '*404*'
        }
    }
}
