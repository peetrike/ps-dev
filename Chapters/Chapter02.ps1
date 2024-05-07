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

#endregion

#region Understanding scripts and functions

#endregion

#region Using Variable Scopes

#endregion

#region Using Dot Sourcing

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

function nimed {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $Nimi
    )

    $Nimi
}

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


#endregion

#endregion


#region Lab C - Writing Functions That Accept Pipeline Input

#endregion


#region Lesson 5 - Producing Complex Function Output

#region Understanding the Advantages of Object Output

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

#endregion

#region Adding Comment-Based Help to a Function

#endregion

#region Adding External Help to a Function

#endregion

#endregion


#region Lab E - Documenting Functions by Using Comment-Based Help

#endregion


#region Lesson 7 - Supporting –WhatIf and –Confirm

#region Understanding ConfirmImpact and Confirmation Parameters

#endregion

#region Declaring Support for –WhatIf and –Confirm

#endregion

#region Adding Support for –WhatIf and –Confirm

#endregion

#endregion


#region Lab F - Supporting –WhatIf and –Confirm

#endregion
