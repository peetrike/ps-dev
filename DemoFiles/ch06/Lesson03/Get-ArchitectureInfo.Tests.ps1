#Requires -Modules Pester

Describe 'Get-ArchitectureInfo' {
    BeforeAll {
        . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    }
    Context 'Function output' {
        BeforeAll {
            $Result = Get-ArchitectureInfo
        }
        It 'PSTypeName should be [ArchitectureInfo]' {
            $Result.psobject.TypeNames | Should -Contain 'ArchitectureInfo' -Because 'We expect custom typename'
        }
        It 'Processor Architecture should be [int]' {
            $Result.ProcArchitecture | Should -BeOfType [Int] -Because 'We expect number to be an integer'
        }
        It 'OS Architecture should be [int]' {
            $Result.OSArchitecture | Should -BeOfType [Int] -Because 'We expect number to be an integer'
        }
    }
}
