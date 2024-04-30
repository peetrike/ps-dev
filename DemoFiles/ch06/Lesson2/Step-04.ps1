# Changing the filter (line 14) to match our new knowledge
# we can leave Write-Debug - just remove -Debug parameter to suppress
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
        $message = 'Searching process for service {0}' -f $_.Name
        Write-Verbose -Message $message

        $process = Get-Process -Id $_.ProcessId
        [PSCustomObject] @{
            ComputerName = $env:COMPUTERNAME
            ServiceName  = $_.Name
            ProcessName  = $process.Name
        }
    }
}

Get-ServiceProcess -ServiceName 'Win*'
