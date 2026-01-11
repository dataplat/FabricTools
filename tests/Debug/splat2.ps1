$headers = @{}
$request = @{ Headers = $headers; Uri = 'u' }
$request.Headers['User-Agent'] = 'TestUA'
$splat = @{ Headers = $request.Headers; Uri = 'u' }
function f { param($Headers, $Uri) Write-Output ($Headers | ConvertTo-Json -Compress) }
f @splat
