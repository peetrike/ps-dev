# Looking at the output from Step 4, the WinDefend service is not running as "System Idle" Process.
# So we need to look further at our data
[CmdletBinding()]
param ()

function Get-ServiceProcess {
    [CmdletBinding()]
    param (
            [SupportsWildcards()]
            [string]
        $ServiceName = '*'
    )

    $ServiceName = $ServiceName.Replace('*', '%')
    Write-Debug -Message ('Searching with filter: {0}' -f $ServiceName)
    Get-CimInstance -ClassName Win32_Service -Filter "Name LIKE '$ServiceName'" -Verbose:$false | ForEach-Object {
        $message = 'Querying process for {0}, process ID {1}' -f $_.name, $_.ProcessId
        Write-Verbose -Message $message

        $process = Get-Process -Id $_.ProcessId
        [PSCustomObject] @{
            ComputerName = $env:COMPUTERNAME
            ServiceName  = $_.Name
            ProcessName  = $process.Name
        }
    }
}

Get-ServiceProcess -ServiceName Win* -Verbose
