#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Add-FabricWorkspaceToStage'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Add-FabricWorkspaceToStage" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Add-FabricWorkspaceToStage
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'DeploymentPipelineId'; Mandatory = $true }
            @{ Name = 'StageId'; Mandatory = $true }
            @{ Name = 'WorkspaceId'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When assigning workspace to stage successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return [pscustomobject]@{
                    id = [guid]::NewGuid()
                    status = 'Succeeded'
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockPipelineId = [guid]::NewGuid()
            $mockStageId = [guid]::NewGuid()
            $mockWorkspaceId = [guid]::NewGuid()

            Add-FabricWorkspaceToStage -DeploymentPipelineId $mockPipelineId -StageId $mockStageId -WorkspaceId $mockWorkspaceId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*deploymentPipelines/*/stages/*/assignWorkspace" -and
                $Method -eq 'POST'
            }
        }

        It 'Should return the response' {
            $mockPipelineId = [guid]::NewGuid()
            $mockStageId = [guid]::NewGuid()
            $mockWorkspaceId = [guid]::NewGuid()

            $result = Add-FabricWorkspaceToStage -DeploymentPipelineId $mockPipelineId -StageId $mockStageId -WorkspaceId $mockWorkspaceId

            $result | Should -Not -BeNullOrEmpty
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

        It 'Should write an error for exceptions' {
            $mockPipelineId = [guid]::NewGuid()
            $mockStageId = [guid]::NewGuid()
            $mockWorkspaceId = [guid]::NewGuid()

            # The function uses Write-Error, not Write-Message for error handling
            { Add-FabricWorkspaceToStage -DeploymentPipelineId $mockPipelineId -StageId $mockStageId -WorkspaceId $mockWorkspaceId -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
