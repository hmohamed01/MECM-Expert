---
name: mecm-expert
description: Microsoft Endpoint Configuration Manager (MECM/ConfigMgr/SCCM) administration expertise. Use when Claude needs to assist with (1) Software update management and WSUS configuration, (2) Application deployment and packaging, (3) Operating system deployment (OSD) and task sequences, (4) Collection management and WQL queries, (5) Client troubleshooting and health checks, (6) PowerShell automation with ConfigurationManager module, (7) Driver management and deployment, (8) Site server administration and infrastructure, (9) Reporting and compliance, or any other MECM/ConfigMgr administration tasks.
---

# MECM Expert Skill

This skill provides guidance for Microsoft Endpoint Configuration Manager (MECM) administration tasks. MECM is also known as Microsoft Configuration Manager (MCM), ConfigMgr, or formerly System Center Configuration Manager (SCCM).

## Primary Documentation Reference

**Official Documentation**: https://learn.microsoft.com/en-us/intune/configmgr/

Always reference official Microsoft documentation for the most current and accurate information. Key documentation areas:
- Core Infrastructure: `/core/`
- Software Updates: `/sum/`
- Application Management: `/apps/`
- OS Deployment: `/osd/`
- PowerShell Reference: `/powershell/module/configurationmanager/`
- Troubleshooting: `/troubleshoot/mem/configmgr/`

## Core Concepts

### Configuration Manager Hierarchy

ConfigMgr uses a hierarchical site structure:
- **Central Administration Site (CAS)**: Top-level site for multi-site hierarchies (optional)
- **Primary Site**: Main administration point, hosts the database
- **Secondary Site**: Child of primary site, distributes content to remote locations

### Key Site System Roles

- **Management Point (MP)**: Primary communication between clients and site
- **Distribution Point (DP)**: Content storage and distribution
- **Software Update Point (SUP)**: Integrates with WSUS for patch management
- **State Migration Point**: Stores user state during OSD
- **Reporting Services Point**: SQL Server Reporting Services integration

## Software Update Management

### Software Update Point Configuration

Install SUP on a server with WSUS. Key configuration steps:
1. Add Software Update Point role to site system
2. Configure WSUS port settings (default: 8530/8531 for SSL)
3. Configure products and classifications to synchronize
4. Set synchronization schedule

### Automatic Deployment Rules (ADR)

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

Critical for ConfigMgr health (v1906+):
- Enable "Decline expired updates in WSUS according to supersedence rules"
- Enable "Add non-clustered indexes to WSUS database"
- Run WSUS cleanup wizard regularly
- Reindex SUSDB monthly

### Key Software Update Logs

| Log File | Location | Purpose |
|----------|----------|---------|
| WCM.log | Site Server | WSUS Configuration Manager |
| WSyncMgr.log | Site Server | Software update synchronization |
| WUAHandler.log | Client | Windows Update Agent actions |
| UpdatesDeployment.log | Client | Update deployment evaluation |
| UpdatesStore.log | Client | Update compliance state |

## Application Management

### Application Model

Applications consist of:
- **Application**: High-level metadata container
- **Deployment Types**: Installation methods (MSI, Script, App-V, etc.)
- **Detection Methods**: Determine if app is installed
- **Requirements**: Conditions for deployment type applicability
- **Dependencies**: Other apps required before installation

### Detection Methods

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

- Use **Required** for mandatory installations
- Use **Available** for user-initiated installs via Software Center
- Configure maintenance windows for required deployments
- Use supersedence for application updates
- Test with simulated deployments first

### Key Application Logs

| Log File | Location | Purpose |
|----------|----------|---------|
| AppDiscovery.log | Client | Detection method evaluation |
| AppEnforce.log | Client | Application installation |
| AppIntentEval.log | Client | Desired state evaluation |
| CAS.log | Client | Content Access Service |
| ContentTransferManager.log | Client | Content download |

## Operating System Deployment (OSD)

### Task Sequence Components

Task sequences automate OS deployment:
- **Boot Images**: Windows PE for pre-OS environment
- **OS Images**: Captured or stock WIM files
- **Driver Packages**: Device drivers for hardware
- **Packages**: Supporting files (scripts, tools)

### Common Task Sequence Steps

1. **Restart in Windows PE**: Boot to WinPE
2. **Partition Disk**: UEFI or BIOS partitioning
3. **Apply Operating System**: Deploy WIM image
4. **Apply Windows Settings**: Computer name, locale
5. **Apply Network Settings**: Domain join
6. **Setup Windows and ConfigMgr**: Install CM client
7. **Install Applications**: Deploy required apps
8. **Install Software Updates**: Apply patches

