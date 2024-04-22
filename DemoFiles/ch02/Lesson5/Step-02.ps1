# Save command output in a variable

function Get-FailedUpdateEvent {
    [CmdletBinding()]
    param (
            [int]
        $Count,
            [datetime]
        $StartDate
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

    foreach ($CurrentEvent in Get-WinEvent -FilterHashtable $EventFilter @EventParams) {
        $CurrentEvent
    }
}
