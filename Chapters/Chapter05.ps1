<#
    .SYNOPSIS
        Chapter 05 samples
    .DESCRIPTION
        This file contains sample commands from course PS-Dev for
        Chapter 05 - Writing Controller Scripts
    .LINK
        https://github.com/peetrike/ps-dev
    .LINK
        https://diigo.com/profile/peetrike/?query=%23PS-Dev+%23M5
#>

#region Safety to prevent the entire script from being run instead of a selection
throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1 - Understanding Controller Scripts

#region Understanding Tools

https://github.com/PoshCode/PowerShellPracticeAndStyle/blob/master/Best-Practices/Building-Reusable-Tools.md#tool-01-decide-whether-youre-coding-a-tool-or-a-controller-script

#endregion

#region Understanding Controller Scripts

https://github.com/PoshCode/PowerShellPracticeAndStyle/blob/master/Best-Practices/Building-Reusable-Tools.md#tool-07-controllers-should-typically-output-formatted-data

#endregion

#region Combining Tools and Controller Scripts

# https://github.com/PoshCode/PowerShellPracticeAndStyle/blob/master/Best-Practices/Language-Interop-and-.NET.md#ver-02-document-the-version-of-powershell-the-script-was-written-for

Get-Help about_Requires -ShowWindow

code -r .\requires.ps1

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_module_manifests

#endregion

#region Comparing Tools and Controller Scripts

#endregion

#endregion


#region Lesson 2 - Writing Interactive Controller Scripts

#region Using Write-Progress

Get-Help Write-Progress
Get-Help Write-Progress -Parameter SecondsRemaining
Get-Help Write-Progress -Parameter PercentComplete

& {
    Write-Progress -Activity 'teeme' -SecondsRemaining 3 -id 1
    Start-Sleep -Seconds 3
}

foreach ( $i in 1..10 ) {
    Write-Progress -Id 0 "Step $i" -PercentComplete ($i * 10)
    foreach ( $j in 1..10 ) {
        Write-Progress -Id 1 -ParentId 0 "Substep $j" -PercentComplete ($j * 10)
        foreach ( $k in 1..10 ) {
            Write-Progress -Id 2 -ParentId 1 "Iteration $k" -PercentComplete ($k * 10)
            Start-Sleep -Milliseconds 100
        }
    }
}

# Use the OSC 9 progress ANSI codes
#Requires -Version 7.2
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_ansi_terminals#psstyle
$PSStyle.Progress.UseOSCIndicator

function Show-Progress {
    param (
            [Parameter(Mandatory)]
            [ValidateRange(0, 100)]
            [int]
        $Percent,
            [ValidateSet('Normal', 'Warning', 'Error')]
            [string]
        $Level = 'Normal'
    )

    $ProgressState = switch ($Percent) {
        0 { 3 }
        100 { 0 }
        default {
            switch ($Level) { 'Normal' { 1 } 'Warning' { 4 } 'Error' { 2 } }
        }
    }

    $string = "{0}]9;4;{1}{2}`a" -f @(
        [char] 0x1b
        $ProgressState
        if (0, 3 -notcontains $ProgressState) { ';' + $Percent } else { '' }
    )
    write-host $string
}

Show-Progress -Percent 0
Show-Progress -Percent 30 -Level Warning
Show-Progress -Percent 50
Show-Progress -Percent 67 -Level Error
Show-Progress -Percent 100

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_preference_variables#progresspreference
$ProgressPreference

#Requires -Version 7.4
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_commonparameters#-progressaction

$url = 'https://raw.githubusercontent.com/PowerShell/PowerShell/refs/heads/master/assets/Chibi_Avatar.svg'
$localFile = '{0}.svg' -f (New-TemporaryFile).FullName
Invoke-WebRequest -Uri $url -OutFile $localFile -ProgressAction SilentlyContinue

#endregion

#region Using Verbose Output

Get-Help Write-Verbose

Write-Verbose -Message 'Tere' -Verbose

$Host.PrivateData | Select-Object verbose*
#Requires -Version 7.2
$PSStyle.Formatting

#endregion

#region Writing to screen

Get-Help Write-Host
Get-Help Write-Host -Parameter *color

Get-Help Write-Information

#Requires -Version 7.2
$PSStyle
Get-Help about_ANSI_Terminals -ShowWindow
Find-PSResource PSStyle -Repository PSGallery

#endregion

#region Using Read-Host

Get-Help Read-Host
Get-Help Read-Host -Parameter AsSecureString

$answer = Read-Host 'Enter your name'
$Password = Read-Host 'Enter the password' -AsSecureString

#endregion

#region Creating multi-choice prompt

# https://github.com/peetrike/Examples/blob/main/src/Gui/Read-Choice.ps1
# https://learn.microsoft.com/dotnet/api/system.management.automation.host.pshostuserinterface.promptforchoice

$choice = @('&yes', '&no')
$answer = $Host.UI.PromptForChoice('Make a choice', 'Should we continue?', $choice, 1)
$choice[$answer]

#endregion

#region Using Get-Credential

# https://learn.microsoft.com/powershell/scripting/learn/deep-dives/add-credentials-to-powershell-functions

