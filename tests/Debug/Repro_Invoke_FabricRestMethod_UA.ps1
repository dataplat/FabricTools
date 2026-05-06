Import-Module .\src\FabricTools.psm1 -Force

$script:capturedHeaders = $null

function Get-PSFConfigValue {
    param($FullName)
    switch ($FullName) {
        'FabricTools.UserAgent' { return 'TestUA/1.2' }
        'FabricTools.FabricSession.Headers' { return @{} }
        'FabricTools.FabricApi.ContentType' { return 'application/json; charset=utf-8' }
        default { return $null }
    }
}

function Invoke-RestMethod {
    # Dump PSBoundParameters for inspection
    Write-Output "PSBoundParameters:"
    Write-Output ($PSBoundParameters | ConvertTo-Json -Compress)
    $script:capturedHeaders = $PSBoundParameters['Headers']
    return @{ value = @(); statusCode = 200 }
}

Invoke-FabricRestMethod -Uri 'https://api.fabric.microsoft.com/v1/test' | Out-Null

Write-Output 'CapturedHeaders:'
$script:capturedHeaders

Write-Output 'CapturedHeaders.Keys:'
if ($script:capturedHeaders) { $script:capturedHeaders.Keys } else { Write-Output '<null or empty>' }
