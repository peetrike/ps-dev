# We're getting no results from the line 13
# That suggests that a WQL filter doesn't work like we assumed

function Get-ServiceProcess {
    [CmdletBinding()]
    param (
            [SupportsWildcards()]
            [string]
        $ServiceName = '*'
    )

    Write-Debug -Message ('Searching with filter: {0}' -f $ServiceName)
    Get-CimInstance -ClassName Win32_Service -Filter "Name LIKE '$ServiceName'" | ForEach-Object {
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

Get-ServiceProcess -ServiceName 'Win*' -Debug -Verbose
