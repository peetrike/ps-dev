# Load the function from previos step
. .\step-02.ps1

# This verifies that the original syntax works
Get-UserLogonInfo -Filter 'samAccountName -like "admin*"'


# Now try pipeline binding by value
Get-ADOrganizationalUnit -Filter { Name -like 'IT' } |
    Get-UserLogonInfo -Filter 'Name -like "a*"'

Get-UserLogonInfo -Identity $env:USERNAME
