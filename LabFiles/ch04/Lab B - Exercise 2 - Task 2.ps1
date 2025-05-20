$script:ApiUrl = 'https://jsonplaceholder.typicode.com'
$script:ContentType = 'application/json'

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
            Invoke-RestMethod -Uri $url -Method Post -Body $jsonBody -ContentType $script:ContentType
        }
    }
}

function Set-Post {
    [CmdletBinding(SupportsShouldProcess)]
    param (
            [Parameter(
                Mandatory,
                ValueFromPipelineByPropertyName
            )]
            [int]
        $Id,
            [string]
        $Title,
            [string]
        $Body
    )

    process {
        $url = @(
            $script:ApiUrl
            'posts'
            $Id
        ) -join '/'

        $bodyHash = @{}
        if ($Title) {
            $BodyHash.title = $Title
        }
        if ($Message) {
            $BodyHash.body = $Body
        }

        $jsonBody = $bodyHash | ConvertTo-Json

        if ($PSCmdlet.ShouldProcess($Id, 'Update a post with ID')) {
            Invoke-RestMethod -Uri $url -Method Patch -Body $jsonBody -ContentType $script:ContentType
        }
    }
}

Export-ModuleMember -Function *
