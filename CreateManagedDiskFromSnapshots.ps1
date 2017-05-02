
<#
.DESCRIPTION

This sample demonstrates how to create Managed Disks from a snapshot
Here are the high level steps:
1. Create a Managed Disk from a snapshot 

.NOTES

1. Before you use this sample, please install the latest version of Azure PowerShell from here: http://go.microsoft.com/?linkid=9811175&clcid=0x409
2. Provide the appropriate values for each variable. Note: The angled brackets should not be included in the values you provide.

#>

#Provide the subscription Id
$subscriptionId = '<Subscription Id>'

#Provide the name of your resource group
$resourceGroupName ='<Resource Group Name>'

#Provide the name of the snapshot that will be used to create Managed Disks
$snapshotName = '<Snapshot Name>'

#Provide the name of the Managed Disk
$diskName = '<Managed Disk Name>'

#Provide the size of the disks in GB. It should be greater than the VHD file size.
$diskSize = '<Disk Size>'

#Provide the storage type for Managed Disk. PremiumLRS or StandardLRS.
$storageType = '<Storage  Type>'

#Provide the Azure region (e.g. westus) where virtual machine will be located.
#This location should be same as the Managed Disk location 
#Get all the Azure location using command below:
#Get-AzureRmLocation
$location = '<Azure Region>'

#You will be promopted to enter the email address and password associated with your account. Azure will authenticate and saves the credential information, and then close the window. 
Login-AzureRmAccount

#Set the context to the subscription Id where Managed Disk will be created
Select-AzureRmSubscription -SubscriptionId $SubscriptionId

 
$snapshot = Get-AzureRmSnapshot -ResourceGroupName $resourceGroupName -SnapshotName $snapshotName 
 
$diskConfig = New-AzureRmDiskConfig -AccountType $storageType -Location $location -CreateOption Copy -SourceResourceId $snapshot.Id
 
$osDisk = New-AzureRmDisk -Disk $diskConfig -ResourceGroupName $resourceGroupName -DiskName $diskName
 