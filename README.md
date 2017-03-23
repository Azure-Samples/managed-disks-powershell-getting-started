---
services: storage,virtual machines 
platforms: powershell
author: ramankum
---

## Introduction 
These samples demonstrate how to get started with Azure PowerShell to perform various operations on Azure Managed Disks for common scenarios. Each sample respresents a scenario that you want to implement using Azure PowerShell and Managed Disks. 

## Prerequisites
1. Install the latest version of [Azure PowerShell](http://go.microsoft.com/?linkid=9811175&clcid=0x409)
2. A Microsoft Azure subscription. If you don't have a Microsoft Azure subscription you can get a FREE trial account [here](http://go.microsoft.com/fwlink/?LinkId=330212)

## Samples 

+ [Copy a snapshot to a GRS/RA-GRS Storage account for Disaster Recovery](CopySnapshotToStorageAccount.ps1)
+ [Golden image scenario - Create an Image from a VHD file in a different subscription](CreateImageFromVHDInDifferentSubscription.ps1)

## Running samples

1. Start Windows PowerShell Integrated Scripting Environment (ISE) in **Administrator Mode**
2. At this point, you can either:
    - Create a new script and copy and paste a script from this repo into the new file: Click File > New
    - Or download/clone this repo and open a script from this repo: Click File > Open
3. Provide the appropriate values for each variable (e.g. "Subscription Name", "Storage Account Name", etc.). Note: The angled brackets should not be included in the values you provide.
4. Run the script by pressing F5 or clicking the "Run Script" icon.

## More information
- [Azure Managed Disks overview](https://docs.microsoft.com/en-us/azure/storage/storage-managed-disks-overview)
- [Migrate Azure VMs to Azure Managed Disks](https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-windows-migrate-to-managed-disks)
- [Migrate from AWS and other platforms to Managed Disks](https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-windows-on-prem-to-azure)

