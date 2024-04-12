
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

Set-PSBreakpoint -Script $PSCommandPath -Line 7

# Also set a breakpoint that outputs data to a debugging file
# each time $properties is written to
Set-PSBreakpoint -Script $PSCommandPath -Variable properties -Mode Write -Action {
    $properties | Out-File debug.txt -Append
}

# This will run the command
Get-ArchitectureInfo |
Where-Object { $_.ProcArchitecture -ne $_.OSArchitecture } |
Select-Object -Property ComputerName
