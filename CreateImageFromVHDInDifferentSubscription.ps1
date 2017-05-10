<#

.DESCRIPTION

This sample demonstrates how to enable golden image scenario using Managed Disks. It shows how to create an image using a generalized (sysprepped) VHD file in a different subscription than where VHD file is located. 

Here are the high level steps:

1. Create a managed disk in the target subscription (subscription 2) using a generalized (sysprepped) VHD file in the source subscription (subscription 1)
2. Create an image in the target subscription using the new managed disk created in the same subscription
3. Delete the Managed Disk created in Step 1


.NOTES

1. Before you use this sample, please install the latest version of Azure PowerShell from here: http://go.microsoft.com/?linkid=9811175&clcid=0x409
2. Provide the appropriate values for each variable. Note: The angled brackets should not be included in the values you provide.


#>

#Provide the subscription Id
$subscriptionId = 'yourSubscriptionId'

#Provide the name of your resource group
$resourceGroupName ='yourResourceGroupName'

#Provide the URI of the VHD file that will be used to create image in the target subscription. 
#Ensure that the VHD file is generalized (sysprepped)
# e.g. https://contosostorageaccount1.blob.core.windows.net/vhds/contoso-um-vm120170302230408.vhd 
$vhdUri = 'https://yourStorageAccountName.blob.core.windows.net/yourContainerName/yourVHDName.vhd' 

#Provide the Resource Id of the storage account where the VHD file is stored in the source subscription
# e.g. /subscriptions/6492b1f7-f219-446b-b509-314e17e1efb0/resourceGroups/MDDemo/providers/Microsoft.Storage/storageAccounts/contosostorageaccount1
$storageAccountResourceId = '/subscriptions/yourSubscriptionId/resourceGroups/yourResourceGroupName/providers/Microsoft.Storage/storageAccounts/yourStorageAccount'

#Provide the name of the Managed Disk that will be created in the target subscription (subscription 2)
$diskName = 'yourDiskName'

#Provide the size of the disks in GB. It should be greater than the VHD file size.
$diskSize = '128'

#Provide the Azure location (e.g. westus) where Image will be located. 
#The location should be same as the location of the storage account where VHD file is stored.
#Get all the Azure location using command below:
#Get-AzureRmLocation
$imageLocation = 'westus'

#Provide the name of the image.
$imageName = 'yourImageName'

#Provide the OS type (Windows or Linux) of the image
$osType = 'windows'

# Set the context to the target subscription Id where image will be created
Select-AzureRmSubscription -SubscriptionId $SubscriptionId

#Step 1: Create Managed Disk in the target subscription (subscription 2) using the VHD file in the source subscription

$diskConfig = New-AzureRmDiskConfig -AccountType StandardLRS -Location $imagelocation -CreateOption Import -SourceUri $vhdUri -StorageAccountId $storageAccountResourceId -DiskSizeGB $diskSize

$osDisk = New-AzureRmDisk -DiskName $diskName -Disk $diskConfig -ResourceGroupName $resourceGroupName

#Step 2: Create an image the target subscription (subscription 2) using the Managed Disk created in the same subscription

$imageConfig = New-AzureRmImageConfig -Location $imageLocation

$imageConfig = Set-AzureRmImageOsDisk -Image $imageConfig -OsType $osType -OsState Generalized -ManagedDiskId $osDisk.Id

$image = New-AzureRmImage -ImageName $imageName -ResourceGroupName $resourceGroupName -Image $imageConfig 

#Step 3: Delete the Managed Disk created in Step 1
Remove-AzureRmDisk -ResourceGroupName $resourceGroupName -DiskName $diskName
