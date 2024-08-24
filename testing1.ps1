# Login to Azure
Connect-AzAccount

# Function to get Azure VM details
function Get-AzureVMDetails {
    $subscriptions = Get-AzSubscription
    $vmDetails = @()

    foreach ($subscription in $subscriptions) {
        Set-AzContext -SubscriptionId $subscription.Id
        $vms = Get-AzVM

        foreach ($vm in $vms) {
            $vmName = $vm.Name
            $resourceGroup = $vm.ResourceGroupName
            $location = $vm.Location
            $status = (Get-AzVM -ResourceGroupName $resourceGroup -Name $vmName -Status).Statuses[1].Code.Split('/')[-1]
            $osType = $vm.StorageProfile.OSDisk.OsType
            $vmSize = $vm.HardwareProfile.VmSize
            $osDiskName = $vm.StorageProfile.OSDisk.Name
            $osVersion = $vm.StorageProfile.ImageReference.Version

            $networkInterfaces = Get-AzNetworkInterface -ResourceGroupName $resourceGroup | Where-Object { $_.VirtualMachine.Id -eq $vm.Id }
            $privateIp = $networkInterfaces.IpConfigurations.PrivateIpAddress
            $publicIp = (Get-AzPublicIpAddress | Where-Object { $_.IpConfiguration.Id -eq $networkInterfaces.IpConfigurations.Id }).IpAddress

            $vnet = $networkInterfaces.IpConfigurations.Subnet.Id.Split('/')[-3]
            $subnet = $networkInterfaces.IpConfigurations.Subnet.Id.Split('/')[-1]

            $totalDisks = ($vm.StorageProfile.DataDisks).Count

            $vmDetails += [PSCustomObject]@{
                VMName         = $vmName
                Subscription   = $subscription.Name
                ResourceGroup  = $resourceGroup
                Location       = $location
                Status         = $status
                OSType         = $osType
                VMSize         = $vmSize
                TotalDisks     = $totalDisks
                OSDiskName     = $osDiskName
                VNet           = $vnet
                Subnet         = $subnet
                PrivateIP      = $privateIp
                PublicIP       = $publicIp
                OSVersion      = $osVersion
            }
        }
    }
    return $vmDetails
}