### Task Sequence Variables

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

| Log File | Location | Purpose |
|----------|----------|---------|
| SMSTS.log | %TEMP% or C:\Windows\CCM\Logs | Main task sequence log |
| SetupACT.log | C:\Windows\Panther | Windows Setup actions |
| Setupapi.dev.log | C:\Windows\INF | Driver installation |

## Collection Management

### Collection Types

- **Device Collections**: Target computers/devices
- **User Collections**: Target user accounts

### Membership Rules

**Direct Rule**: Manually add specific resources
**Query Rule**: Dynamic membership via WQL
**Include Rule**: Include members from another collection
**Exclude Rule**: Exclude members from another collection

### Common WQL Queries

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

- **Full Update**: Complete re-evaluation of all rules
- **Incremental Update**: Delta changes only (enable cautiously)
- Configure evaluation schedules to avoid performance impact
- Monitor collection evaluation with colleval.log

## PowerShell Administration

### Module Setup

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

**Get Site Information**:
```powershell
Get-CMSite
```

**Manage Collections**:
```powershell
# Create device collection
New-CMDeviceCollection -Name "Test Collection" -LimitingCollectionName "All Systems"

# Add query membership rule
Add-CMDeviceCollectionQueryMembershipRule -CollectionName "Test Collection" `
    -QueryExpression "SELECT * FROM SMS_R_System WHERE Name LIKE 'PC%'" `
    -RuleName "PCs"
```

**Manage Applications**:
```powershell
# Get application
Get-CMApplication -Name "Application Name"

# Create deployment
New-CMApplicationDeployment -Name "Application Name" `
    -CollectionName "All Workstations" `
    -DeployAction Install `
    -DeployPurpose Required
```

**Manage Software Updates**:
```powershell
# Get software update groups
Get-CMSoftwareUpdateGroup

# Create deployment
New-CMSoftwareUpdateDeployment -SoftwareUpdateGroupName "2024-01 Security Updates" `
    -CollectionName "All Workstations" `
    -DeploymentType Required
```

**Manage Task Sequences**:
```powershell
# Get task sequence
$ts = Get-CMTaskSequence -Name "Deploy Windows 11"

# Add step
$step = New-CMTSStepRunCommandLine -Name "Custom Script" `
    -CommandLine "powershell.exe -ExecutionPolicy Bypass -File script.ps1"
Add-CMTaskSequenceStep -TaskSequence $ts -Step $step
```

## Client Troubleshooting

### Client Health Checks

ConfigMgr client performs automatic health checks:
- Client installation verification
- WMI repository integrity
- Required services running (CcmExec, WMI, WUA)
- Antimalware service status

Location: `C:\Windows\CCM\CcmEval.xml`

### Key Client Logs

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

**Client Not Reporting**:
1. Verify CcmExec service is running
2. Check ClientIDManagerStartup.log for registration errors
3. Verify network connectivity to MP
4. Check certificates if using HTTPS

**Content Download Failures**:
1. Check CAS.log and ContentTransferManager.log
2. Verify DP availability
3. Check boundary configuration
4. Verify client cache size

**Policy Not Updating**:
1. Run Machine Policy Retrieval cycle
2. Check PolicyAgent.log
3. Verify MP health
4. Check client assignment

### Client Actions

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

### Driver Deployment Methods

1. **Driver Packages**: Traditional method, all drivers in one package
2. **Driver Catalog**: Individual driver management
3. **Auto Apply Drivers**: Dynamic selection during OSD

### Surface Driver Updates

Enable Surface driver synchronization (v1706+):
1. Navigate to Administration > Site Configuration > Sites
2. Select top-level site > Configure Site Components > Software Update Point
3. Enable "Include Microsoft Surface drivers and firmware updates"

Requirements:
- All SUPs must run Windows Server 2016+
- Internet-connected top-level SUP

## Reporting

### Built-in Reports

ConfigMgr includes 400+ built-in SSRS reports:
- Hardware inventory
- Software inventory
- Software updates compliance
- Application deployment status
- Task sequence deployment status

### Custom Reports

Create custom reports using:
- SQL Server Reporting Services
- CMPivot for real-time queries
- Power BI integration

### SQL Server Views Reference

**Official SQL Views Documentation**: https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/sql-server-views-configuration-manager

Configuration Manager SQL Server views are essential for creating custom reports and querying site data. The views provide a faster path to data than using WMI/WQL directly.

#### SQL View Categories

