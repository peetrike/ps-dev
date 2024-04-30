# Fixed the error; in the VS Code, set a breakpoint on line 15 and then
# press F5 to run the script
# At the breakpoint, press F11 to continue line-by-line

function Get-ServiceProcess {
    [CmdletBinding()]
    param (
            [SupportsWildcards()]
            [string]
        $ServiceName = '*'
    )

    $ServiceName = $ServiceName.Replace('*', '%')
    Get-CimInstance -ClassName Win32_Service -Filter "Name LIKE '$ServiceName'" -Verbose:$false | ForEach-Object {
        if ($_.State -ne 'Running') {
            $processName = '(Not started)'
        } else {
            $process = Get-Process -Id $_.ProcessId
            $processName = $process.name
        }
        [PSCustomObject] @{
            ComputerName = $env:COMPUTERNAME
            ServiceName  = $_.Name
            ProcessName  = $processName
        }
    }
}

Get-ServiceProcess -ServiceName Win*
