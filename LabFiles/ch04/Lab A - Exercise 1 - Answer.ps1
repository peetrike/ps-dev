function Get-CorpDiskInfo {
    [CmdletBinding()]
    param ()

    $disks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3'
    foreach ($disk in $disks) {
        [PSCustomObject] @{
            ComputerName = $Env:COMPUTERNAME
            DriveLetter  = $disk.DeviceID
            FreeSpace    = $disk.FreeSpace
            Size         = $disk.Size
        }
    }
}
