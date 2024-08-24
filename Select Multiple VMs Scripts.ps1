Set-AzContext -Subscription 0fae1e9e-193f-476c-bd48-2af0adb79a75

$List = "cmazdwvdcgif03-osdisk","RG-INFRA-APP-DEV-SERVERS1"

$output = Foreach ($Name in $List){
    Get-AzSnapshot -SnapshotName $Name
}
$output | Out-GridView

or

$output | Export-Csv -Path "D:\OutFiles\Snap.csv"