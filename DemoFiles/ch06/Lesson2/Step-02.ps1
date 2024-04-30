# Fixing the formatting makes the script easier to read
# and makes it easier to add debug code if needed
# Press F5 to run it

function Get-ServiceProcess {
    [CmdletBinding()]
    param (
            [SupportsWildcards()]
            [string]
        $ServiceName = '*'
    )

    Get-CimInstance -ClassName Win32_Service -Filter "Name LIKE '$ServiceName'" | ForEach-Object {
        $process = Get-Process -Id $_.ProcessId
        [PSCustomObject] @{
            ComputerName = $env:COMPUTERNAME
            ServiceName  = $_.Name
            ProcessName  = $process.Name
        }
    }
}

Get-ServiceProcess -ServiceName LanmanServer
Get-ServiceProcess -ServiceName Win*
