$h = @{}
$h['User-Agent'] = $null
Write-Output ($h | ConvertTo-Json -Compress)
Write-Output ($h.ContainsKey('User-Agent'))
