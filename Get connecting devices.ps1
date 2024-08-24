 # $subs = Get-AzSubscription 

 # foreach($sub in $subs){ 

$subname = pep-nonprod-01-sub

Write-Host "Switching to $subname" -ForegroundColor Yellow 
    

    # $VNETs = Get-AzVirtualNetwork 
    

   # foreach ($VNET in $VNETs) { 

    $vnetname = pep-eiap-nonprod-scus-network-01-vnet

    Write-Host "Collecting info for $vnetname" -ForegroundColor Cyan 

        $vNetExpanded = Get-AzVirtualNetwork -Name $vnetname.name -ResourceGroupName $vnetname.ResourceGroupName -ExpandResource 'subnets/ipConfigurations'   

 
         foreach($subnet in $vNetExpanded.Subnets)  

        {   

            $sbname = $subnet.Name  

            $sbprefix = $subnet.AddressPrefix  

      

            foreach($ipConfig in $subnet.IpConfigurations)  

   

            {   $nicname = $ipconfig.Id.split("/")[8]  

                $nic = Get-AzNetworkInterface -Name $nicname  

                $vmname = $nic.VirtualMachine.Id.Split("/")[8]  

                $vmrg = $nic.VirtualMachine.Id.Split("/")[4]  

                $tag = (Get-AzVM -Name $vmname -ResourceGroupName $vmrg).Tags  

   

               $ipConfig | Select @{n="VNET";e={$VNET.Name}},  

               @{n="AddressSpace";e={$VNET | Select -ExpandProperty AddressSpace | Select -ExpandProperty AddressPrefixes}},  

               @{n="ConnectedDevice";e={($_.Id).split("/")[8]}},  

               @{n="VMname";e={$vmname}},  

               @{n="Tag";e={$tag | select -ExpandProperty Values}},  

               @{n="ConDevType";e={$_.Name}},  

               @{n="ConDevRG";e={($_.Id).split("/")[4]}},  

               PrivateIpAddress,  

               @{n="SubnetName";e={$sbname}},  

               @{n="SubnetIPrange";e={$sbprefix}}, 

               @{n="Subscription";e={$subname}} | export-csv C:\Vnet\connected1.csv -Append -UseCulture -NoTypeInformation  

            }  

        }  

   

          

   # }   

  #  }  