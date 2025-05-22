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

    $result.psobject.Properties.Name |
        Where-Object { $_ -ne 'id' } |
        ForEach-Object {
            $ObjectProps.Add($_, $result.$_)
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

function New-Post {
    [CmdletBinding(SupportsShouldProcess)]
    param (
            [Parameter(Mandatory)]
            [string]
        $Title,
            [Parameter(Mandatory)]
            [Alias('Message')]
            [string]
        $Body,
            [Parameter(
                Mandatory,
                ValueFromPipelineByPropertyName
            )]
            [int]
        $UserId
    )

    process {
        $url = @(
            $script:ApiUrl
            'posts'
        ) -join '/'

        $jsonBody = @{
            title  = $Title
            body   = $Body
            userid = $UserId
        } | ConvertTo-Json

        if ($PSCmdlet.ShouldProcess('Create a new post')) {
            Invoke-RestMethod -Uri $url -Method Post -Body $jsonBody -ContentType 'application/json'
        }
    }
}

Export-ModuleMember -Function *
