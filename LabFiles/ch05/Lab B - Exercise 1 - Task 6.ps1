function Get-CorpNetAdapterInfo {
    [CmdletBinding()]
    param ()

    $adapters = Get-NetAdapter
    foreach ($adapter in $adapters) {
        $addresses = Get-NetIPAddress -InterfaceIndex $adapter.InterfaceIndex
        foreach ($address in $addresses) {
            [PSCustomObject] @{
                ComputerName   = $Env:COMPUTERNAME
                AdapterName    = $adapter.Name
                InterfaceIndex = $adapter.InterfaceIndex
                IPAddress      = $address.IPAddress
                AddressFamily  = $address.AddressFamily
            }
        }
    }
}
