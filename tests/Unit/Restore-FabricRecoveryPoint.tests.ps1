#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Restore-FabricRecoveryPoint'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Restore-FabricRecoveryPoint
}

Describe "Restore-FabricRecoveryPoint" -Tag 'UnitTests' {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'CreateTime'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'WorkspaceGUID'; ExpectedParameterType = 'guid'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'DataWarehouseGUID'; ExpectedParameterType = 'guid'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'BaseUrl'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'Wait'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Successful restore without waiting" {
        BeforeAll {
            Mock -CommandName Get-PSFConfigValue -MockWith { return $null }
            Mock -CommandName Get-FabricUri -MockWith {
                return @{
                    Uri = "https://api.powerbi.com/test"
                    Method = "Post"
                    Headers = @{ Authorization = "Bearer token" }
                }
            }
            Mock -CommandName Get-FabricRecoveryPoint -MockWith {
                return [pscustomobject]@{ createTime = '2024-07-23T11:20:26Z' }
            }
            Mock -CommandName Invoke-WebRequest -MockWith {
                return [pscustomobject]@{
                    Content = '{"batchId": "batch-123", "status": "inProgress"}'
                }
            }
            Mock -CommandName Write-PSFMessage -MockWith { }
        }

        It 'Should restore to recovery point with valid parameters' {
            $result = Restore-FabricRecoveryPoint -CreateTime '2024-07-23T11:20:26Z' -WorkspaceGUID (New-Guid) -DataWarehouseGUID (New-Guid) -Confirm:$false

            Should -Invoke -CommandName Get-FabricUri -Times 1 -Exactly
            Should -Invoke -CommandName Get-FabricRecoveryPoint -Times 1 -Exactly
            Should -Invoke -CommandName Invoke-WebRequest -Times 1 -Exactly
            Should -Invoke -CommandName Write-PSFMessage -ParameterFilter { $Message -like '*Restore in progress*' } -Times 1 -Exactly -Scope It
        }
    }

    Context "Successful restore with waiting - success" {
        BeforeAll {
            Mock -CommandName Get-PSFConfigValue -MockWith { return $null }
            Mock -CommandName Get-FabricUri -MockWith {
                return @{
                    Uri = "https://api.powerbi.com/test"
                    Method = "Post"
                    Headers = @{ Authorization = "Bearer token" }
                }
            }
            Mock -CommandName Get-FabricRecoveryPoint -MockWith {
                return [pscustomobject]@{ createTime = '2024-07-23T11:20:26Z' }
            }
            Mock -CommandName Invoke-WebRequest -MockWith {
                return [pscustomobject]@{
                    Content = '{"batchId": "batch-123", "progressState": "success", "startTimeStamp": "2024-07-23T11:25:00Z"}'
                }
            }
            Mock -CommandName Write-PSFMessage -MockWith { }
        }

        It 'Should wait for restore to complete successfully' {
            $result = Restore-FabricRecoveryPoint -CreateTime '2024-07-23T11:20:26Z' -WorkspaceGUID (New-Guid) -DataWarehouseGUID (New-Guid) -Wait -Confirm:$false

            Should -Invoke -CommandName Invoke-WebRequest -Times 2 -Exactly
            Should -Invoke -CommandName Write-PSFMessage -ParameterFilter { $Message -like '*Restore completed successfully*' } -Times 1 -Exactly -Scope It
        }
    }

    Context "Restore with waiting - failure" {
        BeforeAll {
            Mock -CommandName Get-PSFConfigValue -MockWith { return $null }
            Mock -CommandName Get-FabricUri -MockWith {
                return @{
                    Uri = "https://api.powerbi.com/test"
                    Method = "Post"
                    Headers = @{ Authorization = "Bearer token" }
                }
            }
            Mock -CommandName Get-FabricRecoveryPoint -MockWith {
                return [pscustomobject]@{ createTime = '2024-07-23T11:20:26Z' }
            }
            Mock -CommandName Invoke-WebRequest -MockWith {
                return [pscustomobject]@{
                    Content = '{"batchId": "batch-123", "progressState": "failed", "startTimeStamp": "2024-07-23T11:25:00Z"}'
                }
            }
            Mock -CommandName Write-PSFMessage -MockWith { }
        }

        It 'Should handle restore failure' {
            $result = Restore-FabricRecoveryPoint -CreateTime '2024-07-23T11:20:26Z' -WorkspaceGUID (New-Guid) -DataWarehouseGUID (New-Guid) -Wait -Confirm:$false

            Should -Invoke -CommandName Write-PSFMessage -ParameterFilter { $Message -like '*Restore failed*' } -Times 1 -Exactly -Scope It
        }
    }

    Context "Recovery point not found" {
        BeforeAll {
            Mock -CommandName Get-PSFConfigValue -MockWith { return $null }
            Mock -CommandName Get-FabricUri -MockWith {
                return @{
                    Uri = "https://api.powerbi.com/test"
                    Method = "Post"
                    Headers = @{ Authorization = "Bearer token" }
                }
            }
            Mock -CommandName Get-FabricRecoveryPoint -MockWith { return $null }
            Mock -CommandName Stop-PSFFunction -MockWith { }
        }

        It 'Should stop when recovery point is not found' {
            Restore-FabricRecoveryPoint -CreateTime '2024-07-23T11:20:26Z' -WorkspaceGUID (New-Guid) -DataWarehouseGUID (New-Guid) -Confirm:$false

            Should -Invoke -CommandName Stop-PSFFunction -ParameterFilter { $Message -like '*restore point not found*' } -Times 1 -Exactly -Scope It
        }
    }

    Context "Missing required configuration" {
        BeforeAll {
            Mock -CommandName Get-PSFConfigValue -MockWith { return $null }
            Mock -CommandName Stop-PSFFunction -MockWith { }
        }

        It 'Should stop when required parameters are missing' {
            Restore-FabricRecoveryPoint -CreateTime '2024-07-23T11:20:26Z' -Confirm:$false

            Should -Invoke -CommandName Stop-PSFFunction -ParameterFilter { $Message -like '*required parameters*' } -Times 1 -Exactly -Scope It
        }
    }

    Context "Uses config values when parameters not provided" {
        BeforeAll {
            Mock -CommandName Get-PSFConfigValue -MockWith {
                param($FullName)
                switch ($FullName) {
                    'FabricTools.WorkspaceGUID' { return [guid]::NewGuid() }
                    'FabricTools.DataWarehouseGUID' { return [guid]::NewGuid() }
                    'FabricTools.BaseUrl' { return 'api.powerbi.com' }
                }
            }
            Mock -CommandName Get-FabricUri -MockWith {
                return @{
                    Uri = "https://api.powerbi.com/test"
                    Method = "Post"
                    Headers = @{ Authorization = "Bearer token" }
                }
            }
            Mock -CommandName Get-FabricRecoveryPoint -MockWith {
                return [pscustomobject]@{ createTime = '2024-07-23T11:20:26Z' }
            }
            Mock -CommandName Invoke-WebRequest -MockWith {
                return [pscustomobject]@{
                    Content = '{"batchId": "batch-123", "status": "inProgress"}'
                }
            }
            Mock -CommandName Write-PSFMessage -MockWith { }
        }

        It 'Should use config values when parameters are not provided' {
            Restore-FabricRecoveryPoint -CreateTime '2024-07-23T11:20:26Z' -Confirm:$false

            Should -Invoke -CommandName Get-PSFConfigValue -Times 3 -Exactly
            Should -Invoke -CommandName Get-FabricUri -Times 1 -Exactly
        }
    }
}
