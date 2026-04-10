# Application Management

**Reference**: [Application management overview](https://learn.microsoft.com/en-us/mem/configmgr/apps/understand/introduction-to-application-management)

## Application Model

**Reference**: [Create applications](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/create-applications)

Applications consist of:
- **Application**: High-level metadata container
- **Deployment Types**: Installation methods (MSI, Script, App-V, etc.) - [Create deployment types](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/create-applications#bkmk_create-dt)
- **Detection Methods**: Determine if app is installed - [Detection methods](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/create-applications#bkmk_dt-detect)
- **Requirements**: Conditions for deployment type applicability - [Deployment type requirements](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/create-applications#bkmk_dt-require)
- **Dependencies**: Other apps required before installation - [Deployment type dependencies](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/create-applications#bkmk_dt-depend)

## Detection Methods

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

## Deployment Best Practices

**Reference**: [Deploy applications](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/deploy-applications)

- Use **Required** for mandatory installations
- Use **Available** for user-initiated installs via Software Center
- Configure maintenance windows for required deployments - [Maintenance windows](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/manage/collections/use-maintenance-windows)
- Use supersedence for application updates - [Supersede applications](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/revise-and-supersede-applications#supersedence)
- Test with simulated deployments first - [Simulate deployments](https://learn.microsoft.com/en-us/mem/configmgr/apps/deploy-use/simulate-application-deployments)

## Key Application Logs

**Reference**: [Log files for application management](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files#application-management)

| Log File | Location | Purpose |
|----------|----------|---------|
| AppDiscovery.log | Client | Detection method evaluation |
| AppEnforce.log | Client | Application installation |
| AppIntentEval.log | Client | Desired state evaluation |
| CAS.log | Client | Content Access Service |
| ContentTransferManager.log | Client | Content download |
