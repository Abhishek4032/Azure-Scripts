#Open PowerShell and connect to your Azure account using the following command:
Connect-AzAccount

#Select the subscription that contains the VM you want to move using the following command:
Select-AzSubscription -SubscriptionName "subscription_name"
#Replace "subscription_name" with the name of your subscription.

#Get the details of the VM you want to move using the following command:
$vm = Get-AzVM -ResourceGroupName "resource_group_name" -Name "vm_name"
#Replace "resource_group_name" with the name of the resource group that contains the VM, and "vm_name" with the name of the VM.

#Stop the VM using the following command:
Stop-AzVM -ResourceGroupName "resource_group_name" -Name "vm_name" -Force

#Move the VM to the new region using the following command:
Move-AzResource -DestinationRegion "new_region" -ResourceId $vm.Id
#Replace "new_region" with the name of the new region where you want to move the VM.

#Start the VM using the following command:
Start-AzVM -ResourceGroupName "resource_group_name" -Name "vm_name"
#Replace "resource_group_name" with the name of the resource group that contains the VM, and "vm_name" with the name of the VM.
#Your Azure VM should now be moved to the new region.