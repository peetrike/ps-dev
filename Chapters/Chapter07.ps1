<#
    .SYNOPSIS
        Chapter 07 samples
    .DESCRIPTION
        This file contains sample commands from course PS-Dev for
        Chapter 07 - Analyzing and Debugging Scripts
    .LINK
        https://github.com/peetrike/ps-dev
    .LINK
        https://diigo.com/profile/peetrike/?query=%23PS-Dev+%23M7
#>

#region Safety to prevent the entire script from being run instead of a selection
throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1 - Debugging in PowerShell

#region Understanding Debugging

Get-Process -Id $PID | Select-Object -Property nmae, id

Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType='Fixed'"

code -r ..\DemoFiles\ch06\Lesson1\Demo1\Step-01.ps1

#endregion

#region Displaying Debug Output

Get-Help Write-Debug

$DebugPreference

code -r ..\DemoFiles\ch06\Test-Debug.ps1
..\DemoFiles\ch06\Test-Debug.ps1

function Test-Debug {
    [CmdletBinding()]
    param ()

    $PSVersionTable.PSVersion
    if ($PSBoundParameters.ContainsKey('Debug')) {
        $DebugPreference = 'continue'
    }
    Write-Debug -Message ('The preference variable is now {0}' -f $DebugPreference)
}


#endregion

#region Setting Breakpoints

Get-Command -Noun PSBreakpoint

Get-Help Set-PSBreakpoint

#endregion

#region Debugging in the IDE

# https://code.visualstudio.com/docs/editor/debugging
# https://learn.microsoft.com/powershell/scripting/dev-cross-plat/vscode/using-vscode#debugging-with-visual-studio-code

#endregion

#endregion


#region Lesson 2 - Analyzing and Debugging an Existing Script

#region Reviewing an Existing Script

#endregion

#region Adding Debug Code and Breakpoints to a Script

#endregion

#region Testing a Script and Resolving Errors

#endregion

#endregion


#region Lesson 3 - Writing unit tests using Pester

#region Understanding Test Driven Development

#endregion

#region What is Pester

Find-PSResource Pester -Repository PSGallery

# https://pester.dev

#endregion

#region Writing tests

Get-Help New-Fixture

#endregion

#region Running tests

Get-Help Invoke-Pester

Get-Help New-PesterConfiguration

#endregion

#endregion


#region Lab - Analyzing and Debugging an Existing Script

#endregion
