#####Using Gmail#####
$from = “abhishek.baranwal02@gmail.com”
$to = “abhishek.baranwal02@gmail.com”
$cc = “abhishek.baranwal02@gmail.com”
$Subject = “Email Attachment Test”
$body = "Hi Abhishek, How are you!!!”
$attachment = “C:\Users\barax091\Desktop\reAzureBackupJobListReport-31102022-1153.xlsx”
$smtpserver = “smtp.gmail.com”
$Cred = "beihpadcjgoogoao" # Add third party access in Gmail and get the bypass password
$Port = 587

$attach_file = new-object Net.Mail.Attachment($attachment)
$message = new-object System.Net.Mail.MailMessage
$message.Subject = $Subject
$message.body = $body
$message.From = $from
$message.To.Add($to)
$message.cc.Add($cc)
$message.Attachments.Add($attachment)
$message #to check the above details

$smtp = New-Object System.Net.Mail.SmtpClient($smtpserver, $Port);
$smtp.EnableSsl = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($from, $Cred);
$smtp.Send($message)






#####Using KDP#####

$from = “abhishek.baranwal_ex@kdrp.com”
$to = “abhishek.baranwal_ex@kdrp.com”
$cc = “abhishek.baranwal_ex@kdrp.com”
$Subject = “Email Attachment Test”
$body = "Hi Team,`
`
Attaching the file for your reference`
Kindly check and confirm back”


$attachment = “C:\Users\barax091\Desktop\reAzureBackupJobListReport-31102022-1153.xlsx”
$smtpserver = “outlook.office365.com”
$Cred = "Tuesday2022kdp!"
$Port = 587

$attach_file = new-object Net.Mail.Attachment($attachment)
$message = new-object System.Net.Mail.MailMessage
$message.Subject = $Subject
$message.body = $body
$message.From = $from
$message.To.Add($to)
$message.cc.Add($cc)
$message.Attachments.Add($attachment)

$message

$smtp = New-Object System.Net.Mail.SmtpClient($smtpserver, $Port);
$smtp.EnableSsl = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($from, $Cred);
$smtp.Send($message)





SMTP        Provider	            URL	SMTP Settings
AOL	        aol.com	                smtp.aol.com
AT&T	    att.net                 smtp.mail.att.net
Comcast	    comcast.net            	smtp.comcast.net
iCloud	    icloud.com/mail     	smtp.mail.me.com
Gmail	    gmail.com              	smtp.gmail.com
Outlook	    outlook.com         	smtp-mail.outlook.com
Yahoo!	    mail.yahoo.com	        smtp.mail.yahoo.com
O365	    outlook.office.com	    outlook.office365.com
