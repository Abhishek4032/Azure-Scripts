$subscriptions = Get-AzContext -ListAvailable
foreach ($sub in $subscriptions) {
    $sub | Set-AzContext
    # To delete the multiple VM's snapshot | Using * for likly words
    # Get-AzSnapshot | Where-Object {($_.Name -like "Name*") -or ($_.Name -like "Name*")} | Out-GridView
    Get-AzSnapshot | Where-Object {($_.Name -like "Name*") -or ($_.Name -like "Name*")} | Remove-AzSnapshot -ErrorAction Ignore -Force
}