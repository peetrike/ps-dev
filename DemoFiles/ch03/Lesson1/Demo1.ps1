# Remove any calls to functions that were added for testing
# You do not want those to run every time the module loads


<#
    .LINK
        https://learn.microsoft.com/powershell/scripting/samples/changing-computer-state
#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param (
        [Parameter(Mandatory)]
        [ValidateSet('Lock', 'Logoff', 'Restart', 'Shutdown', 'Sleep')]
        [string]
    $State,

        [switch]
    $Force
)

function Set-ComputerState {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
            [Parameter(Mandatory)]
            [ValidateSet('Lock', 'Logoff', 'Restart', 'Shutdown', 'Sleep')]
            [string]
        $State,

            [switch]
        $Force
    )

    switch ($State) {
        'Lock' {
            if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, $State)) {
                tsdiscon.exe
            }
        }
        'LogOff' {
            if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, $State)) {
                logoff.exe
            }
        }
        'Restart' { Restart-Computer -Force:$Force }
        'Shutdown' { Stop-Computer -Force:$Force }
        'Sleep' {
            if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, $State)) {
                Add-Type -AssemblyName System.Windows.Forms
                [Windows.Forms.Application]::SetSuspendState(
                    [Windows.Forms.PowerState]::Suspend,
                    $Force,
                    $false
                )
            }
        }
    }
}

Set-ComputerState @PSBoundParameters
