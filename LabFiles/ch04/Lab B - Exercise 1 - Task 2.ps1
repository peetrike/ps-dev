function Get-User {
    [CmdletBinding()]
    param (
            [int]
        $Id
    )

    $ApiUrl = 'https://jsonplaceholder.typicode.com'

    $url = @(
        $ApiUrl
        'users'
        if ($Id) {
            $Id
        }
    ) -join '/'

    Invoke-RestMethod -Uri $url
}
