$NicName = "<name of the NIC>"
$RGName = "<resource group name>"
$nic = Get-AzureRmNetworkInterface -Name $NicName -ResourceGroup $RGName 
$a = $nic.IpConfigurations[0].LoadBalancerBackendAddressPools.Id -split"/"
$Namelb = $a[8]