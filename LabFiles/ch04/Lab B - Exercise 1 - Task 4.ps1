$script:ApiUrl = 'https://jsonplaceholder.typicode.com'

function Get-User {
    [CmdletBinding()]
    param (
            [int]
            [Alias('UserId')]
        $Id
    )

    $url = @(
        $script:ApiUrl
        'users'
        if ($Id) {
            $Id
        }
    ) -join '/'

    $result = Invoke-RestMethod -Uri $url

    $ObjectProps = @{
        PSTypeName = 'User'
        userid     = $result.id
    }

    foreach ($p in $result.psobject.Properties.Name | where {$_ -ne 'id'}) {
        $ObjectProps.Add($p, $result.$p)
    }
    [PSCustomObject] $ObjectProps
}

function Get-Post {
    [CmdletBinding(DefaultParameterSetName = 'ById')]
    param (
            [Parameter(ParameterSetName = 'ById')]
            [int]
        $Id,
            [Parameter(
                Mandatory,
                ParameterSetName = 'ByUser',
                ValueFromPipelineByPropertyName
            )]
            [int]
        $UserId
    )

    process {
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
}

Export-ModuleMember -Function *
