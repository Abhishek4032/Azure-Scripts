# Set deleteUnattachedDisks=1 if you want to delete unattached Managed Disks
# Set deleteUnattachedDisks=0 if you want to see the Id of the unattached Managed Disks
$deleteUnattachedDisks=0
$managedDisks = Get-AzDisk
foreach ($md in $managedDisks) {
    # ManagedBy property stores the Id of the VM to which Managed Disk is attached to
    # If ManagedBy property is $null then it means that the Managed Disk is not attached to a VM
    if($md.ManagedBy -eq $null){
        if($deleteUnattachedDisks -eq 1){
            Write-Host "Deleting unattached Managed Disk with Id: $($md.Id)"
            $md | Remove-AzDisk -Force
            Write-Host "Deleted unattached Managed Disk with Id: $($md.Id) "
        }else{
            $md.Id
        }
    }
 }


# or

$deleteUnattachedDisks=0

$subscriptions = Get-AzContext -ListAvailable
foreach ($sub in $subscriptions) {
    $sub | Set-AzContext
    $managedDisks = Get-AzDisk
    foreach ($md in $managedDisks) {
        if($md.ManagedBy -eq $null){
            if($deleteUnattachedDisks -eq 1){
                Write-Host "Deleting unattached Managed Disk with Id: $($md.Id)"
                $md | Where-Object {$_.TimeCreated -lt (Get-Date).AddDays(-20)} | Remove-VMSnapshot -ErrorAction stop -force
                Write-Host "Deleted unattached Managed Disk with Id: $($md.Id) "
            }else{
                $md.Id
            }
        }
     } 
}
 