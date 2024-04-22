function Get-CorpOSInfo {
    [OutputType('OSInfo')]
    [CmdletBinding()]
    param ()

    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $compsys = Get-CimInstance -ClassName Win32_ComputerSystem
    $bios = Get-CimInstance -ClassName Win32_BIOS

    [PSCustomObject] @{
        PSTypeName   = 'OSInfo'
        ComputerName = [Net.Dns]::GetHostEntry('').HostName
        OSVersion    = $os.Caption
        SPVersion    = $os.ServicePackMajorVersion
        BIOSSerial   = $bios.SerialNumber
        Manufacturer = $compsys.Manufacturer
        Model        = $compsys.Model
    }
}
