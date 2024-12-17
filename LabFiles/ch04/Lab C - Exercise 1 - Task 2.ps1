$EventFilter = @{
    ProviderName = 'Microsoft-Windows-WindowsUpdateClient'
    ID           = 19, 20
}

Get-WinEvent -FilterHashtable $EventFilter -MaxEvents 1 -Verbose

$eventList = Get-WinEvent -FilterHashtable $EventFilter -MaxEvents 5
$eventList


$eventList | Get-Member
$eventList | Get-Member -MemberType Methods

# https://learn.microsoft.com/dotnet/api/system.diagnostics.eventing.reader.eventlogrecord
