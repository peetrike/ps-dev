# Adding debug code

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
        OSArchitecture   = $os.OSArchitecture
        ProcArchitecture = $proc.AddressWidth
    }
}

# expecting to see all computers listed in output
# since they are 64-bit CPUs and 64-bit operating systems
Get-ArchitectureInfo -Debug |
    Where-Object { $_.ProcArchitecture -ne $_.OSArchitecture } |
    Select-Object -Property ComputerName
