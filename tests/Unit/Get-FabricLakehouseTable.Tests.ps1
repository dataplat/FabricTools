# #Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

# BeforeDiscovery {
#     $CommandName = 'Get-FabricLakehouseTable'
# }

# BeforeAll {
#     $ModuleName = 'FabricTools'
#     $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
#     $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
#     $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
# }

# Describe "Get-FabricLakehouseTable" -Tag "UnitTests" {

#     BeforeAll {
#         $command = Get-Command -Name Get-FabricLakehouseTable
#     }

#     Context 'Command definition' {
#         It 'Should have a command definition' {
#             $command | Should -Not -BeNullOrEmpty
#         }

#         It 'Should have the expected parameter: <Name>' -ForEach @(
#             @{ Name = 'WorkspaceId'; Mandatory = $true }
#             @{ Name = 'LakehouseId'; Mandatory = $true }
#         ) {
#             $command | Should -HaveParameter $Name -Mandatory:$Mandatory
#         }
#     }

#     Context 'When getting lakehouse tables successfully (200)' {
#         BeforeAll {
#             Mock -CommandName Confirm-TokenState -MockWith { }
#             Mock -CommandName Write-Message -MockWith { }
#             Mock -CommandName Invoke-FabricRestMethod -MockWith {
#                 InModuleScope -ModuleName 'FabricTools' {
#                     $script:statusCode = 200
#                 }
#                 return @(
#                     [pscustomobject]@{ name = 'Table1'; type = 'Managed'; format = 'delta' }
#                     [pscustomobject]@{ name = 'Table2'; type = 'External'; format = 'parquet' }
#                 )
#             }
#         }

#         It 'Should call Invoke-FabricRestMethod with the correct parameters' {
#             $mockWorkspaceId = [guid]::NewGuid()
#             $mockLakehouseId = [guid]::NewGuid()

#             Get-FabricLakehouseTable -WorkspaceId $mockWorkspaceId -LakehouseId $mockLakehouseId

#             Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
#                 $Uri -like "*workspaces/*/lakehouses/*/tables*" -and
#                 $Method -eq 'Get'
#             }
#         }

#         It 'Should return the list of tables' {
#             $mockWorkspaceId = [guid]::NewGuid()
#             $mockLakehouseId = [guid]::NewGuid()

#             $result = Get-FabricLakehouseTable -WorkspaceId $mockWorkspaceId -LakehouseId $mockLakehouseId

#             $result | Should -Not -BeNullOrEmpty
#             $result.Count | Should -Be 2
#         }
#     }

#     Context 'When an unexpected status code is returned' {
#         BeforeAll {
#             Mock -CommandName Confirm-TokenState -MockWith { }
#             Mock -CommandName Write-Message -MockWith { }
#             Mock -CommandName Invoke-FabricRestMethod -MockWith {
#                 InModuleScope -ModuleName 'FabricTools' {
#                     $script:statusCode = 400
#                 }
#                 return [pscustomobject]@{
#                     message = 'Bad Request'
#                     errorCode = 'InvalidRequest'
#                 }
#             }
#         }

#         It 'Should write an error message for unexpected status codes' {
#             $mockWorkspaceId = [guid]::NewGuid()
#             $mockLakehouseId = [guid]::NewGuid()

#             Get-FabricLakehouseTable -WorkspaceId $mockWorkspaceId -LakehouseId $mockLakehouseId

#             Should -Invoke -CommandName Write-Message -ParameterFilter {
#                 $Level -eq 'Error'
#             }
#         }
#     }

#     Context 'When an exception is thrown' {
#         BeforeAll {
#             Mock -CommandName Confirm-TokenState -MockWith { }
#             Mock -CommandName Write-Message -MockWith { }
#             Mock -CommandName Invoke-FabricRestMethod -MockWith {
#                 throw 'API connection failed'
#             }
#         }

#         It 'Should handle exceptions gracefully' {
#             $mockWorkspaceId = [guid]::NewGuid()
#             $mockLakehouseId = [guid]::NewGuid()

#             { Get-FabricLakehouseTable -WorkspaceId $mockWorkspaceId -LakehouseId $mockLakehouseId } | Should -Not -Throw

#             Should -Invoke -CommandName Write-Message -ParameterFilter {
#                 $Level -eq 'Error' -and $Message -like "*Failed to retrieve lakehouse tables*"
#             }
#         }
#     }
# }
