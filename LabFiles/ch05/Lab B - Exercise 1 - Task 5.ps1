function Get-CorpNetAdapterInfo {
    [CmdletBinding()]
    param ()

    $adapters = Get-NetAdapter

    foreach ($adapter in $adapters) {
        $addresses = Get-NetIPAddress -InterfaceIndex ($adapter.InterfaceIndex)
        foreach ($address in $addresses) {

        }
    }
}
