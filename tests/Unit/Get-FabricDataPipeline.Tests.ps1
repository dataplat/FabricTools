#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricDataPipeline'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricDataPipeline" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricDataPipeline
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'DataPipelineId'; Mandatory = $false }
            @{ Name = 'DataPipelineName'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When retrieving data pipelines successfully (200)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    value = @(
                        [pscustomobject]@{
                            Id = [guid]::NewGuid()
                            DisplayName = 'TestDataPipeline1'
                        },
                        [pscustomobject]@{
                            Id = [guid]::NewGuid()
                            DisplayName = 'TestDataPipeline2'
                        }
                    )
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()

            Get-FabricDataPipeline -WorkspaceId $mockWorkspaceId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/dataPipelines*" -and
                $Method -eq 'Get'
            }
        }

        It 'Should return all data pipelines when no filter is provided' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = Get-FabricDataPipeline -WorkspaceId $mockWorkspaceId

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 2
        }
    }

    Context 'When both DataPipelineId and DataPipelineName are provided' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should write an error message' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockDataPipelineId = [guid]::NewGuid()

            Get-FabricDataPipeline -WorkspaceId $mockWorkspaceId -DataPipelineId $mockDataPipelineId -DataPipelineName 'TestDataPipeline'

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Both*"
            }
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

            Get-FabricDataPipeline -WorkspaceId $mockWorkspaceId

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to retrieve DataPipeline*"
            }
        }
    }
}
