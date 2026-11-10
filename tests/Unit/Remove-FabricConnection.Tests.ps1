#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $PSDefaultParameterValues['Mock:ModuleName'] = 'FabricTools'
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = 'FabricTools'
}

Describe 'Remove-FabricConnection' -Tag 'UnitTests' {
    BeforeEach {
        InModuleScope FabricTools { Mock Invoke-FabricRestMethod { } }
    }

    It 'Deletes a connection by ID' {
        InModuleScope FabricTools {
            $id = [guid]::NewGuid()
            Remove-FabricConnection -ConnectionId $id -Confirm:$false
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -eq "connections/$id" -and $Method -eq 'Delete' -and $HandleResponse
            }
        }
    }

    It 'Honors WhatIf' {
        InModuleScope FabricTools {
            Remove-FabricConnection -ConnectionId ([guid]::NewGuid()) -WhatIf
            Should -Invoke Invoke-FabricRestMethod -Times 0
        }
    }
}
