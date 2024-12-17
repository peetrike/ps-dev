$EventFilter = @{
    ProviderName = 'Microsoft-Windows-WindowsUpdateClient'
    ID           = 19, 20
}

Get-WinEvent -FilterHashtable $EventFilter -MaxEvents 1 -Verbose

$eventList = Get-WinEvent -FilterHashtable $EventFilter -MaxEvents 5
$eventList
