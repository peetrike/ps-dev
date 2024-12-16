$RemoteName = 'live.sysinternals.com'
$RemoteIP = (
    Resolve-DnsName -Name $RemoteName -Type A |
        Where-Object { $_.psobject.TypeNames -like '*DnsRecord_A' }
).IPAddress

# establish connection to search
$null = Invoke-WebRequest -Uri ('https://{0}' -f $RemoteName)

# capture netstat output
$netstatOutput = netstat -nop tcp
$netstatOutput | Select-Object -First 10

$template = @'

Active Connections

  Proto  Local Address          Foreign Address        State     PID
  {Protocol*:TCP}    {[ipaddress]LocalAddress:127.0.0.1}:{[int]LocalPort:53119}        {[ipaddress]RemoteAddress:201.108.52.65}:{[int]RemotePort:443}     {State:ESTABLISHED}     {[int]OwningProcess:36804}
  {Protocol*:TCP}    {[ipaddress]LocalAddress:172.16.0.40}:{[int]LocalPort:64400}      {[ipaddress]RemoteAddress:20.250.34.176}:{[int]RemotePort:445}     {State:TIME_WAIT}       {[int]OwningProcess:0}
  {Protocol*:TCP}    {[ipaddress]LocalAddress:192.168.1.240}:{[int]LocalPort:44030}    {[ipaddress]RemoteAddress:20.250.34.176}:{[int]RemotePort:9842}    {State:LAST_ACK}        {[int]OwningProcess:2018}
'@

$netstatConverted = $netstatOutput | ConvertFrom-String -TemplateContent $template
$netstatConverted | Select-Object -First 10

$netstatConverted | Where-Object RemoteAddress -Like $RemoteIP

# EXTRA: using saved template from file
$templateFile = 'template.txt'
$template | Set-Content -Path $templateFile
$null = $netstatOutput | ConvertFrom-String -Templatefile $templateFile -UpdateTemplate

Measure-Command {
    $netstatOutput | ConvertFrom-String -Templatefile $templateFile
}
Measure-Command {
    $netstatOutput | ConvertFrom-String -TemplateContent $template
}
