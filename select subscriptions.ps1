$subscriptions = Get-AzContext -ListAvailable
foreach ($sub in $subscriptions) {
    $sub | Set-AzContext
        Get-AzVM -Name cmazdwvdcgif02 
}




$subscriptions = Get-AzureSubscription
Get-AzureSubscription -ListAvailable
foreach ($sub in $subscriptions)
{
    $sub | Select-AzureSubscription
    Get-AzureService | % {
           Get-AzureDeployment -ServiceName $_.ServiceName
        } | % { 
          New-Object -TypeName 'PSObject' -Property @{ 'ServiceName' = $_.ServiceName; 'Addresses' = $_.VirtualIPs.Address; } 
        } | sort Addresses | ft
}



$subscriptions = Get-AzContext -ListAvailable
foreach ($sub in $subscriptions) 
{
    $sub | Set-AzContext
        Get-AzPublicIpAddress | ForEach-Object {
          Export-Csv -Path "D:\OutFiles\PubIP*.csv"
        }
}


# https://stackoverflow.com/questions/53602818/azure-powershell-across-multiple-subscriptions-in-an-ea