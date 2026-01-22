<#

.DESCRIPTION

This script creates and attaches managed disks to existing virtual machines in the format of (vmname-$number) such as windowsvm01-0 for LUN 1

Please note that your VM size dictates how many disks can be attached -- Update-AzureRmVM will error if you attempt to attach too many disks to a VM

#>

#Provide the subscription Id
$subscriptionId = 'yourSubscriptionId'

#Provide the name of your resource group
$rgName = 'resourceGroupName'

#Provide the name of your virtual machine
$vmName = 'yourVMname'

#Provide the location of this VM and resource group
$location = 'East US'

#Provide the storage type, Options are: (PremiumLRS, StandardLRS)
$storageType = 'PremiumLRS'

# How many disks do you want?:
$diskNum = 6

# How large do you want these disks to be? (max 1023GB)
$diskSize = 1023

# Which caching type do you want, Options are: (None, ReadOnly, ReadWrite)
$diskCache = "ReadWrite"

Select-AzureRmSubscription -SubscriptionId $subscriptionId

# Do the work
For ($i=0; $i -lt $diskNum; $i++) {

$lunNum = $i + 1
$dataDiskName = $vmName + '-' + $i

$diskConfig = New-AzureRmDiskConfig -AccountType $storageType -Location $location -CreateOption Empty -DiskSizeGB $diskSize
$dataDisk1 = New-AzureRmDisk -DiskName $dataDiskName -Disk $diskConfig -ResourceGroupName $rgName
$vm = Get-AzureRmVM -Name $vmName -ResourceGroupName $rgName 
$vm = Add-AzureRmVMDataDisk -VM $vm -Name $dataDiskName -CreateOption Attach -ManagedDiskId $dataDisk1.Id -Lun $lunNum -Caching $diskCache
Update-AzureRmVM -VM $vm -ResourceGroupName $rgName

}
