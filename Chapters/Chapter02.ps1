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

function katse {
    [CmdletBinding()]
    param ()
    Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='c:'"
}
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

function katse {
    param ($tere, $teine)
    "tere {0}" -f $tere
    "teine ka: {0}" -f $teine
}

katse esimene teine
katse -teine $env:USERNAME

#endregion

#region Defining a Parameter as Mandatory

function arvuti {
    [CmdletBinding()]
    param (
            [Parameter(Mandatory = $true)]
            [string]
        $ComputerName = $env:COMPUTERNAME
    )

    $ComputerName
}

arvuti

$minuprotsess = Get-Process -id $PID
arvuti $minuprotsess

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
        $ComputerName,
            [parameter(ValueFromPipeline)]
        $teine
    )

    $ComputerName
}

# this is the same
function arvuti {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,HelpMessage = 'Computer name to connect to and something else')][string]$ComputerName,
        [parameter(ValueFromPipeline)]
        $teine
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

# Review Question: When might you use a default parameter value instead of
#                  making the parameter mandatory?
# https://github.com/peetrike/scripts/blob/master/src/ComputerManagement/PowerShell/Clean-ModuleVersion.ps1

#endregion


#region Lesson 4 - Writing Functions That Accept Pipeline Input

#region Understanding Functions That Accept Pipeline Input

# ByValue
Get-Help Set-ADUser -Parameter Identity
Get-Help Stop-Service -Parameter InputObject

Get-Help Stop-Service -Parameter Name
'winrm' | Stop-Service -WhatIf

#ByPropertyName
Get-Help Stop-Service -Parameter Name
[pscustomobject] @{
    Name = 'winrm'
} | Stop-Service -WhatIf

#endregion

#region Understanding Pipeline Parameter Binding

# https://github.com/peetrike/Examples/blob/main/CommandLine/11%20Pipeline%20Input.ps1

# here we have the same problem
function nimed {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $Nimi
    )

    $Nimi
}

function nimed {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $Nimi
    )
    begin {}
    process {}
    end {
        $Nimi
    }
}

# lets fix it
function nimed {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $Nimi
    )
    begin {}
    process {
        $Nimi
    }
    end {}
}

# several ByValue parameters
function nimed {
    [CmdletBinding()]
    param (
            [Parameter(ValueFromPipeline)]
            [string]
        $Nimi,
            [Parameter(ValueFromPipeline)]
            [System.Diagnostics.Process]
        $Process
    )
    begin {}
    process {
        $Nimi
        'protsess on {0}' -f $Process
    }
    end {}
}

$minuprotsess = Get-Process -id $PID
'nimi' | nimed
$minuprotsess | nimed

function nimed {
    [CmdletBinding()]
    param (
            [Parameter(
                ParameterSetName = 'ByNimi',
                ValueFromPipeline
            )]
            [string]
        $Nimi,
            [Parameter(
                ParameterSetName = 'ByProcess',
                ValueFromPipeline
            )]
            [System.Diagnostics.Process]
        $Process
    )
    begin {}
    process {
        $Nimi
        'protsess on {0}' -f $Process
    }
    end {}
}
'nimi' | nimed
$minuprotsess | nimed

# ByPropertyName
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
nimed -Nimi 'first', 'second', 'third'

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

# Review Question: What parameters should accept pipeline input?
# https://peterwawa.wordpress.com/2013/04/09/kasutajakontode-loomine-domeenis/

#endregion


#region Lesson 5 - Producing Complex Function Output

#region Understanding the Advantages of Object Output

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_objects
Get-Help about_objects -ShowWindow

Get-Date ; Get-ChildItem

& {Get-Date ; Get-ChildItem} | Get-Member

#endregion

#region Creating the Properties for a Custom Object

#endregion

#region Creating and Producing a Custom Object

#endregion

#region Adding Custom TypeName to Object

#endregion

#endregion


#region Lab D - Producing Complex Function Output

# Review Question: What would you do if you wanted the output of a function to be formatted differently or to use specific units of measure?
Get-Volume
Get-Volume | Select-Object DriveLetter, Size, SizeRemaining
(get-volume)[0].GetType()
(get-volume)[0].psobject.TypeNames

Get-FormatData -TypeName *MSFT_Volume
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition.Control
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition.Control.Headers
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition.Control.Headers[-2..-1]
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition.Control.Rows
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition.Control.Rows.Columns
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition.Control.Rows.Columns[-2..-1]
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition.Control.Rows.Columns[-2..-1].DisplayEntry
(Get-FormatData -TypeName *MSFT_Volume).FormatViewDefinition.Control.Rows.Columns[-1].DisplayEntry.Value


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

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_comment_based_help

#endregion

#region Adding Comment-Based Help to a Function

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_comment_based_help#comment-based-help-keywords

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
        .LINK
            https://github.com/peetrike/ps-dev
        .LINK
            get-command
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

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_comment_based_help#externalhelp

# https://learn.microsoft.com/powershell/scripting/developer/help/writing-help-for-windows-powershell-cmdlets

Find-Module platyPS -Repository PSGallery

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

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_commonparameters#risk-management-parameter-descriptions

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

function Set-Something {
    [OutputType([string])]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param ()

    if ($PSCmdlet.ShouldProcess('Something')) {
        'Setting stuff'
    }
}


# https://github.com/peetrike/Examples/blob/main/CommandLine/14%20Whatif%20and%20Confirm.ps1

# https://learn.microsoft.com/dotnet/api/system.management.automation.cmdlet.shouldprocess

# https://github.com/peetrike/scripts/blob/master/Send-PasswordNotification/Send-PasswordNotification.ps1#L219

#endregion

#endregion


#region Lab F - Supporting –WhatIf and –Confirm

#endregion
