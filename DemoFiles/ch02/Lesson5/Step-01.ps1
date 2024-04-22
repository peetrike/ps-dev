# This is our starting point

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

    Get-WinEvent -FilterHashtable $EventFilter @EventParams
}
