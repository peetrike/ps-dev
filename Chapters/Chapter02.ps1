<#
    .SYNOPSIS
        Chapter 02 samples
    .DESCRIPTION
        This file contains sample commands from course PS-Dev for
        Chapter 02 - Creating Functions
    .LINK
        https://github.com/peetrike/ps-dev
    .LINK
        https://diigo.com/profile/peetrike/?query=%23PS-Dev+%23M2
#>

#region Safety to prevent the entire script from being run instead of a selection
throw "You're not supposed to run the entire script"
#endregion

#region Lesson 1 - What are functions

#region What are functions?

Get-Help about_Functions -ShowWindow

Get-Command pause
(Get-Command pause).Definition

function greeting {
    "Hello $env:USERNAME"
}
greeting

#endregion

#region Understanding scripts and functions

Get-Help about_Scopes -ShowWindow

#endregion

#region Using Variable Scopes

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_scopes#example-2-view-a-variable-value-in-different-scopes

code -r ..\DemoFiles\ch02\Lesson1\scope.ps1

#endregion

#region Using Dot Sourcing

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator-
# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-03#355-dot-source-notation

#endregion

#endregion


#region Lesson 2 - Converting a Command into an Advanced Function

#region Understanding Kinds of Functions

function get-pipe {
    process {
        'The value is {0}' -f $_
    }
}
1, 2, 3 | get-pipe

#endregion

#region Creating an Advanced Function
function get-logicalDisk {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $Drive
    )

    Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$Drive'"
}

get-logicalDisk -Drive 'C:'
get-logicalDisk

#endregion

#region Identifying Command Values That Can Be Parameterized

#endregion

#endregion


#region Lab A - Converting a Command into an Advanced Function

#endregion


#region Lesson 3 - Defining Parameter Attributes and Input Validation

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_automatic_variables#psboundparameters

#region Understanding the Parameter Attributes

#endregion

#region Defining a Parameter as Mandatory

function arvuti {
    [CmdletBinding()]
    param (
            [Parameter(Mandatory=$true)]
            [string]
        $ComputerName = $env:COMPUTERNAME
    )

    $ComputerName
}

#endregion

#region Defining a Parameter Help Message
function arvuti {
    [CmdletBinding()]
    param (
            [Parameter(
                Mandatory = $true,
                HelpMessage = '
                    Computer name to connect to
                    and something else
                    '
            )]
            [string]
        $ComputerName
    )

    $ComputerName
}


#endregion

#region Defining Parameter Name Aliases
function arvuti {
    [CmdletBinding()]
    [Alias('Computer')]
    param (
            [Parameter(
                Mandatory = $true,
                HelpMessage = '
                    Computer name to connect to
                    and something else
                    '
            )]
            [Alias(
                'CN',
                'Hostname',
                'Target',
                'fqdn',
                'server'
            )]
            [string]
        $ComputerName
    )

    $ComputerName
}

#endregion

#region Understanding Parameter Input Validation

# https://github.com/peetrike/Examples/tree/main/CommandLine

function arvuti {
    [CmdletBinding()]
    [Alias('Computer')]
    param (
            [Parameter(
                Mandatory = $true,
                HelpMessage = '
                    Computer name to connect to
                    and something else
                    '
            )]
            [Alias(
                'CN',
                'Hostname',
                'Target',
                'fqdn',
                'server'
            )]
            [ValidatePattern('^SRV-')]
            [string]
        $ComputerName
    )

    $ComputerName
}

function arvuti {
    [CmdletBinding()]
    [Alias('Computer')]
    param (
            [Parameter(
                Mandatory = $true,
                HelpMessage = '
                    Computer name to connect to
                    and something else
                    '
            )]
            [Alias(
                'CN',
                'Hostname',
                'Target',
                'fqdn',
                'server'
            )]
            [ValidateScript({
                if ($_ -match '^SRV-') {
                    $true
                } else {
                    Throw 'The ComputerName must start with Srv-'
                }
            })]
            [string]
        $ComputerName
    )

    $ComputerName
}

#Requires -Version 6
function arvuti {
    [CmdletBinding()]
    [Alias('Computer')]
    param (
            [Parameter(
                Mandatory = $true,
                HelpMessage = '
                    Computer name to connect to
                    and something else
                    '
            )]
            [Alias(
                'CN',
                'Hostname',
                'Target',
                'fqdn',
                'server'
            )]
            [ValidatePattern('^SRV-', ErrorMessage = 'Must start with SRV-')]
            [string]
        $ComputerName
    )

    $ComputerName
}

function vastus {
    [CmdletBinding()]
    param (
            [ValidateSet('Jah', 'Ei')]
            [string]
        $vastus
    )

    $vastus
}

#endregion

#endregion


#region Lab B - Defining Parameter Attributes and Input Validation

#endregion


