$url = 'https://raw.githubusercontent.com/PowerShell/PowerShell/refs/heads/master/assets/Powershell_256.png'
$tmpFileName = '{0}.png' -f (New-TemporaryFile).FullName
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $tmpFileName)
Get-Item -Path $tmpFileName
Invoke-Item -Path $tmpFileName
