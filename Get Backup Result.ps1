<#PSScriptInfo
 
.VERSION 1.0.0
 
.GUID c3316f68-62c7-4641-af07-94a601129276
 
.AUTHOR Taskal SAMAL
 
.COMPANYNAME Samalsons
 
.COPYRIGHT
 
.TAGS
 
.LICENSEURI
 
.PROJECTURI
 
.ICONURI
 
.EXTERNALMODULEDEPENDENCIES
 
.REQUIREDSCRIPTS
 
.EXTERNALSCRIPTDEPENDENCIES
 
.RELEASENOTES
 
 
.PRIVATEDATA
 
#>

#Requires -Module Az

<#
 
.DESCRIPTION
    This is regarding the getting the Azure Backup Report for both Snapshot & FilesFolder Backup Type from Azure Recovery Services Vault and
    send it to email using SengGrid account for all the subscriptions that you have access to.
 
    Challenges : Unable to retrive FilesFolder Backup Job Reports from AzurePowerShell.
 
    Mitigation : Used AzurePowerShell & Azure CLI to get Snaphot & FilesFolder Backup Job Reports.
 
    The report will be in excel sheet along with inbuilt Pivot Table.
 
    Below are the information that the script is retriveing from Azure Recovery Services vault.
 
    Subscription
    ResouceGroup
    Vault
    JobID
    ServerName
    JobType
    Status
    Task
    BackupSize
    StartTime
    Duration
    ErrorDetails
    Recommendations
 
 
    Author_Name : Taskal SAMAL
 
    Author_EmailID:
    Prerequisites :
 
    1. Install Azure PowerShell (Install-Module -Name Az -AllowClobber -Scope CurrentUser).
 
    2. Install Azure CLI (https://aka.ms/installazurecliwindows).
 
    3. Install ImportExcel (Install-Module -Name ImportExcel -RequiredVersion 5.4.0).
 
    4. Azure Account.
 
    5. SendGrid Account.
 
#> 
Param()

# Recording Script Start Date & Time.

$Script_Start_Time = Get-date

# Disable the Suppress Azure PowerShell Breaking Change Warnings
Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

Write-Host "VERBOSE: Script Execution Start Date & Time : $Script_Start_Time" -ForegroundColor Cyan

# Function to Get Folder using Windows Forms.

Function Get-Folder($Initial_Directory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $Folder_Name = New-Object System.Windows.Forms.FolderBrowserDialog
    $Folder_Name.Description = "Select Output Folder"
    $Folder_Name.rootfolder = "MyComputer"

    if($Folder_Name.ShowDialog() -eq "OK")
    {
        $Folder += $Folder_Name.SelectedPath
    }
    return $Folder
}

#Input Section.

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null

$To_Email_ID = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the Email ID on which you wish to get the Azure Backup Report")
$SendGrid_Username = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the Sendgrid Account Username")
$SendGrid_Password = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the Sendgrid Account Password")

$DateTime = Get-Date -Format ddMMyyyy-HHmm

# Final Output Path.

$Output_Folder_Path = Get-Folder
$Output_Path_CSV = $Output_Folder_Path + "AzureBackupJobListReport" +"-" + "$DateTime" + ".csv"
$Output_Path_XLSX = $Output_Folder_Path + "AzureBackupJobListReport" +"-" + "$DateTime" + ".xlsx"

Write-Host "VERBOSE: CSV Output File Path : $Output_Path_CSV" -ForegroundColor Cyan
Write-Host "VERBOSE: XLSX Output File Path : $Output_Path_XLSX" -ForegroundColor Cyan

# Connect to Azure using Azure CLI.

az login

# Connect to Azure using Azure PowerShell.

Connect-AzAccount

# Getting List of Subscriptions.

$Subscription_List = Get-AzSubscription | Select-Object -ExpandProperty id
(Get-AzSubscription).Name

#
foreach ($Subscription in $Subscription_List){
    
    $x++
    $Subscription_Name = Get-AzSubscription -SubscriptionId $Subscription | Select-Object -ExpandProperty Name
    
    Write-Progress -activity $Subscription_Name -PercentComplete ($x/$Subscription_List.Count*100) -Status $Subscription_Name

    $Current_Subscription_CLI= az account set --subscription $Subscription
    $Current_Subscription_PS = Select-AzSubscription -Subscription $Subscription
    
    Write-Host "VERBOSE: Working on $Subscription_Name Subcription " -ForegroundColor Cyan

    # Getting Vault list from Recovery Services vault.

    $Vault_List = (Get-AzRecoveryServicesVault).Name

    (Get-AzRecoveryServicesVault).Name
    
    Foreach ($Vault in $Vault_List){
        
        # Getting Vault Resource Group Name.

        $Vault_ResourecGroup = (Get-AzRecoveryServicesVault -Name $Vault).ResourceGroupName
        
        Write-Host "VERBOSE: Working on Vault: $Vault" -ForegroundColor Cyan
        Write-Host "VERBOSE: Vault ResourceGroup Name: $Vault_ResourecGroup" -ForegroundColor Cyan
        
        # Setting Vault Context.
    
        Get-AzRecoveryServicesVault -Name $Vault | Set-AzRecoveryServicesVaultContext

        Write-Progress -activity $Subscription_Name -PercentComplete ($x/$Subscription_List.Count*100) -Status $Vault
                
        $obj = @()
        $results = @()
        
        $Backup_JOb_List = az backup job list -g "$Vault_ResourecGroup" -v "$Vault" | ConvertFrom-Json

        # Get only last day backup report. Use below commands and comment above $Backup_JOb_List.
        # $Time_Range = (Get-Date).AddDays(-1).ToString('dd-MM-yyyy')
        #$Backup_JOb_List = az backup job list -g "$Vault_ResourecGroup" -v "$Vault" --start-time "$Time_Range" | ConvertFrom-Json
        
        Foreach ($Backup_Job in $Backup_JOb_List){

            $Backup_Job_ID = $Backup_Job.name    
            $Backup_Job_Detail = az backup job show -n "$Backup_Job_ID" -g "$Vault_ResourecGroup" -v "$Vault" | ConvertFrom-Json
            $Backup_Job_Task = $Backup_Job_Detail.properties.extendedInfo.tasksList.taskId 

                $obj = New-Object -TypeName PSobject
                $obj | Add-Member -MemberType NoteProperty -Name Subscription -Value $Subscription_Name
                $obj | Add-Member -MemberType NoteProperty -Name ResouceGroup -Value $Vault_ResourecGroup
                $obj | Add-Member -MemberType NoteProperty -Name Vault -Value $Vault
                $obj | Add-Member -MemberType NoteProperty -Name JobID -Value $Backup_Job.name
                $obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $Backup_Job.properties.entityFriendlyName
                $obj | Add-Member -MemberType NoteProperty -Name JobType -Value $(if($Backup_Job.properties.jobtype -eq "MabJob") { 'File and Folder' } else{ 'Snapshot'})
                $obj | Add-Member -MemberType NoteProperty -Name Status -Value $Backup_Job.properties.status
                $obj | Add-Member -MemberType NoteProperty -Name Task -Value $("$Backup_Job_Task")
                $obj | Add-Member -MemberType NoteProperty -Name BackupSize -Value $Backup_Job_Detail.properties.extendedInfo.propertyBag.'Backup Size'
                $obj | Add-Member -MemberType NoteProperty -Name StartTime -Value $Backup_Job.properties.starttime.Split(".")[0]
                $obj | Add-Member -MemberType NoteProperty -Name Duration -Value $Backup_Job.properties.duration.Split(".")[0]
                $obj | Add-Member -MemberType NoteProperty -Name ErrorDetails -Value $(if($Backup_Job.properties.errordetails.errorstring -ne $null){$Backup_Job.properties.errordetails.errorstring.Split(".")[1]}else{'No Error found'})
                $obj | Add-Member -MemberType NoteProperty -Name Recommendations -Value $(if($Backup_Job.properties.errordetails.recommendations -ne $null){$Backup_Job.properties.errordetails.Recommendations.Split(".")[0]}else{'No Recommendations'})
                
                $results +=$obj

        } $results | Export-csv "$Output_Path_CSV" -Append -NoTypeInformation -Verbose
    }
}

# Exporting report to Excel.

$Export_To_Excel = Import-csv -Path "$Output_Path_CSV" | Export-Excel "$Output_Path_XLSX" -IncludePivotTable -PivotRows Subscription -PivotColumns Status,Jobtype -PivotData Status -Verbose

# Sending Email.

Write-Host "VERBOSE: Sending Email To : $To_Email_ID" -ForegroundColor Cyan

$From = "AzureBackupReport@automation.com"
Write-Host "VERBOSE: Sending Email From : $From" -ForegroundColor Cyan

$Attachment = "$Output_Path_XLSX"
Write-Host "VERBOSE: Attachment Path : $Attachment" -ForegroundColor Cyan

$Subject = "Azure Backup Reports on $Script_Start_Time"
Write-Host "VERBOSE: Sending Email Subject Name : $Subject"

$Username ="$SendGrid_Username"
$Password = ConvertTo-SecureString "$SendGrid_Password" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($UserName, $Password)
$SMTP_Server = "smtp.sendgrid.net"

$txt1 = "Hello,
 
Please find attached Azure Backup Report executed on $Script_Start_Time.
 
Please check and take appropriate actions accordingly.
 
Thanks!
 
Automation Team.
"
$Body = $txt1

Send-MailMessage -From $From -to $To_Email_ID -subject $Subject -Body $Body -SmtpServer $SMTP_Server -Credential $Credential -Usessl -Port 587 -Attachments $Attachment -Verbose

$Script_End_Time = Get-date

Write-Host "VERBOSE: Script Execution End Date & Time : $Script_End_Time" -ForegroundColor Cyan