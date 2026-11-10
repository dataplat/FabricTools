#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Export-FabricItem'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Export-FabricItem
}

Describe "Export-FabricItem" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'path'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'workspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'filter'; ExpectedParameterType = 'scriptblock'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'itemID'; ExpectedParameterType = 'guid'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    Context "Successful item export" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    definition = [pscustomobject]@{
                        parts = @(
                            [pscustomobject]@{ path = 'item.json'; payload = 'encodedPayload' }
                        )
                    }
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Get-FabricItem -MockWith {
                return @(
                    [pscustomobject]@{ id = 'item-guid'; displayName = 'TestItem'; type = 'Notebook' }
                )
            }
            Mock -CommandName Convert-FromBase64 -MockWith { return '{}' }
            Mock -CommandName Test-Path -MockWith { return $true }
            Mock -CommandName New-Item -MockWith { return $null }
            Mock -CommandName Set-Content -MockWith { return $null }

            $mockWorkspaceId = [guid]::NewGuid()
            $mockItemId = [guid]::NewGuid()
        }

        It 'Should export items when workspaceId and path are provided' {
            { Export-FabricItem -workspaceId $mockWorkspaceId -path 'C:\temp\export' } | Should -Not -Throw
        }
    }

    Context "Listing items in the workspace" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            # Listing: Invoke-FabricRestMethod (ExtractValue = 'True') returns the items of the 'value' array
            Mock -CommandName Invoke-FabricRestMethod -ParameterFilter { $Uri -like '*/items' } -MockWith {
                [pscustomobject]@{ id = '11111111-1111-1111-1111-111111111111'; displayName = 'TestNotebook'; type = 'Notebook' }
                [pscustomobject]@{ id = '22222222-2222-2222-2222-222222222222'; displayName = 'TestLakehouse'; type = 'Lakehouse' }
            }
            # getDefinition: no parts, so nothing is written to disk
            Mock -CommandName Invoke-FabricRestMethod -ParameterFilter { $Uri -like '*/getDefinition' } -MockWith {
                [pscustomobject]@{ definition = [pscustomobject]@{ parts = @() } }
            }
        }

        It 'Should list the workspace items and export those matching the filter' {
            $output = Export-FabricItem -workspaceId ([guid]::NewGuid()) -path 'TestDrive:\export'

            $output | Should -Contain 'Existing items: 1'
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -like '*/items' -and $ExtractValue -eq 'True'
            }
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $Uri -like '*/items/11111111-1111-1111-1111-111111111111/getDefinition'
            }
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 400
                }
                throw "API Error"
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Get-FabricItem -MockWith { throw "API Error" }

            $mockWorkspaceId = [guid]::NewGuid()
        }

        It 'Should throw an error when API call fails' {
            {
                Export-FabricItem -workspaceId $mockWorkspaceId -path 'C:\temp\export'
            } | Should -Throw
        }
    }
}
