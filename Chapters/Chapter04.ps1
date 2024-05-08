<#
    .SYNOPSIS
        Chapter 04 samples
    .DESCRIPTION
        This file contains sample commands from course PS-Dev for
        Chapter 04 - Writing Controller Scripts
    .LINK
        https://github.com/peetrike/ps-dev
    .LINK
        https://diigo.com/profile/peetrike/?query=%23PS-Dev+%23M4
#>

#region Safety to prevent the entire script from being run instead of a selection
throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1 - Understanding Controller Scripts

#region Understanding Tools

#endregion

#region Understanding Controller Scripts

#endregion

#region Combining Tools and Controller Scripts

Get-Help about_Requires -ShowWindow

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_module_manifests

#endregion

#region Comparing Tools and Controller Scripts

#endregion

#endregion


#region Lesson 2 - Writing Interactive Controller Scripts

#region Using Write-Progress

Get-Help Write-Progress

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_commonparameters#-progressaction

#endregion

#region Using Verbose Output

Get-Help Write-Verbose

#endregion

#region Writing to screen

Get-Help Write-Host
Get-Help Write-Host -Parameter *color

Get-Help Write-Information

#Requires -version 7.2
$PSStyle
Get-Help about_ANSI_Terminals -ShowWindow
Find-PSResource PSStyle -Repository PSGallery

#endregion

#region Using Read-Host

Get-Help Read-Host
Get-Help Read-Host -Parameter AsSecureString

#endregion

#region Creating multi-choice prompt

# https://github.com/peetrike/Examples/blob/main/src/Gui/Read-Choice.ps1
# https://learn.microsoft.com/dotnet/api/system.management.automation.host.pshostuserinterface.promptforchoice

#endregion

#region Using Get-Credential

# https://learn.microsoft.com/powershell/scripting/learn/deep-dives/add-credentials-to-powershell-functions

Get-Help Get-Credential
Get-Module BetterCredentials -ListAvailable

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

#endregion

#region Using Text-based User Interface

Find-PSResource Microsoft.PowerShell.ConsoleGuiTools -Repository PSGallery

$ModulePath = (Get-Module Microsoft.PowerShell.ConsoleGuiTools -ListAvailable)[0].ModuleBase
Get-ChildItem -path $ModulePath -Filter *.dll

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

Get-Help Add-Content
Get-Help Out-File
Get-Help Export-Csv

#endregion

#region Logging to Event Log

# PowerShell version <= 5.1
Get-Help Write-EventLog

# https://learn.microsoft.com/dotnet/api/system.diagnostics.eventlog

#endregion

#endregion


#region Lesson 4 - Writing Controller Scripts That Perform Reporting

#region Exporting data from PowerShell

#endregion

#region Converting command output to HTML

#endregion

#region Adding Basic Formatting to an HTML Page

#endregion

#region Converting command output to Excel

#endregion

#region Converting command output to PDF

#endregion

#endregion


#region Lab B - Writing Controller Scripts That Produce HTML

#endregion
