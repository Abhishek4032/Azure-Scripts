Connect-AzAccount

# SOURCE
$SnapshotResourceGroup = "RG-INFRA-APP-DEV-SERVERS1"
$SnapshotName = "cmazdwvdcgif02-os"

# DESTINATION
$StorageAccount = "kdpinfravelostratatestdi"
$StorageAccountBlob = "testvm"
$storageaccountResourceGroup = "KDP-Infra-Velostrata-Test"
$vhdname = "cmazdwvdcgif02-os"

# Subcription
Set-AzContext -Subscription 0fae1e9e-193f-476c-bd48-2af0adb79a75


#SA_KEY
$StorageAccountKey = (Get-AzStorageAccountKey -Name $StorageAccount -ResourceGroupName $StorageAccountResourceGroup).value[0]
$snapshot = Get-AzSnapshot -ResourceGroupName $SnapshotResourceGroup -SnapshotName $SnapshotName

#GRANTING ACCESS
$snapshotaccess = Grant-AzSnapshotAccess -ResourceGroupName $SnapshotResourceGroup -SnapshotName $SnapshotName -DurationInSecond 3600 -Access Read -ErrorAction stop 
   
$DestStorageContext = New-AzStorageContext –StorageAccountName $storageaccount -StorageAccountKey $StorageAccountKey -ErrorAction stop

Write-Output "START COPY"
Start-AzStorageBlobCopy -AbsoluteUri $snapshotaccess.AccessSAS -DestContainer $StorageAccountBlob -DestContext $DestStorageContext -DestBlob "$($vhdname).vhd" -Force -ErrorAction stop
Write-Output "END COPY"

# Now we can create new disk using the Blob Storage

# https://lepczynski.it/en/azure_en/how-to-move-a-vm-disk-snapshot-to-another-region/