Get-Help Get-Credential
Find-Module BetterCredentials -Repository PSGallery

function Use-Credential {
    param(
            [ValidateNotNull()]
            [Management.Automation.PSCredential]
            [Management.Automation.Credential()]
        $Credential = [Management.Automation.PSCredential]::Empty
    )

    $Credential
}

Use-Credential -Credential $env:COMPUTERNAME\mina

#endregion

#region Using Out-GridView

Get-Help Out-GridView
Get-Help Out-GridView -Parameter OutputMode
Get-Help Out-GridView -Parameter PassThru

Get-ChildItem Cert:\CurrentUser\My |
    Select-Object FriendlyName, NotAfter, Subject, Thumbprint |
    Out-GridView -OutputMode Single

#endregion

#region Using Text-based User Interface

Find-PSResource Microsoft.PowerShell.ConsoleGuiTools -Repository PSGallery
Find-PSResource Terminal.Gui -Repository Nuget

$ModulePath = (Get-Module Microsoft.PowerShell.ConsoleGuiTools -ListAvailable)[0].ModuleBase
Get-ChildItem -path $ModulePath -Filter *.dll

code -r .\Show-Tui2.ps1
.\Show-Tui2.ps1

# https://gui-cs.github.io/Terminal.Gui/docs/overview.html

#endregion

#region Using GUI elements

# https://github.com/peetrike/Examples/blob/main/src/Gui/
# https://learn.microsoft.com/powershell/scripting/samples/creating-a-custom-input-box

Find-PSResource BurntToast -Repository PSGallery
Find-PSResource AnyBox -Repository PSGallery

# https://www.foxdeploy.com/series/LearningGUIs

# https://ironmansoftware.com/powershell-universal-dashboard
# https://demo.powershelluniversal.com/

#endregion

#endregion


#region Lab A - Writing Controller Scripts That Display a User Interface

#endregion


#region Lesson 3 - Use Logging in Controller Scripts

#region Kinds of information to log

#endregion

#region Redirecting Message Streams

Get-Help about_Redirection -ShowWindow
Get-Help about_CommonParameters -ShowWindow
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_commonparameters

#endregion

#region Logging to a Text File

# https://github.com/peetrike/scripts/blob/master/src/Write-Log.ps1

Get-Help Add-Content
Get-Help Out-File
Get-Help Export-Csv

Find-Module -Command Write-Log -Repository PSGallery

# https://github.com/peetrike/scripts/blob/master/src/Write-Log.ps1

Find-Module PSFramework -Repository PSGallery

# https://psframework.org/documentation/documents/psframework/logging.html
Get-Help Write-PSFMessage -ShowWindow

#region Set up logging to file
$paramSetPSFLoggingProvider = @{
    Name         = 'logfile'
    InstanceName = 'Course PS-Dev'
    FilePath     = Join-Path $pwd 'PsfMessage.csv'
    Enabled      = $true
}
Set-PSFLoggingProvider @paramSetPSFLoggingProvider
#endregion

Write-PSFMessage 'A message to log'
Write-PSFMessage 'A message to screen' -Level Host
Get-PSFMessage

#endregion

#region Logging to Event Log

    # PowerShell version < 6
Get-Help Write-EventLog

# https://learn.microsoft.com/dotnet/api/system.diagnostics.eventlog

# https://peterwawa.wordpress.com/2015/02/26/powershell-ja-sndmuste-logid/

#region Set up logging to Event Log
$paramSetPSFLoggingProvider = @{
    Name         = 'eventlog'
    InstanceName = 'PS-Dev'
    Enabled      = $true
}
Set-PSFLoggingProvider @paramSetPSFLoggingProvider
#endregion

Write-PSFMessage 'A message to Event Log'
Write-PSFMessage 'A message to screen and Event Log' -Level Host
Get-PSFMessage

Get-WinEvent -ProviderName 'Application' -MaxEvents 5
(Get-WinEvent -ProviderName 'Application' -MaxEvents 1).Properties

#endregion

#endregion


#region Lesson 4 - Writing Controller Scripts That Perform Reporting

#region Exporting data from PowerShell

Get-Command ConvertTo-Json
Get-Command ConvertTo-Xml
Get-Command Export-Csv

Get-Command Set-Content
Get-Command Add-Content

#endregion

#region Converting command output to HTML

Get-Help ConvertTo-Html

Get-Process p* | ConvertTo-HTML | Out-File Report.html
Invoke-Item Report.html

#endregion

#region Adding Basic Formatting to an HTML Page

Get-Help ConvertTo-Html -Parameter CssUri
Get-Help ConvertTo-Html -Parameter Head

Find-PSResource PSWriteHtml -Repository PSGallery

# don't do this:
# https://gist.github.com/smasterson/9136468

#endregion

#region Converting command output to Excel

Find-PSResource ImportExcel -Repository PSGallery

#endregion

#region Converting command output to PDF

Find-PSResource PSWritePDF -Repository PSGallery

#endregion

#endregion


#region Lab B - Writing Controller Scripts That Produce HTML

#endregion