| Category | Documentation URL | Purpose |
|----------|-------------------|---------|
| Schema Views | [schema-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/schema-views-configuration-manager) | View schema information and metadata |
| Discovery Views | [discovery-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/discovery-views-configuration-manager) | System, user, and group resources discovered on the network |
| Inventory Views | [inventory-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/inventory-views-configuration-manager) | General inventory information |
| Hardware Inventory Views | [hardware-inventory-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/hardware-inventory-views-configuration-manager) | Hardware inventory data (v_GS_* views) |
| Software Inventory Views | [software-inventory-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/software-inventory-views-configuration-manager) | Software inventory and file collection |
| Collection Views | [collection-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/collection-views-configuration-manager) | Collections, membership rules, and members |
| Application Management Views | [application-management-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/application-management-views-configuration-manager) | Applications, packages, programs, deployments |
| Software Updates Views | [software-updates-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/software-updates-views-configuration-manager) | Software updates metadata, groups, compliance |
| Software Metering Views | [software-metering-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/software-metering-views-configuration-manager) | Software usage metering rules and data |
| Content Management Views | [content-management-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/content-management-views-configuration-manager) | Content distribution and distribution points |
| Compliance Settings Views | [compliance-settings-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/compliance-settings-views-configuration-manager) | Configuration items, baselines, compliance |
| Operating System Deployment Views | [operating-system-deployment-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/operating-system-deployment-views-configuration-manager) | Boot images, OS images, task sequences |
| Endpoint Protection Views | [endpoint-protection-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/endpoint-protection-views-configuration-manager) | Antimalware status, malware activity |
| Client Status Views | [client-status-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/client-status-views-configuration-manager) | Client health and deployment status |
| Status and Alert Views | [status-alert-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/status-alert-views-configuration-manager) | Component, site, and site system status |
| Site Administration Views | [site-admin-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/site-admin-views-configuration-manager) | Site configuration, boundaries, site systems |
| Security Views | [security-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/security-views-configuration-manager) | User permissions and role-based access |
| Query Views | [query-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/query-views-configuration-manager) | Saved queries in the hierarchy |
| Mobile Device Management Views | [mobile-device-management-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/mobile-device-management-views-configuration-manager) | Mobile device configuration and inventory |
| Wake On LAN Views | [wake-lan-views-configuration-manager](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/wake-lan-views-configuration-manager) | Wake On LAN enabled objects and clients |

#### Sample Queries by Category

Microsoft provides sample SQL queries for each view category:
- [Sample queries for discovery](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/sample-queries-discovery-configuration-manager)
- [Sample queries for hardware inventory](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/sample-queries-hardware-inventory-configuration-manager)
- [Sample queries for software inventory](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/sample-queries-software-inventory-configuration-manager)
- [Sample queries for software updates](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/sample-queries-software-updates-configuration-manager)
- [Sample queries for software metering](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/sample-queries-software-metering-configuration-manager)
- [Sample queries for compliance settings](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/sample-queries-compliance-settings-configuration-manager)
- [Sample queries for operating system deployment](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/sample-queries-operating-system-deployment-configuration-manager)
- [Sample queries for endpoint protection](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/sample-queries-endpoint-protection-configuration-manager)
- [Sample queries for client status](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/sample-queries-client-status-configuration-manager)
- [Sample queries for status and alerts](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/sample-queries-status-alerts-configuration-manager)
- [Sample queries for asset intelligence](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/sample-queries-asset-intelligence-configuration-manager)
- [Sample queries for Wake On LAN](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/sample-queries-wake-lan-views-configuration-manager)

#### Creating Custom Reports

For guidance on building custom SSRS reports using SQL views:
- [Create custom reports by using SQL Server views](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/create-custom-reports-using-sql-server-views)

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

## Best Practices Summary

1. **Maintenance**:
   - Run WSUS cleanup monthly
   - Reindex SUSDB regularly
   - Monitor site component status
   - Back up site database

2. **Performance**:
   - Limit collection incremental updates
   - Use appropriate collection evaluation schedules
   - Distribute content before deployments
   - Use boundary groups effectively

3. **Security**:
   - Use HTTPS where possible
   - Implement role-based administration
   - Use least-privilege service accounts
   - Regular security updates for site servers

4. **Deployment**:
   - Test in pilot collections first
   - Use phased deployments for major changes
   - Configure maintenance windows
   - Monitor deployment status

## Additional Resources

- **ConfigMgr Blog**: https://techcommunity.microsoft.com/t5/Configuration-Manager-Blog/bg-p/ConfigurationManagerBlog
- **PowerShell Reference**: https://learn.microsoft.com/en-us/powershell/sccm/overview
- **Troubleshooting**: https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/welcome-configuration-manager
- **Forums**: https://learn.microsoft.com/en-us/answers/tags/417/configuration-manager
