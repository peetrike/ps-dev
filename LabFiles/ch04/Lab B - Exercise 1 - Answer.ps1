function Get-CorpNetAdapterInfo {
    [CmdletBinding()]
    param ()

    foreach ($adapter in Get-NetAdapter) {
        $AdapterName = $adapter.Name
        $InterfaceIndex = $adapter.InterfaceIndex

        Get-NetIPAddress -InterfaceIndex $InterfaceIndex -ErrorAction SilentlyContinue | ForEach-Object {
            [PSCustomObject] @{
                ComputerName   = $Env:COMPUTERNAME
                AdapterName    = $AdapterName
                InterfaceIndex = $InterfaceIndex
                IPAddress      = $_.IPAddress
                AddressFamily  = $_.AddressFamily
            }
        }
    }
}
