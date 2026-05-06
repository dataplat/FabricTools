#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Add-FabricWorkspaceIdentity'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Add-FabricWorkspaceIdentity" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Add-FabricWorkspaceIdentity
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'Parameter alias validation' {
        It 'Should have "Id" as an alias for WorkspaceId parameter' {
            $param = (Get-Command -Name 'Add-FabricWorkspaceIdentity').Parameters['WorkspaceId']
            $param.Aliases | Should -Contain 'Id'
        }
    }

    Context 'When provisioning identity successfully with immediate completion (200)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    applicationId = [guid]::NewGuid()
                    servicePrincipalId = [guid]::NewGuid()
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()

            Add-FabricWorkspaceIdentity -WorkspaceId $mockWorkspaceId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/provisionIdentity" -and
                $Method -eq 'Post'
            }
        }

        It 'Should return the identity information' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = Add-FabricWorkspaceIdentity -WorkspaceId $mockWorkspaceId

            $result.applicationId | Should -Not -BeNullOrEmpty
            $result.servicePrincipalId | Should -Not -BeNullOrEmpty
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

            { Add-FabricWorkspaceIdentity -WorkspaceId $mockWorkspaceId } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to provision workspace identity*"
            }
        }
    }
}
