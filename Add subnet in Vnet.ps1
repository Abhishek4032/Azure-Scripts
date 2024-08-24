#Variables declaration 
$VNetResourceGroup = "pep-network-nonprod-snt-scus-01-rg"
$VNetName = "pep-paas-nonprod-snt-01-scus-vnet"
$Subscription = "pep-nonprod-snt-01-sub"
$IpAddress = "172.26.16.0/24"
Connect-AzAccount
Write-Host "--------------------------------------------------------------------------------------"
Write-Host "Authenticating to Azure"
Write-Host "--------------------------------------------------------------------------------------"
$token = Get-AzAccessToken
$Headers = @{}

$Headers.Add("Authorization", "$($token.type) " + " " + "$($token.Token)")
#Write-Host "Print Token" -ForegroundColor Green
#Write-Output $Token

Select-AzSubscription -Subscription $Subscription
Write-Output "------------------------------------------------------------------------------------"

$vnet = Get-AzVirtualNetwork -ResourceGroupName $VNetResourceGroup -Name $VNetName
#Write-Host $vnet.AddressSpace.AddressPrefixes
$vnetbackup = $vnet | Select-Object  `
    @{label = 'VnetName'; expression = { $_.Name } },          
    @{label = 'AddressSpace'; expression = { $_.AddressSpace.AddressPrefixes } }, `
    @{label = 'SubnetName'; expression = { $_.Subnets.Name -join (',') } }, `
    @{label = 'DnsServers'; expression = { $_.DhcpOptions.DnsServers -join (',') } }, `
    @{label = 'SubnetAddressSpace'; expression = { $_.Subnets.AddressPrefix -join (',') } }, `
    @{label = 'PeeringName'; expression = { $_.VirtualNetworkPeerings.Name -join (',') } }, `
    @{label = 'PeeringRemoteID'; expression = { $_.VirtualNetworkPeerings.RemoteVirtualNetwork.Id -join (',') } }
    $vnetObj = New-Object System.Object
    $vnetObj = $vnetbackup  | export-csv -path ./vnetbackupdetails.csv -NoTypeInformation

$adressprefix = $vnet.AddressSpace.AddressPrefixes -join ('","')
if ($IpAddress -cin $vnet.AddressSpace.AddressPrefixes) {
    Write-output "address space is already updated or part of the VNET"
    Write-Output "------------------------------------------------------------------------------------"
}
else {

    #Write-Output "New addressprefixes to be added to the VNET"
    $vnet = Get-AzVirtualNetwork -ResourceGroupName $VNetResourceGroup -Name $VNetName
    $vnetsubid = $vnet.Id
    Write-Output "New address prefixes to be added to VNET: " $vnetsubid
    #Add IP address range to the vnet
    $vnet.AddressSpace.AddressPrefixes.Add($IpAddress)
    #end

    #Apply configuration stored in $vnet
    Set-AzVirtualNetwork -VirtualNetwork $vnet
    #end
    Write-Output "------------------------------------------------------------------------------------"
    Write-Output "New adress prefixes which will update is: "$IpAddress
    Write-Output "------------------------------------------------------------------------------------"
    Write-Output "Address prefixes part of the VNET aree: "$vnet.AddressSpace.AddressPrefixes

    $remotepeerigid = $vnet.VirtualNetworkPeerings.RemoteVirtualNetwork.id
    $remotepeerigname = $vnet.VirtualNetworkPeerings.Name
    Write-Output "------------------------------------------------------------------------------------"
    #Write-Output $remotepeerigname
    #Write-Output $remotepeerigid
    Write-Output "------------------------------------------------------------------------------------"
    foreach ( $j in  $remotepeerigid ) {
        Write-Output $j
        #Sync-AzVirtualNetworkPeering -Name $j -VirtualNetworkName $VNetName -ResourceGroupName $VNetResourceGroup
        $remotepeerigvalues = $j -split "/"
        $remotesubscriptionid = $remotepeerigvalues[2]
        $remoteresourcegroup = $remotepeerigvalues[4]
        $remotevnet = $remotepeerigvalues[8]


        Write-Host $remotepeerigvalues
        Write-Host $remotesubscriptionid
        Write-Host $remoteresourcegroup
        Write-Host $remotevnet
        Write-Output "------------------------------------------------------------------------------------"
        Write-Output "------------------------------------------------------------------------------------"
        Select-AzSubscription -Subscription $remotesubscriptionid
        Start-Sleep 10
        $peering = Get-AzVirtualNetworkPeering -VirtualNetwork $remotevnet -ResourceGroupName $remoteresourcegroup | where-object { $_.PeeringSyncLevel -ne "FullyInSync" }
        $peeringname = $peering.name
        
        Write-Output $peeringname.name
        Sync-AzVirtualNetworkPeering -Name $peering.name -VirtualNetworkName $remotevnet -ResourceGroupName $remoteresourcegroup

    }
}