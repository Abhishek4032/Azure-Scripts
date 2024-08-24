Connect-AzAccount
 
Set-AzContext -SubscriptionId "534ba9c6-d05c-4fce-84a3-732eae3fd5be"
 
Stop-AzVM -ResourceGroupName "RGP-SHAREPOINT2013-PROD-UE2" -Name "SBLPVSHPOWA02" -Force
 
$vm = Get-AzVM -ResourceGroupName "RGP-SHAREPOINT2013-PROD-UE2" -Name "SBLPVSHPOWA02"
$osDiskUri = $vm.StorageProfile.OsDisk.Vhd.Uri
 
 
# New OS disk VHD URI
$newOsDiskUri = "https://stasharepoint2013prdue22.blob.core.windows.net/sblpvshpowa02-b34cf476423e4f70973b58d37a284297/sblpvshpowa02-osdisk-20240723-035500.vhd"
 
# Update the VM to use the new OS disk
$vm.StorageProfile.OsDisk.Vhd.Uri = $newOsDiskUri
 
# Update the VM configuration
Update-AzVM -ResourceGroupName "RGP-SHAREPOINT2013-PROD-UE2" -VM $vm
 
 
Start-AzVM -ResourceGroupName "RGP-SHAREPOINT2013-PROD-UE2" -Name "SBLPVSHPOWA02"