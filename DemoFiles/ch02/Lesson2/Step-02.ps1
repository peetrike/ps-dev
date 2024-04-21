# Identify values that need to be parameterized.
$Count = 2
# $StartDate = Get-Date -Date 2024.04.16

$EventFilter = @{
    ProviderName = 'Microsoft-Windows-WindowsUpdateClient'
    ID           = 20
}
if ($StartDate) {
    $EventFilter.StartTime = $StartDate
}

Get-WinEvent -FilterHashtable $EventFilter -MaxEvents $Count
