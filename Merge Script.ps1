$directory = "C:\Users\Firewall\Desktop\1\Logs\Amdas\2303"

$resultFile = "C:\Users\Firewall\Desktop\Amdas-23-Mar"

Get-ChildItem -Path $directory -Include 327034*.log -Recurse | Get-Content | Out-File -FilePath $resultFile -NoClobbe

 