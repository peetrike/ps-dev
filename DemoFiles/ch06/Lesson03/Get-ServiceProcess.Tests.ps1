#Requires -Modules Pester

Describe 'Get-ServiceProcess' {
    BeforeAll {
        . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    }
    Context 'Function output' {
        BeforeAll {
            $Result = Get-ServiceProcess -ServiceName LanmanWorkstation
        }
        It 'Output should have custom typename' {
            $Result.psobject.TypeNames | Should -Contain 'PSDevOps.ServiceProcess'
        }
        It 'Process should exist' {
            $Result.ProcessName | Should -Be 'svchost'
        }
        It 'Service name should be correct' {
            $Result.ServiceName | Should -Be 'LanmanWorkstation'
        }
        It 'Computer name should be correct' {
            $Result.ComputerName | Should -Be $env:COMPUTERNAME
        }
        It 'Given stopped service, process name should be "(Not started)"' {
            $Service = Get-Service | Where-Object Status -Like Stopped | Select-Object -First 1
            $Result = Get-ServiceProcess -ServiceName $Service.Name
            $Result.ProcessName | Should -Be '(Not started)'
        }
    }
    Context 'Function parameters' {
        Context 'ServiceName' {
            It 'Should exist' {
                Get-Command Get-ServiceProcess | Should -HaveParameter ServiceName
            }
            It 'Parameter Type should be String' {
                Get-Command Get-ServiceProcess | Should -HaveParameter ServiceName -Type String
            }
            It 'Parameter should have default value' {
                Get-Command Get-ServiceProcess | Should -HaveParameter ServiceName -DefaultValue '*'
            }
            It 'Parameter should support wildcards' {
                Get-ServiceProcess -ServiceName win* | Should -Not -BeNullOrEmpty
            }
        }
    }
}
