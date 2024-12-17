[CmdletBinding()]
param ()

$EventFilter = @{
    ProviderName = 'Microsoft-Windows-WindowsUpdateClient'
    ID           = 19, 20
}

Get-WinEvent -FilterHashtable $EventFilter | ForEach-Object {
    $EventXml = [xml] $_.ToXml()

}
