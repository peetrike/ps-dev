# This is the starting point - the script does not work
# Press F5 to run it and see


function Get-ServiceProcess {
[CmdletBinding()]param([SupportsWildcards()][string]$servicename='*')
    gcim win32_service -fil "name like '$servicename'"|%{
                $p = gcim win32_process -Fi "id=$($_.processid)"
            [pscustomobject]@{'computername'=$env:computername;'servicename'=$_.name;'procname'=$p.name
}}}}

Get-ServiceProcess -servicename lanmanserver
