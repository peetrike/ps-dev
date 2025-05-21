<#
    .LINK
        https://adamtheautomator.com/html-report/
#>
function get-header {
    param ($Title)
    "<h2>$Title</h2>"
}

function Get-HtmlContent {
    param (
            [string]
        $Title,
            [string]
        $ClassName,
            [string]
        $Filter,
            [string[]]
        $Property
    )

    $header = get-header $title

    $getCimInstanceSplat = @{
        ClassName = $ClassName
    }
    if ($Filter) { $getCimInstanceSplat.Filter = $Filter }

    Get-CimInstance @getCimInstanceSplat |
        ConvertTo-Html -Fragment -As List -Property $Property -PreContent $header
}

#region Collect and convert information
$HtmlSplat = @{
    Property = 'Version', 'Caption', 'BuildNumber', 'Manufacturer'
    Title    = 'Operating System Information'
}
$OSinfo = Get-HtmlContent -ClassName Win32_OperatingSystem @HtmlSplat

$HtmlSplat = @{
    Property = 'DeviceID', 'Name', 'Caption', 'MaxClockSpeed', 'SocketDesignation', 'Manufacturer'
    Title    = 'Processor Information'
}
$ProcessInfo = Get-HtmlContent -ClassName Win32_Processor @HtmlSplat

$HtmlSplat = @{
    Property = 'SMBIOSBIOSVersion', 'Manufacturer', 'Name', 'SerialNumber'
    Title    = 'BIOS Information'
}
$BiosInfo = Get-HtmlContent -ClassName Win32_BIOS @HtmlSplat

$HtmlSplat = @{
    Property = 'DeviceID', 'DriveType', 'ProviderName', 'VolumeName', 'Size', 'FreeSpace'
    Title    = 'Disk Information'
}
$DiscInfo = Get-HtmlContent -ClassName Win32_LogicalDisk -Filter 'DriveType=3' @HtmlSplat

$header = get-header -title 'Services Information'
$ServicesInfo = Get-CimInstance -ClassName Win32_Service |
    Select-Object -First 10 |
    ConvertTo-Html -Fragment -Property Name, DisplayName, State -PreContent $header
$ServicesInfo = $ServicesInfo -replace '<td>Running</td>', '<td class="RunningStatus">Running</td>'
$ServicesInfo = $ServicesInfo -replace '<td>Stopped</td>', '<td class="StopStatus">Stopped</td>'
#endregion

#region Generate final report
$BodyFragment = @(
    "<h1>Computer name: $env:COMPUTERNAME</h1>"
    $OSinfo
    $ProcessInfo
    $BiosInfo
    $DiscInfo
    $ServicesInfo
    "<p id='CreationDate'>Report Created: {0}</p>" -f [datetime]::Now
)

$FileName = $MyInvocation.MyCommand.Name -replace '.ps1', '.html'
$CssName = $FileName -replace '.html', '.css'
$cssPath = Join-Path -Path $PSScriptRoot -ChildPath $CssName
ConvertTo-HTML -Body $BodyFragment -Title 'Computer Information Report' -CssUri $cssPath |
    Out-File -FilePath $FileName -Encoding utf8
#endregion

Invoke-Item -Path $FileName
