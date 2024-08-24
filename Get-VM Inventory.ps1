$subscriptions = Get-AzSubscription -ErrorAction SilentlyContinue
$allVMs = @()
 
foreach ($subscription in $subscriptions) {
    Set-AzContext -SubscriptionId $subscription.Id -ErrorAction SilentlyContinue
 
    $vms = Get-AzVM -Status
 
    foreach ($vm in $vms) {
     #$publicIpResourceId = $networkInterface.IpConfigurations[0].PublicIpAddress.Id
     #$publicIp = (Get-AzPublicIpAddress -ResourceId $publicIpResourceId).IpAddress
        $vmInfo = [PSCustomObject]@{
            Name            = $vm.Name
            Type            = $vm.Type.Split('/')[-1]
            Subscription    = $subscription.Name
            ResourceGroup   = $vm.ResourceGroupName
            Location        = $vm.Location
            Status          = $vm.PowerState
            OperatingSystem = $vm.StorageProfile.OsDisk.OsType
            Size            = $vm.HardwareProfile.VmSize
            Disk            = $vm.StorageProfile.OsDisk.Name
            Data_Disk       = $vm.StorageProfile.DataDisks.Count
            TimeCreated     = $vm.TimeCreated
            PrivateIP       = (Get-AzNetworkInterface -ResourceGroupName $vm.ResourceGroupName -Name ($vm.NetworkProfile.NetworkInterfaces[0].Id.Split('/')[-1])).IpConfigurations[0].PrivateIpAddress
            #PublicIP       = (Get-AzPublicIpAddress -ResourceGroupName $vm.ResourceGroupName | Where-Object {$_.Id -eq $vm.NetworkProfile.NetworkInterfaces[0].Id}).IpAddress
            #PublicIP       = (Get-AzPublicIpAddress -ResourceGroupName $vm.ResourceGroupName | Where-Object {$_.Id -eq $vm.networkInterface.IpConfigurations[0].PublicIpAddress.Id}).IpAddress
            #PubIp           = $publicIp
        }
        $allVMs += $vmInfo
    }
}
 
 
#$obj = New-Object -TypeName psobject -Property 
#Write-Output $obj | Export-csv -Path "C:\D Drive\Snap.csv" -NoTypeInformation -Append
$allVMs | Export-csv -Path "C:\D Drive\Snap1.csv"
$allVMs | Out-GridView