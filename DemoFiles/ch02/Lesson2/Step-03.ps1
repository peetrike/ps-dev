# Create a parameter block, define a parameter, and use the parameter
# in place of the hardcoded value

param (
        [int]
    $Count,
        [datetime]
    $StartDate #= '2024.04.16'
)

$EventFilter = @{
    ProviderName = 'Microsoft-Windows-WindowsUpdateClient'
    ID           = 20
}
if ($StartDate) {
    $EventFilter.StartTime = $StartDate
}

$EventParams = @{}
if ($Count) {
    $EventParams.MaxEvents = $Count
}

Get-WinEvent -FilterHashtable $EventFilter @EventParams
