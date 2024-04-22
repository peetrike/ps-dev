function Get-CorpOSInfo {
    [CmdletBinding()]
    param ()

    $os = Get-CimInstance -ClassName Win32_OperatingSystem
}
