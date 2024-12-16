$RemoteName = 'live.sysinternals.com'
$RemoteIP = (
    Resolve-DnsName -Name $RemoteName -Type A |
        Where-Object { $_.psobject.TypeNames -like '*DnsRecord_A' }
).IPAddress

# establish connection to search
$null = Invoke-WebRequest -Uri ('https://{0}' -f $RemoteName)

# capture netstat output
$netstatOutput = netstat -np tcp
$netstatOutput | Select-Object -First 10

$template = @'

Active Connections

  Proto  Local Address          Foreign Address        State
  {Protocol*:TCP}    {LocalAddress:127.0.0.1}:{LocalPort:53119}        {RemoteAddress:201.108.52.65}:{RemotePort:443}     {State:ESTABLISHED}
  {Protocol*:TCP}    {LocalAddress:172.16.0.40}:{LocalPort:64400}      {RemoteAddress:20.250.34.176}:{RemotePort:445}     {State:TIME_WAIT}
  {Protocol*:TCP}    {LocalAddress:192.168.1.240}:{LocalPort:44030}    {RemoteAddress:20.250.34.176}:{RemotePort:9842}    {State:LAST_ACK}
'@

$netstatConverted = $netstatOutput | ConvertFrom-String -TemplateContent $template
$netstatConverted | Select-Object -First 10

$netstatConverted | Where-Object RemoteAddress -Like $RemoteIP
