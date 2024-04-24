# Modify [CmdletBinding()] to show support for ShouldProcess

function Set-ComputerState {
    <#
        .LINK
            https://learn.microsoft.com/powershell/scripting/samples/changing-computer-state
    #>
    [CmdletBinding(SupportsShouldProcess)]
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
            tsdiscon.exe
        }
        'LogOff' {
            logoff.exe
        }
        'Restart' { Restart-Computer -Force:$Force }
        'Shutdown' { Stop-Computer -Force:$Force }
        'Sleep' {
            Add-Type -AssemblyName System.Windows.Forms
            [Windows.Forms.Application]::SetSuspendState(
                [Windows.Forms.PowerState]::Suspend,
                $Force,
                $false
            )
        }
    }
}
