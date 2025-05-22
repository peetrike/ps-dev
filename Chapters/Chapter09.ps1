<#
    .SYNOPSIS
        Chapter 09 samples
    .DESCRIPTION
        This file contains sample commands from course PS-Dev for
        Chapter 09 - Writing clean code
    .LINK
        https://github.com/peetrike/ps-dev
    .LINK
        https://diigo.com/profile/peetrike/?query=%23PS-Dev+%23M9
#>

#region Safety to prevent the entire script from being run instead of a selection
throw "You're not supposed to run the entire script"
#endregion

#region Lesson 1 - Describing clean code

#region Code Clarity
#endregion

#region Coding Conventions
#endregion

#region PowerShell specific conventions

    # this is not good
Send-MailMessage -To "me@somewhere.com" -Subject "Powershell sends mail" -Priority Low -DeliveryNotificationOption Never

    # this is also bad
Send-MailMessage -To "me@somewhere.com" `
    -Subject "Powershell sends mail" `
    -Priority Low `
    -DeliveryNotificationOption Never

    # this is good
$sendMailMessageSplat = @{
    To = "me@somewhere.com"
    #Subject = "Powershell sends mail"
    Priority = 'Low'
    DeliveryNotificationOption = 'Never'
}
Send-MailMessage @sendMailMessageSplat

if (! $VerbosePreference) {}
if (-not $VerbosePreference) {}

#endregion

#endregion


#region Lesson 2 - Naming suggestions

#region Naming Variables

    # not good
for ($j = 0; $j -lt 34; $j++) {
    $s += ($t[$j] * 4) / 5
}

    # better
New-Variable -Name WORK_DAYS_PER_WEEK -Value 5 -Scope Script -Option ReadOnly
$realDaysPerIdealDay = 4

for ($j = 0; $j -lt $taskEstimate.Count; $j++) {
    $realTaskDays = $taskEstimate[$j] * $realDaysPerIdealDay
    $realTaskWeeks = $realTaskDays / $WORK_DAYS_PER_WEEK
    $sum += $realTaskWeeks
}

    # not so good variable names
${Name with`twhite space and `{punctuation`}} = 3
$総計 = 'some data'
${☁} = 12


    # global variables
$Script:ApiPath = 'https://api.example.com'
$RequestPath = $Global:$ApiPath, 'users' -join '/'

    # defining constants
New-Variable -Option Constant -Name ApiPath -Value 'https://api.example.com' -Scope Script


    # using enumerations
    #Requires -Version 5
using namespace System.Management.Automation
[ActionPreference]::Stop

    # this notation works all the time
[Management.Automation.ActionPreference]::Stop

    # prefer the last notation
$ErrorActionPreference = 1
$ErrorActionPreference = 'stop'
$ErrorActionPreference = [Management.Automation.ActionPreference]::Stop

#endregion

#region Naming Functions

#endregion

#region Naming Scripts and Modules

#endregion

#endregion


#region Lesson 3 - Code layout

#region Why code layout matters

#region preparation
$taskEstimate = 1..31 | foreach { Get-Random -Minimum 1 -Maximum 24 }
#endregion

New-Variable -Option Constant -Name WORK_DAYS_PER_WEEK -Value 5;$realDaysPerIdealDay=4
$sum=0;for ($j=0;$j -lt $taskEstimate.Count;$j++){$realTaskDays=$taskEstimate[$j]*
$realDaysPerIdealDay;$realTaskWeeks=$realTaskDays/$WORK_DAYS_PER_WEEK;$sum+=$realTaskWeeks}

#endregion

#region Code layout and formatting conventions

# https://learn.microsoft.com/powershell/scripting/community/contributing/powershell-style-guide#coding-style-rules

if ($true) {
    'running this'
}

#endregion

#region Code formatting tools

Find-Module PSScriptAnalyzer

# https://learn.microsoft.com/powershell/utility-modules/psscriptanalyzer/rules/readme

#endregion

#region Comments

    # place comments above code
if ($true) {
    # place conditional/loop comments inside the statement
    'output here'
}

$Number = 2  # use endline comments to describe the variable, when enums are not enough

    # use endline comments to describe the positional parameters,
    # when variables are not enough
New-Object -TypeName Management.Automation.Host.ChoiceDescription -ArgumentList @(
    $hash.Key   # Label
    $hash.Value # HelpMessage
)

#endregion

#endregion


#region Lesson 4 - Refactoring

#endregion
