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
$subscriptionId = '<Your SubscriptionId>'

#Provide the name of your resource group
$resourceGroupName ='<Your Resource Group Name>'

#Provide the URI of the VHD file that will be used to create image in the target subscription. 
#Ensure that the VHD file is generalized (sysprepped)
# e.g. https://contosostorageaccount1.blob.core.windows.net/vhds/contoso-um-vm120170302230408.vhd 
$vhdUri = 'https://<Storage Account Name>.blob.core.windows.net/<Container Name>/<VHD file name>' 

#Provide the Resource Id of the storage account where the VHD file is stored in the source subscription
# e.g. /subscriptions/6492b1f7-f219-446b-b509-314e17e1efb0/resourceGroups/MDDemo/providers/Microsoft.Storage/storageAccounts/contosostorageaccount1
$storageAccountResourceId = '/subscriptions/<Subscription Id>/resourceGroups/<Resource Group>/providers/Microsoft.Storage/storageAccounts/<Storage Account Name>'

#Provide the name of the Managed Disk that will be created in the target subscription (subscription 2)
$diskName = '<Disk Name>'

#Provide the size of the disks in GB. It should be greater than the VHD file size.
$diskSize = '<Disk Size>'

#Provide the Azure location (e.g. westus) where Image will be located. 
#The location should be same as the location of the storage account where VHD file is stored.
#Get all the Azure location using command below:
#Get-AzureRmLocation
$imageLocation = '<Azure Region>'

#Provide the name of the image.
$imageName = '<Image Name>'

#Provide the OS type (Windows or Linux) of the image
$osType = '<OS Type>'


# You will be promopted to enter the email address and password associated with your account. Azure will authenticate and saves the credential information, and then close the window. 
Login-AzureRmAccount

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
