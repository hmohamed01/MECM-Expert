---
name: mecm-expert
description: Microsoft Endpoint Configuration Manager (MECM/ConfigMgr/SCCM) administration expertise. Use when Claude needs to assist with (1) Software update management and WSUS configuration, (2) Application deployment and packaging, (3) Operating system deployment (OSD) and task sequences, (4) Collection management and WQL queries, (5) Client troubleshooting and health checks, (6) PowerShell automation with ConfigurationManager module, (7) Driver management and deployment, (8) Site server administration and infrastructure, (9) Reporting and compliance, or any other MECM/ConfigMgr administration tasks.
---

# MECM Expert Skill

This skill provides guidance for Microsoft Endpoint Configuration Manager (MECM) administration tasks. MECM is also known as Microsoft Configuration Manager (MCM), ConfigMgr, or formerly System Center Configuration Manager (SCCM).

## Primary Documentation Reference

**Official Documentation**: https://learn.microsoft.com/en-us/mem/configmgr/

Always reference official Microsoft documentation for the most current and accurate information. Key documentation areas:

| Area | Documentation URL |
|------|-------------------|
| Core Infrastructure | [Core docs](https://learn.microsoft.com/en-us/mem/configmgr/core/) |
| Software Updates | [SUM docs](https://learn.microsoft.com/en-us/mem/configmgr/sum/) |
| Application Management | [Apps docs](https://learn.microsoft.com/en-us/mem/configmgr/apps/) |
| OS Deployment | [OSD docs](https://learn.microsoft.com/en-us/mem/configmgr/osd/) |
| PowerShell Reference | [PowerShell cmdlets](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/) |
| Troubleshooting | [Troubleshoot docs](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/) |
| What's New | [What's new](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/changes/whats-new-incremental-versions) |

## Core Concepts

### Configuration Manager Hierarchy

**Reference**: [Design a hierarchy of sites](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/design-a-hierarchy-of-sites)

ConfigMgr uses a hierarchical site structure:
- **Central Administration Site (CAS)**: Top-level site for multi-site hierarchies (optional)
- **Primary Site**: Main administration point, hosts the database
- **Secondary Site**: Child of primary site, distributes content to remote locations

### Key Site System Roles

**Reference**: [Site system roles](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/plan-for-site-system-servers-and-site-system-roles)

- **Management Point (MP)**: Primary communication between clients and site - [Plan for management points](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/plan-for-the-management-point)
- **Distribution Point (DP)**: Content storage and distribution - [Install and configure distribution points](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/deploy/configure/install-and-configure-distribution-points)
- **Software Update Point (SUP)**: Integrates with WSUS for patch management - [Plan for software updates](https://learn.microsoft.com/en-us/mem/configmgr/sum/plan-design/plan-for-software-updates)
- **State Migration Point**: Stores user state during OSD - [State migration point](https://learn.microsoft.com/en-us/mem/configmgr/osd/get-started/prepare-site-system-roles-for-operating-system-deployments#state-migration-point)
- **Reporting Services Point**: SQL Server Reporting Services integration - [Configure reporting](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/configuring-reporting)

## Software Update Management

**Reference**: [Software updates overview](https://learn.microsoft.com/en-us/mem/configmgr/sum/understand/software-updates-introduction)

### Software Update Point Configuration

**Reference**: [Install and configure a software update point](https://learn.microsoft.com/en-us/mem/configmgr/sum/get-started/install-a-software-update-point)

Install SUP on a server with WSUS. Key configuration steps:
1. Add Software Update Point role to site system
2. Configure WSUS port settings (default: 8530/8531 for SSL)
3. Configure products and classifications to synchronize - [Configure classifications and products](https://learn.microsoft.com/en-us/mem/configmgr/sum/get-started/configure-classifications-and-products)
4. Set synchronization schedule - [Synchronize software updates](https://learn.microsoft.com/en-us/mem/configmgr/sum/get-started/synchronize-software-updates)

### Automatic Deployment Rules (ADR)

**Reference**: [Automatically deploy software updates](https://learn.microsoft.com/en-us/mem/configmgr/sum/deploy-use/automatically-deploy-software-updates)

ADRs automate monthly patching (Patch Tuesday):

```powershell
# Example: Create ADR for Windows 10 security updates
New-CMSoftwareUpdateAutoDeploymentRule `
    -Name "Windows 10 Security Updates" `
    -CollectionName "All Windows 10 Workstations" `
    -AddToExistingSoftwareUpdateGroup $false `
    -EnabledAfterCreate $true
```

**Best Practices**:
- Limit deployments to 1000 updates maximum
- Create new software update groups each ADR run
- Use phased deployments for large environments
- Test in pilot collections before production

### WSUS Maintenance

**Reference**: [Software updates maintenance](https://learn.microsoft.com/en-us/mem/configmgr/sum/deploy-use/software-updates-maintenance)

Critical for ConfigMgr health (v1906+):
- Enable "Decline expired updates in WSUS according to supersedence rules"
- Enable "Add non-clustered indexes to WSUS database"
- Run WSUS cleanup wizard regularly
- Reindex SUSDB monthly - [Complete guide to WSUS maintenance](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/update-management/wsus-maintenance-guide)

### Key Software Update Logs

**Reference**: [Log files for software updates](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files#software-update-point-site-system-role)

| Log File | Location | Purpose |
|----------|----------|---------|
| WCM.log | Site Server | WSUS Configuration Manager |
| WSyncMgr.log | Site Server | Software update synchronization |
| WUAHandler.log | Client | Windows Update Agent actions |
| UpdatesDeployment.log | Client | Update deployment evaluation |
| UpdatesStore.log | Client | Update compliance state |

## Application Management

**Reference**: [Application management overview](https://learn.microsoft.com/en-us/mem/configmgr/apps/understand/introduction-to-application-management)

### Application Model

**Reference**: [Create applications](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/create-applications)

Applications consist of:
- **Application**: High-level metadata container
- **Deployment Types**: Installation methods (MSI, Script, App-V, etc.) - [Create deployment types](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/create-applications#bkmk_create-dt)
- **Detection Methods**: Determine if app is installed - [Detection methods](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/create-applications#bkmk_dt-detect)
- **Requirements**: Conditions for deployment type applicability - [Deployment type requirements](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/create-applications#bkmk_dt-require)
- **Dependencies**: Other apps required before installation - [Deployment type dependencies](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/create-applications#bkmk_dt-depend)

### Detection Methods

**Reference**: [Detection method options](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/create-applications#bkmk_dt-detect)

Configure detection rules to verify installation:

**File System Detection**:
```
Type: File
Path: C:\Program Files\AppName
File: app.exe
Property: Version >= 2.0.0.0
```

**Registry Detection**:
```
Hive: HKEY_LOCAL_MACHINE
Key: SOFTWARE\AppVendor\AppName
Value: Version
Data Type: String
Operator: Equals "2.0"
```

**MSI Product Code Detection**:
- Automatically detects using ProductCode GUID

**Script Detection (PowerShell)**:
```powershell
# Return any output = detected, no output = not detected
$app = Get-WmiObject Win32_Product | Where-Object {$_.Name -eq "AppName"}
if ($app) { Write-Output "Installed" }
```

### Deployment Best Practices

**Reference**: [Deploy applications](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/deploy-applications)

- Use **Required** for mandatory installations
- Use **Available** for user-initiated installs via Software Center
- Configure maintenance windows for required deployments - [Maintenance windows](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/manage/collections/use-maintenance-windows)
- Use supersedence for application updates - [Supersede applications](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/revise-and-supersede-applications#supersedence)
- Test with simulated deployments first - [Simulate deployments](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/simulate-application-deployments)

### Key Application Logs

**Reference**: [Log files for application management](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files#application-management)

| Log File | Location | Purpose |
|----------|----------|---------|
| AppDiscovery.log | Client | Detection method evaluation |
| AppEnforce.log | Client | Application installation |
| AppIntentEval.log | Client | Desired state evaluation |
| CAS.log | Client | Content Access Service |
| ContentTransferManager.log | Client | Content download |

## Operating System Deployment (OSD)

**Reference**: [OS deployment overview](https://learn.microsoft.com/en-us/mem/configmgr/osd/understand/introduction-to-operating-system-deployment)

### Task Sequence Components

**Reference**: [Infrastructure requirements for OSD](https://learn.microsoft.com/en-us/mem/configmgr/osd/plan-design/infrastructure-requirements-for-operating-system-deployment)

Task sequences automate OS deployment:
- **Boot Images**: Windows PE for pre-OS environment - [Manage boot images](https://learn.microsoft.com/en-us/mem/configmgr/osd/get-started/manage-boot-images)
- **OS Images**: Captured or stock WIM files - [Manage OS images](https://learn.microsoft.com/en-us/mem/configmgr/osd/get-started/manage-operating-system-images)
- **Driver Packages**: Device drivers for hardware - [Manage drivers](https://learn.microsoft.com/en-us/mem/configmgr/osd/get-started/manage-drivers)
- **Packages**: Supporting files (scripts, tools)

### Common Task Sequence Steps

**Reference**: [Task sequence steps](https://learn.microsoft.com/en-us/mem/configmgr/osd/understand/task-sequence-steps)

1. **Restart in Windows PE**: Boot to WinPE
2. **Partition Disk**: UEFI or BIOS partitioning
3. **Apply Operating System**: Deploy WIM image
4. **Apply Windows Settings**: Computer name, locale
5. **Apply Network Settings**: Domain join
6. **Setup Windows and ConfigMgr**: Install CM client
7. **Install Applications**: Deploy required apps
8. **Install Software Updates**: Apply patches

### Task Sequence Variables

**Reference**: [Task sequence variables](https://learn.microsoft.com/en-us/mem/configmgr/osd/understand/task-sequence-variables)

Set variables to control task sequence behavior:

```powershell
# PowerShell in task sequence
$TSEnv = New-Object -ComObject Microsoft.SMS.TSEnvironment
$TSEnv.Value("OSDComputerName") = "PC-" + $SerialNumber
```

Common variables:
- `OSDComputerName`: Target computer name
- `SMSTSAssignUserMode`: User device affinity
- `_SMSTSBootUEFI`: UEFI boot detection
- `SMSTSDownloadRetryCount`: Content retry attempts

### Key OSD Logs

**Reference**: [Log files for OSD](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files#operating-system-deployment)

| Log File | Location | Purpose |
|----------|----------|---------|
| SMSTS.log | %TEMP% or C:\Windows\CCM\Logs | Main task sequence log |
| SetupACT.log | C:\Windows\Panther | Windows Setup actions |
| Setupapi.dev.log | C:\Windows\INF | Driver installation |

## Collection Management

**Reference**: [Collections overview](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/manage/collections/introduction-to-collections)

### Collection Types

- **Device Collections**: Target computers/devices
- **User Collections**: Target user accounts

### Membership Rules

**Reference**: [Create collections](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/manage/collections/create-collections)

**Direct Rule**: Manually add specific resources
**Query Rule**: Dynamic membership via WQL - [How to create queries](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/create-queries)
**Include Rule**: Include members from another collection
**Exclude Rule**: Exclude members from another collection

### Common WQL Queries

**Reference**: [WQL (WMI Query Language)](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/queries-technical-reference)

**All Windows 10/11 Workstations**:
```sql
SELECT * FROM SMS_R_System 
WHERE SMS_R_System.OperatingSystemNameandVersion LIKE "%Workstation 10%"
   OR SMS_R_System.OperatingSystemNameandVersion LIKE "%Workstation 11%"
```

**All Servers**:
```sql
SELECT * FROM SMS_R_System 
INNER JOIN SMS_G_System_SYSTEM ON SMS_G_System_SYSTEM.ResourceId = SMS_R_System.ResourceId 
WHERE SMS_G_System_SYSTEM.SystemRole = "Server"
```

**Devices by Manufacturer**:
```sql
SELECT * FROM SMS_R_System 
INNER JOIN SMS_G_System_COMPUTER_SYSTEM ON SMS_G_System_COMPUTER_SYSTEM.ResourceID = SMS_R_System.ResourceId 
WHERE SMS_G_System_COMPUTER_SYSTEM.Manufacturer LIKE "%Dell%"
```

**Devices Missing ConfigMgr Client**:
```sql
SELECT * FROM SMS_R_System 
WHERE SMS_R_System.Client = 0 OR SMS_R_System.Client IS NULL
```

**Devices by OU**:
```sql
SELECT * FROM SMS_R_System 
WHERE SMS_R_System.SystemOUName = "DOMAIN.COM/OU/SUBOU"
```

### Collection Evaluation

**Reference**: [Collection evaluation](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/manage/collections/collection-evaluation)

- **Full Update**: Complete re-evaluation of all rules
- **Incremental Update**: Delta changes only (enable cautiously) - [Best practices for collections](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/manage/collections/best-practices-for-collections)
- Configure evaluation schedules to avoid performance impact
- Monitor collection evaluation with colleval.log

## PowerShell Administration

**Reference**: [ConfigurationManager PowerShell module](https://learn.microsoft.com/en-us/powershell/sccm/overview)

### Module Setup

**Reference**: [Get started with Configuration Manager cmdlets](https://learn.microsoft.com/en-us/powershell/sccm/overview#get-started)

Use this fault-tolerant loader script to import the ConfigurationManager module:

```powershell
# MECM Configuration Manager Module Loader
# Attempts to load the Configuration Manager module using multiple methods
try {
    # Method 1: Try loading using environment variable and .psd1 path
    $CMModulePath = $env:SMS_ADMIN_UI_PATH
    if ($CMModulePath) {
        $CMModulePath = $CMModulePath.Replace("\bin\i386", "\bin\ConfigurationManager.psd1")
        if (Test-Path $CMModulePath) {
            Import-Module $CMModulePath -Force
            Write-Host "Configuration Manager module loaded successfully using environment variable path." -ForegroundColor Green
        } else {
            throw "Module path from environment variable not found"
        }
    } else {
        throw "SMS_ADMIN_UI_PATH environment variable not found"
    }
}
catch {
    Write-Host "Failed to load module using environment variable path. Attempting fallback method..." -ForegroundColor Yellow
    
    try {
        # Method 2: Try using Import-Module ConfigurationManager directly
        Import-Module ConfigurationManager -Force
        Write-Host "Configuration Manager module loaded successfully using Import-Module ConfigurationManager." -ForegroundColor Green
    }
    catch {
        # Both methods failed - throw error and exit
        Write-Host "ERROR: Failed to load Configuration Manager module using both methods." -ForegroundColor Red
        Write-Host "Please ensure SCCM/MECM Console is installed and SMS_ADMIN_UI_PATH environment variable is set correctly." -ForegroundColor Red
        exit 1
    }
}

# Connect to site (replace with your site code)
$SiteCode = "PS1"
Set-Location "$($SiteCode):\"
```

### Common PowerShell Operations

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

## Client Troubleshooting

**Reference**: [Client troubleshooting overview](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/client-management/client-management-overview)

### Client Health Checks

**Reference**: [Client health](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/manage/monitor-clients#client-health)

ConfigMgr client performs automatic health checks:
- Client installation verification
- WMI repository integrity
- Required services running (CcmExec, WMI, WUA)
- Antimalware service status

Location: `C:\Windows\CCM\CcmEval.xml`

### Key Client Logs

**Reference**: [Log files reference - Client](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files#client-logs)

| Log File | Purpose |
|----------|---------|
| CcmExec.log | SMS Agent Host service |
| ClientIDManagerStartup.log | Client registration |
| LocationServices.log | MP and DP location |
| PolicyAgent.log | Policy retrieval |
| DataTransferService.log | Content transfer |
| CAS.log | Content access |
| execmgr.log | Package/program execution |

### Common Issues and Resolution

**Reference**: [Client troubleshooting guidance](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/client-management/client-management-overview)

**Client Not Reporting** - [Troubleshoot client installation](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/client-installation/troubleshoot-client-install):
1. Verify CcmExec service is running
2. Check ClientIDManagerStartup.log for registration errors
3. Verify network connectivity to MP
4. Check certificates if using HTTPS

**Content Download Failures** - [Troubleshoot content download](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/content-management/troubleshoot-content-download):
1. Check CAS.log and ContentTransferManager.log
2. Verify DP availability
3. Check boundary configuration - [Configure boundaries](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/deploy/configure/define-site-boundaries-and-boundary-groups)
4. Verify client cache size

**Policy Not Updating** - [Troubleshoot policy processing](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/client-management/client-policy-processing-overview):
1. Run Machine Policy Retrieval cycle
2. Check PolicyAgent.log
3. Verify MP health
4. Check client assignment

### Client Actions

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

## Driver Management

**Reference**: [Manage drivers in Configuration Manager](https://learn.microsoft.com/en-us/mem/configmgr/osd/get-started/manage-drivers)

### Driver Deployment Methods

1. **Driver Packages**: Traditional method, all drivers in one package - [Manage driver packages](https://learn.microsoft.com/en-us/mem/configmgr/osd/get-started/manage-drivers#driver-packages)
2. **Driver Catalog**: Individual driver management - [Import drivers](https://learn.microsoft.com/en-us/mem/configmgr/osd/get-started/manage-drivers#import-device-drivers)
3. **Auto Apply Drivers**: Dynamic selection during OSD - [Auto Apply Drivers step](https://learn.microsoft.com/en-us/mem/configmgr/osd/understand/task-sequence-steps#BKMK_AutoApplyDrivers)

### Surface Driver Updates

**Reference**: [Manage Surface drivers](https://learn.microsoft.com/en-us/mem/configmgr/sum/deploy-use/surface-drivers)

Enable Surface driver synchronization (v1706+):
1. Navigate to Administration > Site Configuration > Sites
2. Select top-level site > Configure Site Components > Software Update Point
3. Enable "Include Microsoft Surface drivers and firmware updates"

Requirements:
- All SUPs must run Windows Server 2016+
- Internet-connected top-level SUP

## Reporting

**Reference**: [Introduction to reporting](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/introduction-to-reporting)

### Built-in Reports

**Reference**: [List of reports](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/list-of-reports)

ConfigMgr includes 400+ built-in SSRS reports:
- Hardware inventory
- Software inventory
- Software updates compliance
- Application deployment status
- Task sequence deployment status

### Custom Reports

Create custom reports using:
- SQL Server Reporting Services - [Creating custom report models](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/creating-custom-report-models-in-sql-server-reporting-services)
- CMPivot for real-time queries - [CMPivot overview](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/cmpivot-overview)
- Power BI integration - [Power BI sample reports](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/powerbi-sample-reports)

### SQL Server Views Reference

**Official SQL Views Documentation**: https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sql-server-views-configuration-manager

Configuration Manager SQL Server views are essential for creating custom reports and querying site data. The views provide a faster path to data than using WMI/WQL directly.

#### SQL View Categories

| Category | Documentation URL | Purpose |
|----------|-------------------|---------|
| Schema Views | [schema-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/schema-views-configuration-manager) | View schema information and metadata |
| Discovery Views | [discovery-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/discovery-views-configuration-manager) | System, user, and group resources discovered on the network |
| Inventory Views | [inventory-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/inventory-views-configuration-manager) | General inventory information |
| Hardware Inventory Views | [hardware-inventory-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/hardware-inventory-views-configuration-manager) | Hardware inventory data (v_GS_* views) |
| Software Inventory Views | [software-inventory-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/software-inventory-views-configuration-manager) | Software inventory and file collection |
| Collection Views | [collection-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/collection-views-configuration-manager) | Collections, membership rules, and members |
| Application Management Views | [application-management-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/application-management-views-configuration-manager) | Applications, packages, programs, deployments |
| Software Updates Views | [software-updates-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/software-updates-views-configuration-manager) | Software updates metadata, groups, compliance |
| Software Metering Views | [software-metering-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/software-metering-views-configuration-manager) | Software usage metering rules and data |
| Content Management Views | [content-management-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/content-management-views-configuration-manager) | Content distribution and distribution points |
| Compliance Settings Views | [compliance-settings-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/compliance-settings-views-configuration-manager) | Configuration items, baselines, compliance |
| Operating System Deployment Views | [operating-system-deployment-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/operating-system-deployment-views-configuration-manager) | Boot images, OS images, task sequences |
| Endpoint Protection Views | [endpoint-protection-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/endpoint-protection-views-configuration-manager) | Antimalware status, malware activity |
| Client Status Views | [client-status-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/client-status-views-configuration-manager) | Client health and deployment status |
| Status and Alert Views | [status-alert-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/status-alert-views-configuration-manager) | Component, site, and site system status |
| Site Administration Views | [site-admin-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/site-admin-views-configuration-manager) | Site configuration, boundaries, site systems |
| Security Views | [security-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/security-views-configuration-manager) | User permissions and role-based access |
| Query Views | [query-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/query-views-configuration-manager) | Saved queries in the hierarchy |
| Mobile Device Management Views | [mobile-device-management-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/mobile-device-management-views-configuration-manager) | Mobile device configuration and inventory |
| Wake On LAN Views | [wake-lan-views-configuration-manager](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/wake-lan-views-configuration-manager) | Wake On LAN enabled objects and clients |

#### Sample Queries by Category

Microsoft provides sample SQL queries for each view category:
- [Sample queries for discovery](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-discovery-configuration-manager)
- [Sample queries for hardware inventory](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-hardware-inventory-configuration-manager)
- [Sample queries for software inventory](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-software-inventory-configuration-manager)
- [Sample queries for software updates](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-software-updates-configuration-manager)
- [Sample queries for software metering](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-software-metering-configuration-manager)
- [Sample queries for compliance settings](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-compliance-settings-configuration-manager)
- [Sample queries for operating system deployment](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-operating-system-deployment-configuration-manager)
- [Sample queries for endpoint protection](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-endpoint-protection-configuration-manager)
- [Sample queries for client status](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-client-status-configuration-manager)
- [Sample queries for status and alerts](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-status-alerts-configuration-manager)
- [Sample queries for asset intelligence](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-asset-intelligence-configuration-manager)
- [Sample queries for Wake On LAN](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-wake-lan-views-configuration-manager)

#### Creating Custom Reports

For guidance on building custom SSRS reports using SQL views:
- [Create custom reports by using SQL Server views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/create-custom-reports-using-sql-server-views)

#### Common SQL Views Quick Reference

| View | Purpose |
|------|---------|
| v_R_System | System discovery data |
| v_GS_COMPUTER_SYSTEM | Hardware inventory |
| v_GS_OPERATING_SYSTEM | OS information |
| v_UpdateComplianceStatus | Update compliance |
| v_Collection | Collection information |
| v_FullCollectionMembership | Collection membership |
| v_ConfigurationItems | Configuration items |
| v_CITypes | Configuration item types |
| v_ComponentSummarizer | Component status summary |
| v_SiteSummary | Site status summary |

## Log Files Reference

**Reference**: [Log files reference](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files)

Configuration Manager maintains extensive log files for troubleshooting. Key log file categories:

| Category | Documentation |
|----------|---------------|
| Client logs | [Client logs](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files#client-logs) |
| Site server logs | [Site server logs](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files#site-server-log-files) |
| Management point logs | [Management point logs](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files#management-point) |
| Distribution point logs | [Distribution point logs](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files#distribution-point) |
| Software update logs | [Software update logs](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files#software-updates) |

Use **CMTrace** to view log files: [CMTrace](https://learn.microsoft.com/en-us/mem/configmgr/core/support/cmtrace)

## Best Practices Summary

**Reference**: [Best practices for Configuration Manager](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/configs/site-and-site-system-prerequisites)

1. **Maintenance** - [Site maintenance](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/maintenance-tasks):
   - Run WSUS cleanup monthly
   - Reindex SUSDB regularly
   - Monitor site component status
   - Back up site database - [Backup and recovery](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/backup-and-recovery)

2. **Performance** - [Performance and scale](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/configs/site-size-performance-guidelines):
   - Limit collection incremental updates
   - Use appropriate collection evaluation schedules
   - Distribute content before deployments
   - Use boundary groups effectively - [Boundary groups](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/deploy/configure/boundary-groups)

3. **Security** - [Security and privacy](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/security/security-and-privacy):
   - Use HTTPS where possible - [Plan for PKI certificates](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/security/plan-for-certificates)
   - Implement role-based administration - [Role-based administration](https://learn.microsoft.com/en-us/mem/configmgr/core/understand/fundamentals-of-role-based-administration)
   - Use least-privilege service accounts
   - Regular security updates for site servers

4. **Deployment** - [Deploy content](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/deploy/configure/deploy-and-manage-content):
   - Test in pilot collections first
   - Use phased deployments for major changes - [Phased deployments](https://learn.microsoft.com/en-us/mem/configmgr/osd/deploy-use/create-phased-deployment-for-task-sequence)
   - Configure maintenance windows
   - Monitor deployment status - [Monitor deployments](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/monitor-applications-from-the-console)

## Additional Resources

- **ConfigMgr Blog**: https://techcommunity.microsoft.com/t5/Configuration-Manager-Blog/bg-p/ConfigurationManagerBlog
- **PowerShell Reference**: https://learn.microsoft.com/en-us/powershell/sccm/overview
- **Troubleshooting**: https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/welcome-configuration-manager
- **Forums**: https://learn.microsoft.com/en-us/answers/tags/417/configuration-manager
