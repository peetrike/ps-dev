function Get-FailedUpdateEvent {
    <#
        .SYNOPSIS
            Retrieves failed update events from Event Log
        .DESCRIPTION
            This function retrieves failed update events from Windows Event Log
        .EXAMPLE
            Get-FailedUpdateEvent -Count 1

            This example retrieves only the latest failed update event
        .EXAMPLE
            Get-FailedUpdateEvent -StartDate 2024.04.01

            This example retrieves failed update event that occurred after
            specified date.
        .LINK
            https://learn.microsoft.com/powershell/module/microsoft.powershell.diagnostics/get-winevent
    #>

    [OutputType('FailedUpdateEvent')]
    [CmdletBinding()]
    param (
            [int]
            # Number of events to retrieve.
        $Count,
            [datetime]
            # Return events after this date.
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
        [PSCustomObject] @{
            PSTypeName   = 'FailedUpdateEvent'
            TimeCreated  = $currentEvent.TimeCreated
            Level        = [Diagnostics.Eventing.Reader.StandardEventLevel] $currentEvent.Level
            ComputerName = $currentEvent.MachineName
            ErrorCode    = $CurrentEvent.Properties[0].Value
            UpdateTitle  = $CurrentEvent.Properties[1].Value
        }
    }
}
