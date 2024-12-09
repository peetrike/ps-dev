function Get-CorpDiskInfo {
    [CmdletBinding()]
    param ()

    $diskList = Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3'
}
