$script:ApiUrl = 'https://jsonplaceholder.typicode.com'

function Get-User {
    [CmdletBinding()]
    param (
            [int]
        $Id
    )

    $url = @(
        $script:ApiUrl
        'users'
        if ($Id) {
            $Id
        }
    ) -join '/'

    Invoke-RestMethod -Uri $url
}

function Get-Post {
    [CmdletBinding(DefaultParameterSetName = 'ById')]
    param (
            [Parameter(ParameterSetName = 'ById')]
            [int]
        $Id,
            [Parameter(
                Mandatory,
                ParameterSetName = 'ByUser'
            )]
            [int]
        $UserId
    )

    $url = @(
        $script:ApiUrl
        if ($PSCmdlet.ParameterSetName -eq 'ByUser') {
            'users'
            $UserId
        }
        'posts'
        if ($PSBoundParameters.ContainsKey('Id')) {
            $Id
        }
    ) -join '/'

    Invoke-RestMethod -Uri $url
}

Export-ModuleMember -Function *
