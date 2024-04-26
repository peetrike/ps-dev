. $PSScriptRoot\Subfolder\Get-FunctionPath.ps1

function Test-PsCmdLet {
    <#
        .SYNOPSIS
            Test/Explore the $PsCmdlet variable
        .DESCRIPTION
            This command creates a nested prompt with $PsCmdlet set so that you explore
            the capabilities of the parameter.
            When you write an advanced function, you use $PsCmdlet to give you access to the
            PowerShell engine and a rich set of functions.  Use this function to explore what
            is available to you.
            This command copies $PsCmdlet to $p so you can use it and reduce typing.
            This is implemented by using $host.EnterNestedPrompt() which means that you have
            to type EXIT to get out of this mode.
        .EXAMPLE
            Test-PsCmdlet
        .Link
            about_functions_advanced
            about_functions_advanced_methods
            about_functions_advanced_parameters
        .Notes
            AUTHOR:    RugratsVista\jsnover
            LASTEDIT:  01/10/2009 16:25:42
    #>
    [OutputType([void])]
    [CmdletBinding()]
    param()

    $p = $PSCmdlet
    $f = $MyInvocation

    Write-Host -ForegroundColor Green '$PsCmdlet (function) = $p, $PsCmdlet (script) = $s'
    Write-Host -ForegroundColor Green '$MyInvocation (function) = $f, $MyInvocation (script) = $m'
    Write-Host -ForegroundColor Red   'Type "Exit" to return'
    function Prompt { 'Test-PSCmdlet> ' }
    $Host.EnterNestedPrompt()
}

$m = $MyInvocation
$s = $PSCmdlet

Write-Host ('$PSCommandPath = {0}' -f $PSCommandPath)
Write-Host ('$PSScriptRoot = {0}' -f $PSScriptRoot)
Write-Host ('Script Module name = {0}' -f $MyInvocation.MyCommand.Name)
Write-Host -ForegroundColor Red   'run Test-PsCmdlet and interactively explore automatic variables.'
