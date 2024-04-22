#Requires -Version 3
# Add a custom typename

function Get-FailedUpdateEvent {
    [OutputType('FailedUpdateEvent')]
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
