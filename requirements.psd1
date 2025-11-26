@{
    PSDependOptions     = @{
        Target = 'CurrentUser'
    }

    Pester              = @{
        Version    = 'latest'
        Parameters = @{
            SkipPublisherCheck = $true
        }
    }
    platyPS             = 'latest'
    PSScriptAnalyzer    = 'latest'
}
