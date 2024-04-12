function Test-Debug {
    [CmdletBinding()]
    param ()

    $PSVersionTable.PSVersion
    Write-Debug -Message ('The preference variable is now {0}' -f $DebugPreference)
}

Test-Debug -Debug
