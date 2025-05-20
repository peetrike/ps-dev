# Load the function from previous step
. .\step-02.ps1

# This shows brief help
Get-UserLogonInfo -?

# this shows online help
Get-Help Get-UserLogonInfo -Online

# This shows example
Get-Help Get-UserLogonInfo -Examples

# This shows, why we need blank line between code and comment
(Get-Help Get-UserLogonInfo).examples.example[0] | Format-List *

# You can even run examples
Invoke-Expression (Get-Help Get-UserLogonInfo).examples.example[0].code