#region Lesson 4 - Writing Functions That Accept Pipeline Input

#region Understanding Functions That Accept Pipeline Input

#endregion

#region Understanding Pipeline Parameter Binding

# https://github.com/peetrike/Examples/blob/main/CommandLine/11%20Pipeline%20Input.ps1

function nimed {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $Nimi
    )

    $Nimi
}

# https://github.com/peetrike/Examples/blob/main/CommandLine/12%20Pipeline%20Objects.ps1

#endregion

#region Comparing Pipeline Execution and Parameter Execution

function nimed {
    [CmdletBinding()]
    param (
            [Parameter(ValueFromPipeline)]
            [string]
        $Nimi
    )

    end {
        Write-Warning ('lõpetasime, Nimi on: {0}' -f $Nimi)
    }
    begin {
        Write-Warning ('alustame, Nimi on: {0}' -f $Nimi)
    }
    process {
        $Nimi
    }
}

'first', 'second', 'third' | nimed

function nimed {
    [CmdletBinding()]
    param (
            [Parameter(ValueFromPipeline)]
            [string[]]
        $Nimi
    )

    end {
        Write-Warning ('lõpetasime, Nimi on: {0}' -f $Nimi -join ',')
    }
    begin {
        Write-Warning ('alustame, Nimi on: {0}' -f $Nimi)
    }
    process {
        foreach ($n in $nimi) {
            $n
        }
    }
}

nimed -Nimi 'first', 'second', 'third'
'first', 'second', 'third' | nimed

#endregion

#endregion


#region Lab C - Writing Functions That Accept Pipeline Input

#endregion


#region Lesson 5 - Producing Complex Function Output

#region Understanding the Advantages of Object Output

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_objects
Get-Help about_objects -ShowWindow

#endregion

#region Creating the Properties for a Custom Object

#endregion

#region Creating and Producing a Custom Object

#endregion

#region Adding Custom TypeName to Object

#endregion

#endregion


#region Lab D - Producing Complex Function Output

#endregion


#region Lesson 6 - Documenting Functions by Using Comment-Based Help

#region Understanding Comment-Based Help

function tere {
    [Alias('Hello')]
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $Nimi = $env:USERNAME
    )

    'Tere {0}' -f $Nimi
}

Get-Help tere

#endregion

#region Adding Comment-Based Help to a Function
function tere {
    <#
        .SYNOPSIS
            Prints greeting
        .DESCRIPTION
            This function greets whoever given as parameter.  If no parameter
            value is provided, the currently logged on user will be greeted.
        .EXAMPLE
            tere -Nimi Paul
        .EXAMPLE
            tere

            This example greets the currently logged on user.
    #>
    [OutputType([string])]
    [Alias('Hello')]
    [CmdletBinding()]
    param (
            [string]
            # The name of the person to greet
        $Nimi = $env:USERNAME
    )

    'Tere {0}' -f $Nimi
}

Get-Help tere -Full

#endregion

#region Adding External Help to a Function

#endregion

#endregion


#region Lab E - Documenting Functions by Using Comment-Based Help

#endregion


#region Lesson 7 - Supporting –WhatIf and –Confirm

#region Understanding ConfirmImpact and Confirmation Parameters

# https://learn.microsoft.com/dotnet/api/system.management.automation.confirmimpact
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_preference_variables#confirmpreference

$ConfirmPreference

New-Item katse.txt -ItemType File
Remove-Item katse.txt

New-Item katse.txt -ItemType File
$ConfirmPreference = 'Medium'
Remove-Item katse.txt
Remove-Item katse.txt -Confirm:$false
$ConfirmPreference = 'High'

#endregion

#region Declaring Support for –WhatIf and –Confirm

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute#confirmimpact
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute#supportsshouldprocess

function Set-Something {
    [OutputType([string])]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param ()

    'Setting stuff'
}

Set-Something -WhatIf

function Set-Something {
    [CmdletBinding()]
    param ()

    'Setting stuff'
}

function Remove-File {
    [CmdletBinding(SupportsShouldProcess)]
    param (
            [Parameter(ValueFromPipelineByPropertyName)]
            [Alias('FullName')]
            [string]
        $FileName
    )

    process {
        Remove-Item $FileName
    }
}

New-Item test.txt -ItemType File
Get-Item test.txt | Remove-File -Confirm


#endregion

#region Adding Support for –WhatIf and –Confirm

# https://github.com/peetrike/Examples/blob/main/CommandLine/14%20Whatif%20and%20Confirm.ps1

# https://learn.microsoft.com/dotnet/api/system.management.automation.cmdlet.shouldprocess

# https://github.com/peetrike/scripts/blob/master/Send-PasswordNotification/Send-PasswordNotification.ps1#L219

#endregion

#endregion


#region Lab F - Supporting –WhatIf and –Confirm

#endregion
