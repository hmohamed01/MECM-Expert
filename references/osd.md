# Operating System Deployment (OSD)

**Reference**: [OS deployment overview](https://learn.microsoft.com/en-us/mem/configmgr/osd/understand/introduction-to-operating-system-deployment)

## Task Sequence Components

**Reference**: [Infrastructure requirements for OSD](https://learn.microsoft.com/en-us/mem/configmgr/osd/plan-design/infrastructure-requirements-for-operating-system-deployment)

Task sequences automate OS deployment:
- **Boot Images**: Windows PE for pre-OS environment - [Manage boot images](https://learn.microsoft.com/en-us/mem/configmgr/osd/get-started/manage-boot-images)
- **OS Images**: Captured or stock WIM files - [Manage OS images](https://learn.microsoft.com/en-us/mem/configmgr/osd/get-started/manage-operating-system-images)
- **Driver Packages**: Device drivers for hardware - [Manage drivers](https://learn.microsoft.com/en-us/mem/configmgr/osd/get-started/manage-drivers)
- **Packages**: Supporting files (scripts, tools)

## Common Task Sequence Steps

**Reference**: [Task sequence steps](https://learn.microsoft.com/en-us/mem/configmgr/osd/understand/task-sequence-steps)

1. **Restart in Windows PE**: Boot to WinPE
2. **Partition Disk**: UEFI or BIOS partitioning
3. **Apply Operating System**: Deploy WIM image
4. **Apply Windows Settings**: Computer name, locale
5. **Apply Network Settings**: Domain join
6. **Setup Windows and ConfigMgr**: Install CM client
7. **Install Applications**: Deploy required apps
8. **Install Software Updates**: Apply patches

## Task Sequence Variables

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

## Key OSD Logs

**Reference**: [Log files for OSD](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files#operating-system-deployment)

| Log File | Location | Purpose |
|----------|----------|---------|
| SMSTS.log | %TEMP% or C:\Windows\CCM\Logs | Main task sequence log |
| SetupACT.log | C:\Windows\Panther | Windows Setup actions |
| Setupapi.dev.log | C:\Windows\INF | Driver installation |
