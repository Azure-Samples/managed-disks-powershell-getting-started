<#

.DESCRIPTION

This sample demonstrate how to generate SAS URI for a managed snapshot and use it to copy the snapshot to a storage account


.NOTES

1. Before you use this sample, please install the latest version of Azure PowerShell from here: http://go.microsoft.com/?linkid=9811175&clcid=0x409
2. Provide the appropriate values for each variable. Note: The angled brackets should not be included in the values you provide.

#>

#Provide the subscription Id of the subscription where snapshot is created
$subscriptionId = "yourSubscriptionId"

#Provide the name of your resource group where snapshot is created
$resourceGroupName ="yourResourceGroupName"

#Provide the snapshot name 
$snapshotName = "yourSnapshotName"

#Provide Shared Access Signature (SAS) expiry duration in seconds e.g. 3600.
#Know more about SAS here: https://docs.microsoft.com/en-us/azure/storage/storage-dotnet-shared-access-signature-part-1
$sasExpiryDuration = "3600"

#Provide storage account name where you want to copy the snapshot. 
$storageAccountName = "yourstorageaccountName"

#Name of the storage container where the downloaded snapshot will be stored
$storageContainerName = "yourstoragecontainername"

#Provide the key of the storage account where you want to copy snapshot. 
$storageAccountKey = 'yourStorageAccountKey'

#Provide the name of the VHD file to which snapshot will be copied.
$destinationVHDFileName = "yourvhdfilename"


# Set the context to the subscription Id where Snapshot is created
Select-AzureRmSubscription -SubscriptionId $SubscriptionId

#Get the snapshot using name and resource group
$snapshot = Get-AzureRmSnapshot -ResourceGroupName $ResourceGroupName -SnapshotName $SnapshotName 

#Generate the SAS for the snapshot 
$sas = Grant-AzureRmSnapshotAccess -ResourceGroupName $ResourceGroupName -SnapshotName $SnapshotName  -DurationInSecond $sasExpiryDuration -Access Read 
 
#Create the context for the storage account which will be used to copy snapshot to the storage account 
$destinationContext = New-AzureStorageContext –StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey  

#Copy the snapshot to the storage account 
Start-AzureStorageBlobCopy -AbsoluteUri $sas.AccessSAS -DestContainer $storageContainerName -DestContext $destinationContext -DestBlob $destinationVHDFileName