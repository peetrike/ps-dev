$RemoteName = 'live.sysinternals.com'
$RemoteIP = (
    Resolve-DnsName -Name $RemoteName -Type A |
        Where-Object { $_.psobject.TypeNames -like '*DnsRecord_A' }
).IPAddress

# establish connection to search
$null = Invoke-WebRequest -Uri ('https://{0}' -f $RemoteName)

# capture netstat output
$netstatOutput = netstat -np tcp | Select-Object -Skip 4
$netstatOutput
