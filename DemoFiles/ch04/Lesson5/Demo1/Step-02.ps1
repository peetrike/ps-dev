$RemoteName = 'live.sysinternals.com'
$RemoteIP = (
    Resolve-DnsName -Name $RemoteName -Type A |
        Where-Object { $_.psobject.TypeNames -like '*DnsRecord_A' }
).IPAddress

# establish connection to search
$null = Invoke-WebRequest -Uri ('https://{0}' -f $RemoteName)

# capture netstat output
$netstatOutput = netstat -np tcp | Select-Object -Skip 4
$netstatOutput | Select-Object -First 10

# convert netstat output to custom object
$PropertyName = 'Protocol', 'LocalAddress', 'RemoteAddress', 'State'

$netstatConverted = $netstatOutput.Trim() |
    ConvertFrom-String -Delimiter '[ ]{2,}' -PropertyNames $PropertyName
$netstatConverted | Select-Object -First 10

# search for previously established connection
$netstatConverted | Where-Object RemoteAddress -Like "${RemoteIP}:*"

Get-NetTCPConnection -RemoteAddress $RemoteIP
