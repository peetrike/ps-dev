# Fixed the error; put ISE in split-pane mode
# In the ISE, set a breakpoint on line 16 and then
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

Get-ServiceProcess -computername localhost
