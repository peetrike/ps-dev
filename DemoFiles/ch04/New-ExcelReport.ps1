#Requires -Modules ImportExcel
[CmdletBinding()]
param (
    $ReportFile = 'OSInfo.xlsx'
)

if (Test-Path -Path $ReportFile -PathType Leaf) {
    Remove-Item -Path $ReportFile -Force
}

#region Collect and convert information
$OSinfo = Get-CimInstance -ClassName Win32_OperatingSystem |
    Select-Object 'Version', 'Caption', 'BuildNumber', 'Manufacturer'

$ProcessorInfo = Get-CimInstance -ClassName Win32_Processor |
    Select-Object 'DeviceID', 'Name', 'Caption', 'MaxClockSpeed', 'SocketDesignation', 'Manufacturer'

$BiosInfo = Get-CimInstance -ClassName Win32_BIOS |
    Select-Object 'SMBIOSBIOSVersion', 'Manufacturer', 'Name', 'SerialNumber'

$DiscInfo = Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3' |
    Select-Object 'DeviceID', 'DriveType', 'ProviderName', 'VolumeName', 'Size', 'FreeSpace'

$ServicesInfo = Get-CimInstance -ClassName Win32_Service |
    Select-Object -Property State, Name, DisplayName, StartMode, Accept*
#endregion

$OSProps = @{
    Path         = $ReportFile
    AutoSize     = $true
    WorksheetName = 'OS'
}
$sheetName = 'Services'
$ServiceProps = @{
    Path          = $ReportFile
    AutoSize      = $true
    AutoFilter    = $true
    WorksheetName = $sheetName
    TableName     = $sheetName
    TableStyle    = 'Medium5'
    FreezeTopRow  = $true
}
#region Generate report
$OSinfo | Export-Excel @OSProps -StartColumn 1 -Title 'OS Info'
$ProcessorInfo | Export-Excel @OSProps -StartRow 5 -Title 'Processor Info'
$BiosInfo | Export-Excel @OSProps -StartRow 9 -Title 'BIOS Info'
$DiscInfo | Export-Excel @OSProps -StartRow 13 -Title 'Disk Info'

$document = $ServicesInfo | Export-Excel @ServiceProps -Title 'Services Info' -PassThru
$ConditionProps = @{
    Worksheet = $document.Workbook.Worksheets[$sheetName]
    Range     = 'A:A'
    RuleType  = 'Equal'
}
Add-ConditionalFormatting @ConditionProps -ConditionValue 'Running' -BackgroundColor LightGreen
Add-ConditionalFormatting @ConditionProps -ConditionValue 'Stopped' -BackgroundColor Red
Close-ExcelPackage -ExcelPackage $document -Show
#endregion

#Invoke-Item -Path $ReportFile
