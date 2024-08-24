To unjoin the members from the new domain:
netdom remove computername /Domain:domain /UserD:user /PasswordD:* /Force
 
To join the members to the new domain: 
netdom join computername /Domain:domain /UserD:user /PasswordD:*
 


# Define domain details, credentials, and additional parameters
$domainName = "yourdomain.com"
$domainUsername = "yourdomainusername"
$domainPassword = "yourdomainpassword"
$newComputerName = "NewComputerName"
$ouPath = "OU=Computers,DC=yourdomain,DC=com"
 
# Create a secure string for the password
$securePassword = ConvertTo-SecureString $domainPassword -AsPlainText -Force
 
# Create a credential object
$credential = New-Object System.Management.Automation.PSCredential ($domainUsername, $securePassword)
 
# Join the computer to the domain with additional parameters
Add-Computer -DomainName $domainName -Credential $credential -NewName $newComputerName -OUPath $ouPath -Restart -Force

------------------------------------------------------------------------------------------------------------------------------

# Define local administrator credentials
$localAdminUsername = "LocalAdminUsername"
$localAdminPassword = "LocalAdminPassword"
 
# Create a secure string for the password
$securePassword = ConvertTo-SecureString $localAdminPassword -AsPlainText -Force
 
# Create a credential object
$credential = New-Object System.Management.Automation.PSCredential ($localAdminUsername, $securePassword)
 
# Unjoin the computer from the domain
Remove-Computer -UnjoinDomainCredential $credential -WorkgroupName "WORKGROUP" -PassThru -Force
 
# Restart the computer to apply changes
Restart-Computer