<#
    .SYNOPSIS
        Chapter 06 samples
    .DESCRIPTION
        This file contains sample commands from course PS-Dev for
        Chapter 06 - Handling Errors
    .LINK
        https://github.com/peetrike/ps-dev
    .LINK
        https://diigo.com/profile/peetrike/?query=%23PS-Dev+%23M6
#>

#region Safety to prevent the entire script from being run instead of a selection
throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1 - Understanding Error Handling

#region Comparing Different Kinds of Errors

#endregion

#region Understanding the Default Error Handling

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_preference_variables#erroractionpreference
$ErrorActionPreference

# https://github.com/peetrike/PWAddins/blob/master/src/Public/Get-EnumValue.ps1
$ErrorActionPreference.GetType() | Get-EnumValue

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_commonparameters#-erroraction

#Requires -Version 7.3
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7.4#psnativecommanduseerroractionpreference
$PSNativeCommandUseErrorActionPreference

$Error | Get-Member
$Error.GetType()
Get-Member -InputObject $Error

$Error.Clear()
Get-ChildItem /doesnotexist -ErrorAction SilentlyContinue -ErrorVariable MyError
$MyError

$MyError.GetType()
$MyError[0] -eq $Error[0]

#endregion

#region Detecting Errors

Get-Help about_Try_Catch_Finally -ShowWindow

try {
    Get-ChildItem /doesnotexist -ErrorAction Stop
    'Succeeded previous command'
} catch {
    'oops'
}

try {
    Get-ChildItem /doesnotexist -ErrorAction Stop
    'Succeeded previous command'
} catch [Management.Automation.ItemNotFoundException] {
    'a folder does not exist'
} catch {
    'oops'
}

try {
    Get-ChildItem $env:windir\temp -ErrorAction Stop
    'Succeeded previous command'
} catch [Management.Automation.ItemNotFoundException] {
    'a folder does not exist'
} catch {
    'oops'
    $_.Exception.GetType()
}

try {
    Get-ChildItem /doesnotexist -ErrorAction Stop
    'Succeeded previous command'
} catch {
    'oops'
} finally {
    'always runs'
}

try {
    Get-ChildItem . -ErrorAction Stop
    'Succeeded previous command'
} catch {
    'oops'
} finally {
    'always runs'
}

#endregion

#region Capturing Errors

#endregion

#endregion


#region Lesson 2 - Handling Errors in a Script

#region Identifying and Anticipating Operational Errors

try {
    $computers = Get-Content names.txt -ErrorAction Stop
    foreach ($computer in $computers) {
        try {
            Get-CimInstance -ClassName Win32_BIOS -ComputerName $computer -ErrorAction Stop
        } catch {
            $computer | Out-File -FilePath errorlog.txt -Append
        }
    }
} catch {
    "Unknown error $_" | Add-Content -Path master-error-log.txt
}

#endregion

#region Adding Error Handling Code to a Script

function Get-BiosInfo {
    param (
            [Parameter(Mandatory)]
            [ValidateScript({
                Test-Path -Path $_ -PathType Leaf
            }, ErrorMessage = 'File does not exist')]
            [string]
        $NameFile
    )

    foreach ($computer in Get-Content $NameFile) {
        try {
            Get-CimInstance -ClassName Win32_BIOS -ComputerName $computer -ErrorAction Stop
        } catch {
            [PSCustomObject]@{
                Date         = [datetime]::Now
                ComputerName = $computer
                Error        = $_.Exception.Message
            } | Export-Csv errorlog.csv -Encoding utf8 -Append
        }
    }
}
Get-BiosInfo -NameFile somefile.txt

#endregion

#region Logging Errors to a Text File

#endregion

#endregion


#region Lesson 3 - Raising Errors in a Script

#region Understanding Error stream

$Error[0].GetType() | Get-TypeUrl -Invoke
$Error[0] | Get-Member

    #Requires -Version 7
Get-Error

#endregion

#region Raising terminating errors

Get-Help about_Throw -ShowWindow

function MyError {
    [CmdletBinding()]
    param ()

    $myError = New-Object -TypeName Management.Automation.ErrorRecord -ArgumentList @(
        [Management.Automation.RuntimeException] 'oops'
        'CustomError'
        [System.Management.Automation.ErrorCategory]::ObjectNotFound
        Get-Process -Id $PID
    )
    $PSCmdlet.ThrowTerminatingError($myError)
}
try {
    MyError
    'this does not appear'
} catch {
    Get-Error
}

#endregion

#region Raising non-terminating errors

Get-Help Write-Error
function MyError {
    [CmdletBinding()]
    param ()

    $myError = New-Object -TypeName Management.Automation.ErrorRecord -ArgumentList @(
        [Management.Automation.RuntimeException] 'oops'
        'CustomError'
        [System.Management.Automation.ErrorCategory]::ObjectNotFound
        Get-Process -Id $PID
    )
    $PSCmdlet.WriteError($myError)
}
MyError; 'this still appears'
Get-Error

#endregion

#region Using Warning stream

function Invoke-Useful {
    [CmdletBinding()]
    param ()

    Write-Warning -Message 'Something unusual happened'
}

Invoke-Useful -WarningVariable +warning -WarningAction SilentlyContinue
$warning | Format-List * -Force
$warning.InvocationInfo

#endregion

#endregion


#region Lab - Handling Errors in a Script

#endregion
