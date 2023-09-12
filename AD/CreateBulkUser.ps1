#Store the data from Users.csv in the $Users variable
$Users = Import-csv C:\book.csv

#Loop through each row containing user details in the CSV file 
foreach ($User in $Users) {
    #Read user data from each field in each row and assign the data to a variable as below
    $SamAccountName = $User.SamAccountName 
    $UserPrincipalName = $User.UserPrincipalName
    $GivenName = $User.GivenName      
    $Surname = $User.Surname        
    $Enabled = $User.Enabled        
    $DisplayName = $User.DisplayName    
    $DistinguishedName = $User.DistinguishedName           
    $City = $User.City           
    $Company = $User.Company       
    $State = $User.State          
    $StreetAddress = $User.StreetAddress
    $OfficePhone = $User.OfficePhone  
    $EmailAddress = $User.EmailAddress  
    $Title = $User.Title        
    $Department = $User.Department 
    $Password = "Passw0rd01*"

    #Check to see if the user already exists in AD
    if (Get-ADUser -F { SamAccountName -eq $SamAccountName }) {
        #If user does exist, give a warning
        Write-Warning "A user account with username $Username already exist."
    }
    else {
        #User does not exist then create the new user account
		
        #Account will be created in the OU provided by the $OU variable read from the CSV file
        New-ADUser `
            -SamAccountName $SamAccountName `
            -Name "$GivenName $Surname" `
            -UserPrincipalName $UserPrincipalName `
            -GivenName $GivenName `
            -Surname $Surname `
            -Enabled $Enabled `
            -DisplayName $DisplayName `
            -Path $DistinguishedName `
            -City $City `
            -Company $Company `
            -State $State `
            -StreetAddress $StreetAddress  `
            -OfficePhone $OfficePhone `
            -EmailAddress $EmailAddress `
            -Title $Title `
            -Department $Department `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $true

    }
}

