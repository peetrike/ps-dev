#Requires -Modules PSWriteHTML
[CmdletBinding()]
param ()


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


#region Create HTML Report
$ComputerName = 'Computer name: {0}' -f $env:COMPUTERNAME

New-HTML -TitleText 'Computer Information Report' -Online -FilePath $PWD\OSInfo.html {
    New-HTMLHeading -Heading h1 -HeadingText $ComputerName -Color DarkOrange
    New-HTMLSection -Invisible {
        New-HTMLPanel -Invisible {
            New-HTMLSection -Invisible {
                New-HTMLSection -HeaderText 'OS Info' {
                    New-HTMLTable -DataTable $OSinfo -Transpose -Simplify -HideFooter -AutoSize
                }
                New-HTMLSection -HeaderText 'BIOS Info' {
                    New-HTMLTable -DataTable $BiosInfo -Transpose -Simplify -HideFooter
                }
            }
            New-HTMLSection -HeaderText 'Disk Info' -HeaderBackGroundColor DarkBlue {
                New-HTMLTable -DataTable $DiscInfo -Simplify -HideFooter -AutoSize
            }
        }
        New-HTMLPanel -Width '33%' {
            New-HTMLSection -HeaderText 'Processor Info' {
                New-HTMLTable -DataTable $ProcessorInfo -Transpose -Simplify -HideFooter
            }
        }
    }
    New-HTMLSection -HeaderText 'Services Info' -HeaderTextSize 14 -CanCollapse {
        New-HTMLTable -DataTable $ServicesInfo -PagingLength 25 {
            New-HTMLTableCondition -Value 'Running' -BackgroundColor PaleGreen -ComparisonType string -Name State
            New-HTMLTableCondition -Value 'Stopped' -BackgroundColor Salmon -ComparisonType string -Name State
        }
    }
    New-HTMLText -Text ('Report Created: {0}' -f [datetime]::Now) -Color Red -FontSize 12
} -ShowHTML
#endregion
