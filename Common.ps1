Get-AzureRmSnapshot | Where-Object {$_.TimeCreated -lt (Get-Date).AddDays(-20)} | Remove-VMSnapshot -force

https://thomasthornton.cloud/2020/03/27/azure-disk-snapshots/



(Get-AzResource –Tag @{“Stage”=“Development”}).Name