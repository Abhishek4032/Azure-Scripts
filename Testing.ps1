$List = "azuremigratedisk1","azuremigrate-c"
foreach ($Name in $List){
    Get-AzSnapshot -SnapshotName $Name
}

$output = ForEach ($Destination in $List){
    Test-NetConnection -ComputerName $Destination -TraceRoute
    }
$output | Out-File -FilePath "C:\Logs\trace_route.txt"





SD-WAN = IPs

kdp01-dcr-hge1-wan01 - 10.190.255.18
kdp01-dcr-hge1-wan02 - 10.190.255.19
kdp01-dcr-hgw1-wan01 - 10.190.255.3
kdp01-dcr-hgw1-wan02 - 10.190.255.4
\\\\\\\\\\\\\\\\\\\////////////////




if((netsh interface ipv4 show dns | select-string 'DNS servers configured through DHCP:') -match 'DNS servers configured through DHCP:'){
        write-host "DNS is Automatically configured on server"
}else{
        write-host "DNS is manually configured on server"
}