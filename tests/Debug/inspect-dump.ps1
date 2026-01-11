$dump = Get-Content ..\..\output\invoke-restmethod-mock-dump.json -Raw | ConvertFrom-Json
$args = $dump.Args
$obj = $args[$args.Count - 1]
Write-Output "LastArgType: $($obj.GetType().FullName)"
Write-Output "Keys: $(( $obj | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name -Unique ) -join ',')"
Write-Output "UserAgent prop: $($obj.'User-Agent')"
