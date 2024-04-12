# Modified, working command

function Get-ArchitectureInfo {
    [CmdletBinding()]
    param()

        # All CPUs should be the same so only get one
    $proc = Get-CimInstance -ClassName Win32_Processor |
                Select-Object -first 1

    $os = Get-CimInstance -ClassName Win32_OperatingSystem

    Write-Debug "Finished querying $env:COMPUTERNAME"

    [PSCustomObject] @{
        PSTypeName       = 'ArchitectureInfo'
        ComputerName     = $env:COMPUTERNAME
        OSArchitecture   = $os.osarchitecture.Split('-')[0]
        ProcArchitecture = $proc.addresswidth
    }
}

# Notice that debug output is suppressed because we did not use -Debug
Get-ArchitectureInfo |
    Where-Object { $_.ProcArchitecture -ne $_.OSArchitecture } |
    Select-Object -Property ComputerName
