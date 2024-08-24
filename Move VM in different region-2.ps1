Get-InstalledModule
Install-Module SAPAzurePowerShellModules
Get-AzSubscription
Select-AzSubscription -Subscriptionid "SUBID"
Select-AzContext -Subscriptionid "SUBID"
Move-AzVMToAzureZoneAndOrProximityPlacementGroup -VMResourceGroupName "RG Name" -VirtualMachineName "VM Name" -AzureZone "Zone"