function Get-CorpNetAdapterInfo {
    <#
        .SYNOPSIS
            Retrieves network adapter information.
        .DESCRIPTION
            This function retrieves network adapter information from the local computer.
        .EXAMPLE
            Get-CorpNetAdapterInfo
    #>
    [CmdletBinding()]
    param ()

    foreach ($adapter in Get-NetAdapter) {
        $AdapterName = $adapter.Name
        $InterfaceIndex = $adapter.InterfaceIndex

        try {
            Get-NetIPAddress -InterfaceIndex $InterfaceIndex -ErrorAction Stop | ForEach-Object {
                [PSCustomObject] @{
                    ComputerName   = $Env:COMPUTERNAME
                    AdapterName    = $AdapterName
                    InterfaceIndex = $InterfaceIndex
                    IPAddress      = $_.IPAddress
                    AddressFamily  = $_.AddressFamily
                }
            }
        } catch {

        }
    }
}
