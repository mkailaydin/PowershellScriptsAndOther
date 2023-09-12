<#
=============================================================================================
Author          = Mikail AYDIN
Creation Date   = 12.09.2023

============================================================================================
#>

# Base OU
$baseOU = "DC=aydin,DC=local"

# OU Names
$ouNames = @("IT", "Management", "Finance", "Production", "Consultant", "Technician")

# Base OU and sub OU's create process
foreach ($ouName in $ouNames) {
    $ouPath = "OU=$ouName,$baseOU"
    New-ADOrganizationalUnit -Name $ouName -Path $baseOU
    
    # Create sub OU
    $subOUs = @("Users", "Comp", "Groups")
    foreach ($subOUName in $subOUs) {
        New-ADOrganizationalUnit -Name $subOUName -Path $ouPath
    }
}