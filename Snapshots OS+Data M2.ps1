# Connect-AzAccount

# Set your preffered Subcription
#Set-AzContext -Subscription 0d8e60b4-4c46-4067-a83b-ab40de7b2eb4

# Get VM 
$VmName = Read-host "Enter the VM Name"
$AZVMRG = Get-AzVM -Name $VmName
#$VmResourceGroup = Read-host "Enter the RG Name"
$VmResourceGroup = $AZVMRG.ResourceGroupName

$vm = get-azvm -Name $VmName -ResourceGroupName $VmResourceGroup
$location = $vm.Location
#$resourceGroup = $vm.ResourceGroupName


#VM Snapshot

Write-Output "VM $($vm.name) OS Disk Snapshot Begin"
$snapshotdisk = $vm.StorageProfile
 

    $OSDiskSnapshotConfig = New-AzSnapshotConfig -SourceUri $snapshotdisk.OsDisk.ManagedDisk.id -CreateOption Copy -location $location
    $snapshotNameOS = "$($snapshotdisk.OsDisk.Name)_snapshot_$(Get-Date -Format ddMMyy)"

# OS Disk Snapshot

        try {
            New-AzSnapshot -ResourceGroupName $VmResourceGroup -SnapshotName $snapshotNameOS -Snapshot $OSDiskSnapshotConfig -ErrorAction Stop

        } 
        catch {
            $_
        }
 
        Write-Output "VM $($vm.name) OS Disk Snapshot End"

 # Data Disk Snapshots 
 
    Write-Output "VM $($vm.name) Data Disk Snapshots Begin"
 
    $dataDisks = ($snapshotdisk.DataDisks).name
 
        foreach ($datadisk in $datadisks) {
 
            $dataDisk = Get-AzDisk -ResourceGroupName $vm.ResourceGroupName -DiskName $datadisk
 
            Write-Output "VM $($vm.name) data Disk $($datadisk.Name) Snapshot Begin"
 
            $DataDiskSnapshotConfig = New-AzSnapshotConfig -SourceUri $dataDisk.Id -CreateOption Copy -Location $location
            $snapshotNameData = "$($datadisk.name)_snapshot_$(Get-Date -Format ddMMyy)"
 
                New-AzSnapshot -ResourceGroupName $VmResourceGroup -SnapshotName $snapshotNameData -Snapshot $DataDiskSnapshotConfig -ErrorAction Stop
          
            Write-Output "VM $($vm.name) data Disk $($datadisk.Name) Snapshot End"   
        }
 
    Write-Output "VM $($vm.name) Data Disk Snapshots End"

    # Get-AzSnapshot | Where-Object {$_.TimeCreated -gt (Get-Date).AddHours(-1)} | Export-Csv -Path "D:\OutFiles\Snap.csv"

    # Get-AzSnapshot | Where-Object {$_.TimeCreated -gt (Get-Date).AddHours(-1)} | Out-GridView