# Software Update Management

**Reference**: [Software updates overview](https://learn.microsoft.com/en-us/mem/configmgr/sum/understand/software-updates-introduction)

## Software Update Point Configuration

**Reference**: [Install and configure a software update point](https://learn.microsoft.com/en-us/mem/configmgr/sum/get-started/install-a-software-update-point)

Install SUP on a server with WSUS. Key configuration steps:
1. Add Software Update Point role to site system
2. Configure WSUS port settings (default: 8530/8531 for SSL)
3. Configure products and classifications to synchronize - [Configure classifications and products](https://learn.microsoft.com/en-us/mem/configmgr/sum/get-started/configure-classifications-and-products)
4. Set synchronization schedule - [Synchronize software updates](https://learn.microsoft.com/en-us/mem/configmgr/sum/get-started/synchronize-software-updates)

## Automatic Deployment Rules (ADR)

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

## WSUS Maintenance

**Reference**: [Software updates maintenance](https://learn.microsoft.com/en-us/mem/configmgr/sum/deploy-use/software-updates-maintenance)

Critical for ConfigMgr health (v1906+):
- Enable "Decline expired updates in WSUS according to supersedence rules"
- Enable "Add non-clustered indexes to WSUS database"
- Run WSUS cleanup wizard regularly
- Reindex SUSDB monthly - [Complete guide to WSUS maintenance](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/update-management/wsus-maintenance-guide)

## Key Software Update Logs

**Reference**: [Log files for software updates](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files#software-update-point-site-system-role)

| Log File | Location | Purpose |
|----------|----------|---------|
| WCM.log | Site Server | WSUS Configuration Manager |
| WSyncMgr.log | Site Server | Software update synchronization |
| WUAHandler.log | Client | Windows Update Agent actions |
| UpdatesDeployment.log | Client | Update deployment evaluation |
| UpdatesStore.log | Client | Update compliance state |
