#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Invoke-FabricRestMethod'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Invoke-FabricRestMethod
}

Describe "Invoke-FabricRestMethod" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'Uri'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'Method'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'Body'; ExpectedParameterType = 'object'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'TestTokenExpired'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'PowerBIApi'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'NoWait'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'HandleResponse'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'ExtractValue'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'TypeName'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'ObjectIdOrName'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'SuccessMessage'; ExpectedParameterType = 'string'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    Context "Successful REST call" {
        BeforeAll {
            Mock -CommandName Invoke-WebRequest -MockWith {
                return @{
                    StatusCode = 200
                    Headers = @{}
                    Content = '{"value": [{"id": "test-id", "name": "test-name"}]}'
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should invoke REST method successfully' {
            InModuleScope -ModuleName 'FabricTools' {
                { Invoke-FabricRestMethod -Uri 'https://api.fabric.microsoft.com/v1/workspaces' } | Should -Not -Throw
            }
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -MockWith {
                return @{
                    errorCode = 'TestError'
                    message = 'API Error'
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should not throw when API returns error response (SkipHttpErrorCheck is used)' {
            InModuleScope -ModuleName 'FabricTools' {
                { Invoke-FabricRestMethod -Uri 'https://api.fabric.microsoft.com/v1/workspaces' } | Should -Not -Throw
            }
        }
    }

    Context "User-Agent header" {
        BeforeAll {
            # Clean up any previous dump files
            $dumpPath = Join-Path $PSScriptRoot '..\..\output\invoke-restmethod-mock-dump.json'
            $outDir = Split-Path $dumpPath -Parent
            if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
            Remove-Item -Path $dumpPath -ErrorAction SilentlyContinue

            # Capture the headers passed to Invoke-RestMethod
            Set-Variable -Name capturedHeaders -Value $null -Scope Script -Force

            Mock -CommandName Get-PSFConfigValue -MockWith {
                param($FullName)
                $logPath = Join-Path $PSScriptRoot '..\..\output\get-psfconfig-dump.json'
                $entry = @{ Name = $FullName; Time = (Get-Date).ToString('o') }
                Add-Content -Path $logPath -Value ($entry | ConvertTo-Json -Compress)
                switch ($FullName) {
                    'FabricTools.UserAgent' { return 'TestUA/1.2' }
                    'FabricTools.FabricSession.Headers' { return @{ 'User-Agent' = 'TestUA/1.2' } }
                    'FabricTools.FabricApi.ContentType' { return 'application/json; charset=utf-8' }
                    Default { return $null }
                }
            }

            Mock -CommandName Invoke-RestMethod -MockWith {
                $dump = @{ Bound = $PSBoundParameters; Args = $args } | ConvertTo-Json -Compress
                $outPath = Join-Path $PSScriptRoot '..\..\output\invoke-restmethod-mock-dump.json'
                $outDir = Split-Path $outPath -Parent
                if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
                Set-Content -Path $outPath -Value $dump  # Use Set-Content (not Add-Content) to write single JSON object

                if ($PSBoundParameters.ContainsKey('Headers')) {
                    Set-Variable -Name capturedHeaders -Value $PSBoundParameters['Headers'] -Scope Script -Force
                } elseif ($args -and $args.Count -ge 2) {
                    # Pester may pass named parameters as an args array: ['-Param:', <value>, ...]
                    for ($i = 0; $i -lt $args.Count; $i += 2) {
                        $name = $args[$i].ToString()
                        if ($name -match 'Headers') {
                            Set-Variable -Name capturedHeaders -Value $args[$i + 1] -Scope Script -Force
                            break
                        }
                    }
                } else {
                    Set-Variable -Name capturedHeaders -Value $null -Scope Script -Force
                }
                return @{ value = @() ; statusCode = 200 }
            }

            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should include configured User-Agent header in request' {
            InModuleScope -ModuleName 'FabricTools' {
                Invoke-FabricRestMethod -Uri 'https://api.fabric.microsoft.com/v1/test' | Out-Null

                # Try to capture from script variable first (if mock successfully set it)
                $captured = $script:capturedHeaders

                # If not captured via script variable, read from dump file
                if (-not $captured) {
                    $dumpPath = Join-Path $PSScriptRoot '..\..\output\invoke-restmethod-mock-dump.json'
                    if (Test-Path $dumpPath) {
                        $dump = Get-Content $dumpPath -Raw | ConvertFrom-Json
                        $args = $dump.Args
                        # Find Headers in the args array
                        for ($i = 0; $i -lt $args.Count - 1; $i++) {
                            if ($args[$i] -eq '-Headers:') {
                                $captured = $args[$i + 1]
                                break
                            }
                        }
                    }
                }

                # Assert the headers were captured and contain User-Agent
                $captured | Should -Not -BeNullOrEmpty -Because 'Headers should be captured from mock'
                $captured.'User-Agent' | Should -Be 'TestUA/1.2' -Because 'User-Agent header should be set to configured value'
            }
        }
    }
}
