#Requires -Modules Pester

Describe 'Pester module' {
    BeforeAll {
        $CurrentModule = Get-Module Pester -ListAvailable |
            Sort-Object Version -Descending |
            Select-Object -First 1
    }
    It 'Module exist on system' {
        $CurrentModule | Should -Not -BeNullOrEmpty
    }
    It 'Module is up to date' {
        $PublishedVersion = (Find-PSResource Pester -Repository PSGallery).Version
        $CurrentModule.Version | Should -Be $PublishedVersion
    }
}
