# PowerShell Administration

**Reference**: [ConfigurationManager PowerShell module](https://learn.microsoft.com/en-us/powershell/sccm/overview)

## Module Setup

**Reference**: [Get started with Configuration Manager cmdlets](https://learn.microsoft.com/en-us/powershell/sccm/overview#get-started)

Use the bundled loader script to import the ConfigurationManager module:

```powershell
# Run the loader script with your site code
. .\scripts\Import-CMModule.ps1 -SiteCode "PS1"
```

The script attempts two loading methods:
1. Environment variable path (`SMS_ADMIN_UI_PATH`)
2. Direct `Import-Module ConfigurationManager`

## Common PowerShell Operations

**Reference**: [Configuration Manager cmdlets](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/)

**Get Site Information** - [Get-CMSite](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmsite):
```powershell
Get-CMSite
```

**Manage Collections** - [New-CMDeviceCollection](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/new-cmdevicecollection):
```powershell
# Create device collection
New-CMDeviceCollection -Name "Test Collection" -LimitingCollectionName "All Systems"

# Add query membership rule
Add-CMDeviceCollectionQueryMembershipRule -CollectionName "Test Collection" `
    -QueryExpression "SELECT * FROM SMS_R_System WHERE Name LIKE 'PC%'" `
    -RuleName "PCs"
```

**Manage Applications** - [Get-CMApplication](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmapplication), [New-CMApplicationDeployment](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/new-cmapplicationdeployment):
```powershell
# Get application
Get-CMApplication -Name "Application Name"

# Create deployment
New-CMApplicationDeployment -Name "Application Name" `
    -CollectionName "All Workstations" `
    -DeployAction Install `
    -DeployPurpose Required
```

**Manage Software Updates** - [Get-CMSoftwareUpdateGroup](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmsoftwareupdategroup), [New-CMSoftwareUpdateDeployment](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/new-cmsoftwareupdatedeployment):
```powershell
# Get software update groups
Get-CMSoftwareUpdateGroup

# Create deployment
New-CMSoftwareUpdateDeployment -SoftwareUpdateGroupName "2024-01 Security Updates" `
    -CollectionName "All Workstations" `
    -DeploymentType Required
```

**Manage Task Sequences** - [Get-CMTaskSequence](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/get-cmtasksequence):
```powershell
# Get task sequence
$ts = Get-CMTaskSequence -Name "Deploy Windows 11"

# Add step
$step = New-CMTSStepRunCommandLine -Name "Custom Script" `
    -CommandLine "powershell.exe -ExecutionPolicy Bypass -File script.ps1"
Add-CMTaskSequenceStep -TaskSequence $ts -Step $step
```

## Client Actions

**Reference**: [Client notification](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/manage/client-notification)

Trigger client actions via PowerShell:
```powershell
# Machine Policy Retrieval
Invoke-WMIMethod -Namespace root\ccm -Class SMS_Client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000021}"

# Software Update Scan
Invoke-WMIMethod -Namespace root\ccm -Class SMS_Client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000113}"

# Application Deployment Evaluation
Invoke-WMIMethod -Namespace root\ccm -Class SMS_Client -Name TriggerSchedule "{00000000-0000-0000-0000-000000000121}"
```
