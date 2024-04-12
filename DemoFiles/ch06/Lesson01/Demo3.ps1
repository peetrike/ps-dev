# This time use the ISE to set a breakpoint on line 13
# and then run the script. use F11 to step through
# the script once it reaches the breakpoint.

function Get-ArchitectureInfo {
    [CmdletBinding()]
    param()

        # All CPUs should be the same so only get one
    $proc = Get-CimInstance -ClassName Win32_Processor |
                Select-Object -first 1

    $os = Get-CimInstance -ClassName Win32_OperatingSystem

    [PSCustomObject] @{
        ComputerName     = $env:COMPUTERNAME
        OSArchitecture   = $os.osarchitecture
        ProcArchitecture = $proc.addresswidth
    }
}

# expecting to see no computers listed in output
# since they are 64-bit CPUs and 64-bit operating systems
Get-ArchitectureInfo |
    Where-Object { $_.ProcArchitecture -ne $_.OSArchitecture } |
    Select-Object -Property ComputerName
