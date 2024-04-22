function Get-CorpOSInfo {
    [CmdletBinding()]
    param ()

    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $compsys = Get-CimInstance -ClassName Win32_ComputerSystem
    $bios = Get-CimInstance -ClassName Win32_BIOS
}
