$RemoteName = 'live.sysinternals.com'
$RemoteIP = (
    Resolve-DnsName -Name $RemoteName -Type A |
        Where-Object { $_.psobject.TypeNames -like '*DnsRecord_A' }
).IPAddress

# establish connection to search
$null = Invoke-WebRequest -Uri ('https://{0}' -f $RemoteName)

# capture netstat output
$netstatOutput = netstat -np tcp
$netstatOutput

$template = @'

Active Connections

  Proto  Local Address          Foreign Address        State
  {Protocol*:TCP}    {LocalAddress:127.0.0.1:53119}        {RemoteAddress:201.108.52.65:443}     {State:ESTABLISHED}
  {Protocol*:TCP}    {LocalAddress:172.16.0.40:64400}      {RemoteAddress:20.250.34.176:445}     {State:TIME_WAIT}
  {Protocol*:TCP}    {LocalAddress:192.168.1.240:44030}    {RemoteAddress:20.250.34.176:9842}    {State:LAST_ACK}
'@

$netstatConverted = $netstatOutput | ConvertFrom-String -TemplateContent $template
$netstatConverted

$netstatConverted | Where-Object -Property 'ForeignAddress' -Like 'LON-DC1:*'
