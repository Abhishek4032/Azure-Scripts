# Azure Login


# To Delete the AzureRmSnapshot for perticular time
Get-AzureRmSnapshot | Where-Object {$_.TimeCreated -lt (Get-Date).AddDays(-20)} | Remove-VMSnapshot -force

Get-AzSnapshot | Where-Object {$_.TimeCreated -gt (Get-Date).AddDays(-1)} | Out-GridView

$output | Export-Csv -Path "D:\OutFiles\Snap.csv"
