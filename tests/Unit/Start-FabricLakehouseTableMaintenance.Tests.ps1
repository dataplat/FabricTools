#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Start-FabricLakehouseTableMaintenance'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Start-FabricLakehouseTableMaintenance" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Start-FabricLakehouseTableMaintenance
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'LakehouseId'; Mandatory = $true }
            @{ Name = 'JobType'; Mandatory = $false }
            @{ Name = 'SchemaName'; Mandatory = $false }
            @{ Name = 'TableName'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'When starting lakehouse table maintenance successfully (202)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Get-FabricLakehouse -MockWith {
                return [pscustomobject]@{
                    displayName = 'TestLakehouse'
                    properties = [pscustomobject]@{}
                }
            }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 202
                    $script:responseHeader = @{
                        'x-ms-operation-id' = [guid]::NewGuid().ToString()
                        'Location' = 'https://api.fabric.microsoft.com/operations/123'
                        'Retry-After' = 10
                    }
                }
                return $null
            }
            Mock -CommandName Get-FabricLongRunningOperation -MockWith {
                return [pscustomobject]@{
                    status = 'Succeeded'
                    createdTimeUtc = (Get-Date).ToString()
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockLakehouseId = [guid]::NewGuid()

            Start-FabricLakehouseTableMaintenance -WorkspaceId $mockWorkspaceId -LakehouseId $mockLakehouseId -JobType 'TableMaintenance' -TableName 'TestTable' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/lakehouses/*/jobs/instances*" -and
                $Method -eq 'Post'
            }
        }
    }

    Context 'When an unexpected status code is returned' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Get-FabricLakehouse -MockWith {
                return [pscustomobject]@{
                    displayName = 'TestLakehouse'
                    properties = [pscustomobject]@{}
                }
            }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 400
                }
                return [pscustomobject]@{
                    message = 'Bad Request'
                    errorCode = 'InvalidRequest'
                }
            }
        }

        It 'Should write an error message for unexpected status codes' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockLakehouseId = [guid]::NewGuid()

            Start-FabricLakehouseTableMaintenance -WorkspaceId $mockWorkspaceId -LakehouseId $mockLakehouseId -JobType 'TableMaintenance' -TableName 'TestTable' -Confirm:$false

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }

    Context 'When an exception is thrown' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Get-FabricLakehouse -MockWith {
                return [pscustomobject]@{
                    displayName = 'TestLakehouse'
                    properties = [pscustomobject]@{}
                }
            }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw 'API connection failed'
            }
        }

        It 'Should handle exceptions gracefully' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockLakehouseId = [guid]::NewGuid()

            { Start-FabricLakehouseTableMaintenance -WorkspaceId $mockWorkspaceId -LakehouseId $mockLakehouseId -JobType 'TableMaintenance' -TableName 'TestTable' -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to start table maintenance job*"
            }
        }
    }
}
