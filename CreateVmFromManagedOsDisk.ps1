
<#
.DESCRIPTION

This sample demonstrates how to create a virtual machine by attaching an already created Managed Disk as OS Disk.


.NOTES

1. Before you use this sample, please install the latest version of Azure PowerShell from here: http://go.microsoft.com/?linkid=9811175&clcid=0x409
2. Provide the appropriate values for each variable. Note: The angled brackets should not be included in the values you provide.

#>

#Provide the subscription Id
$subscriptionId = '<Subscription Id>'

#Provide the name of your resource group
$resourceGroupName ='<Resource Group Name>'

#Provide the name of the Managed Disk
$diskName = '<Managed Disk Name>'

#Provide the size of the disks in GB. It should be greater than the VHD file size.
$diskSize = '<Disk Size>'

#Provide the storage type for Managed Disk. PremiumLRS or StandardLRS.
$accountType = '<Storage Account Type>'

#Provide the Azure region (e.g. westus) where virtual machine will be located.
#This location should be same as the Managed Disk location 
#Get all the Azure location using command below:
#Get-AzureRmLocation
$location = '<Azure Region>'

#Provide the name of the virtual network where virtual machine will be created
$virtualNetworkName = '<Azure Virtual Network>'

#Provide the name of the virtual machine
$virtualMachineName = '<Virtual Machine Name>'

#Provide the size of the virtual machine
#e.g. Standard_DS3
#Get all the vm sizes in a region using below script:
#e.g. Get-AzureRmVMSize -Location westus
$virtualMachineSize = '<Virtual Machine Size>'


#Provide the admin user name that will be created on the created
$adminUserName = "<Admin User Name>"

#Provide the admin password 
$adminPassword = "<Admin Password>" | ConvertTo-SecureString -AsPlainText -Force

#You will be promopted to enter the email address and password associated with your account. Azure will authenticate and saves the credential information, and then close the window. 
Login-AzureRmAccount

#Set the context to the subscription Id where Managed Disk will be created
Select-AzureRmSubscription -SubscriptionId $SubscriptionId

#Get the Managed Disk based on the resource group and the disk name
$disk =  Get-AzureRmDisk -ResourceGroupName $resourceGroupName -DiskName $diskName

#Initialize virtual machine configuration
$VirtualMachine = New-AzureRmVMConfig -VMName $virtualMachineName -VMSize $virtualMachineSize

#Use the Managed Disk Resource Id to attach it to the virtual machine
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -ManagedDiskId $disk.Id -StorageAccountType $accountType -DiskSizeInGB $diskSize -CreateOption Attach -Windows

#Create a public IP for the VM  
$publicIp = New-AzureRmPublicIpAddress -Name ($VirtualMachineName.ToLower()+'_ip') -ResourceGroupName $resourceGroupName -Location $location -AllocationMethod Dynamic

#Get the virtual network where virtual machine will be hosted
$vnet = Get-AzureRmVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $resourceGroupName

# Create NIC in the first subnet of the virtual network 
$nic = New-AzureRmNetworkInterface -Name ($VirtualMachineName.ToLower()+'_nic') -ResourceGroupName $resourceGroupName -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $publicIp.Id

$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $nic.Id

#Create the virtual machine with Managed Disk
New-AzureRmVM -VM $VirtualMachine -ResourceGroupName $resourceGroupName -Location $location