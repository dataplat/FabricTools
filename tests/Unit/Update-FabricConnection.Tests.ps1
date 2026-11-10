#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $PSDefaultParameterValues['Mock:ModuleName'] = 'FabricTools'
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = 'FabricTools'
}

Describe 'Update-FabricConnection' -Tag 'UnitTests' {
    BeforeEach {
        InModuleScope FabricTools { Mock Invoke-FabricRestMethod { [pscustomobject]@{ id = 'connection-id' } } }
    }

    It 'Patches the display name' {
        InModuleScope FabricTools {
            $id = [guid]::NewGuid()
            Update-FabricConnection -ConnectionId $id -ConnectionName Renamed -Confirm:$false
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -eq "connections/$id" -and $Method -eq 'Patch' -and
                $Body.displayName -eq 'Renamed' -and $HandleResponse
            }
        }
    }

    It 'Redacts credential update bodies' {
        InModuleScope FabricTools {
            $id = [guid]::NewGuid()
            $credential = [pscredential]::new('user', (ConvertTo-SecureString 'secret' -AsPlainText -Force))
            Update-FabricConnection -ConnectionId $id -CredentialType Basic -Credential $credential -Confirm:$false
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter { $SuppressBodyLogging }
        }
    }
}
