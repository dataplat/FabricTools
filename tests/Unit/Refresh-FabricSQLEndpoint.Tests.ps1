#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Refresh-FabricSQLEndpoint'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Refresh-FabricSQLEndpoint" -Tag "UnitTests" {
    BeforeAll {
        $command = Get-Command -Name Refresh-FabricSQLEndpoint
    }

    Context 'Command definition' {
        It 'Should have the expected parameters' {
            $command | Should -HaveParameter WorkspaceId -Mandatory
            $command | Should -HaveParameter SQLEndpointId -Mandatory
            $command | Should -HaveParameter Timeout -Mandatory:$false
            $command | Should -HaveParameter NoWait -Mandatory:$false
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'When refreshing SQL endpoint metadata successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                [pscustomobject]@{ OperationId = 'refresh-operation' }
            }
        }

        It 'Should call the API with the expected route and default settings' {
            $workspaceId = [guid]::NewGuid()
            $sqlEndpointId = [guid]::NewGuid()

            Refresh-FabricSQLEndpoint -WorkspaceId $workspaceId -SQLEndpointId $sqlEndpointId -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -eq "workspaces/$workspaceId/sqlEndpoints/$sqlEndpointId/refreshMetadata" -and
                $Method -eq 'Post' -and
                $Timeout -eq 15 -and
                -not $NoWait -and
                $HandleResponse
            }
        }

        It 'Should return the refresh response' {
            $result = Refresh-FabricSQLEndpoint -WorkspaceId ([guid]::NewGuid()) -SQLEndpointId ([guid]::NewGuid()) -Confirm:$false

            $result.OperationId | Should -Be 'refresh-operation'
        }

        It 'Should forward the timeout and no-wait options' {
            Refresh-FabricSQLEndpoint -WorkspaceId ([guid]::NewGuid()) -SQLEndpointId ([guid]::NewGuid()) -Timeout 4 -NoWait -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Timeout -eq 4 -and $NoWait
            }
        }

        It 'Should honor WhatIf without making an API request' {
            Refresh-FabricSQLEndpoint -WorkspaceId ([guid]::NewGuid()) -SQLEndpointId ([guid]::NewGuid()) -WhatIf

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0
        }
    }

    Context 'Parameter validation' {
        It 'Should reject a negative timeout' {
            {
                Refresh-FabricSQLEndpoint -WorkspaceId ([guid]::NewGuid()) -SQLEndpointId ([guid]::NewGuid()) -Timeout -1
            } | Should -Throw
        }
    }
}
