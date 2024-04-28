function Get-CorpNetAdapterInfo {
    [CmdletBinding()]
    param ()

    $adapters = Get-NetAdapter

    foreach ($adapter in $adapters) {

    }
}
