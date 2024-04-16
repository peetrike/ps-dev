#Requires -Modules Pester
$PesterPreference = New-PesterConfiguration
$PesterPreference.Filter.Tag = 'Success'
$PesterPreference.Output.Verbosity = 'Detailed'

Describe 'Running tests' {
    Context 'Successful tests' -Tag 'Success' {
        It 'Test 1' {
            $true | Should -BeTrue
        }
        It 'Test 2' {
            $false | Should -BeFalse
        }
    }
    Context 'Failing tests' -Tag 'Failure' {
        It 'Test 3' {
            $true | Should -BeFalse
        }
        It 'Test 4' {
            $false | Should -BeTrue
        }
    }
}
