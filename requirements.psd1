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
    psake               = 'latest'
    PSModuleDevelopment = 'latest'
    PSScriptAnalyzer    = 'latest'
}
