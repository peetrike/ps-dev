#Requires -Modules Pester

BeforeDiscovery {
    $OldPSVersion = $PSVersionTable.PSVersion.Major -lt 6
}

Describe 'writing tests' {
    Context 'Pending test' -Tag 'Pending' {
        It 'Implicitly Pending test' {
            # this test will be skipped
        }
        It 'Explicitly Pending test' -Pending {
            $true | Should -BeFalse
        }
    }
    Context 'Skipping tests' -Tag 'Skipping' {
        It 'Explicitly skipped test' -Skip {
            $true | Should -BeTrue
        }
        It 'Conditionally skipped test' -Skip:$OldPSVersion {
            $PSVersionTable.PSVersion.Major | Should -Be 7
        }
    }
}
