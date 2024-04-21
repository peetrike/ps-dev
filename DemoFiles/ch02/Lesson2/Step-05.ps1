# Add a call to the function at the end of the script
# so that you can run the script and test the function

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

Get-FailedUpdateEvent -Count 2

# Press F5 to run this script
