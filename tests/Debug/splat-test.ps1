$h = @{}
$h['User-Agent'] = 'x'
$splat = @{ Headers = $h; Uri = 'u' }
function f { Write-Output ($PSBoundParameters | ConvertTo-Json -Compress) }
f @splat
