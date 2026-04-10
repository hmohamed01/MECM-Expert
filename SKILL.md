---
name: mecm-expert
description: Microsoft Endpoint Configuration Manager (MECM/ConfigMgr/SCCM) administration expertise. Use when Claude needs to assist with (1) Software update management and WSUS configuration, (2) Application deployment and packaging, (3) Operating system deployment (OSD) and task sequences, (4) Collection management and WQL queries, (5) Client troubleshooting and health checks, (6) PowerShell automation with ConfigurationManager module, (7) Driver management and deployment, (8) Site server administration and infrastructure, (9) Reporting and compliance, or any other MECM/ConfigMgr administration tasks.
---

# MECM Expert Skill

Guidance for Microsoft Endpoint Configuration Manager (MECM/ConfigMgr/SCCM) administration tasks.

## Primary Documentation Reference

**Official Documentation**: https://learn.microsoft.com/en-us/mem/configmgr/

| Area | Documentation URL |
|------|-------------------|
| Core Infrastructure | [Core docs](https://learn.microsoft.com/en-us/mem/configmgr/core/) |
| Software Updates | [SUM docs](https://learn.microsoft.com/en-us/mem/configmgr/sum/) |
| Application Management | [Apps docs](https://learn.microsoft.com/en-us/mem/configmgr/apps/) |
| OS Deployment | [OSD docs](https://learn.microsoft.com/en-us/mem/configmgr/osd/) |
| PowerShell Reference | [PowerShell cmdlets](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/) |
| Troubleshooting | [Troubleshoot docs](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/) |
| What's New | [What's new](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/changes/whats-new-incremental-versions) |

## Live Documentation Fetching

Use the `WebFetch` tool to retrieve live content from reference URLs for accuracy. Microsoft documentation is frequently updated.

### When to Fetch

| Scenario | Action |
|----------|--------|
| PowerShell cmdlet syntax | Fetch `https://learn.microsoft.com/en-us/powershell/module/configurationmanager/{cmdlet-name}` |
| Troubleshooting steps | Fetch `https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/` + topic path |
| Version-specific features | Fetch What's New page to confirm availability |
| SQL view schemas | Fetch SQL view docs for accurate column names and joins |
| Task sequence steps | Fetch step documentation for current options and variables |
| Error codes | Fetch troubleshooting docs for specific error resolution |

### Fetch Guidelines

1. **Always fetch for cmdlet syntax** — parameters change between versions
2. **Fetch for troubleshooting** — resolution steps may be updated
3. **Verify version requirements** — confirm which ConfigMgr version supports a feature before recommending
4. **Cross-reference error codes** — fetch specific error code documentation
5. **Cache awareness** — skip re-fetching URLs already retrieved in the same session

## Reference Files

Load the appropriate reference file based on the user's topic:

| Topic | Reference File | Covers |
|-------|---------------|--------|
| Patch management, WSUS, ADRs | [software-updates.md](references/software-updates.md) | SUP config, ADRs, WSUS maintenance, update logs |
| App deployment and packaging | [application-management.md](references/application-management.md) | App model, detection methods, deployment, app logs |
| OS deployment, task sequences, drivers | [osd.md](references/osd.md) | Task sequences, boot images, variables, driver management, OSD logs |
| Collections and WQL queries | [collections.md](references/collections.md) | Membership rules, WQL queries, collection evaluation |
| PowerShell automation | [powershell.md](references/powershell.md) | Module setup, common cmdlets, client actions |
| Client issues and log files | [troubleshooting.md](references/troubleshooting.md) | Client health, common issues, log file reference |
| SSRS reports, SQL views, CMPivot | [reporting-sql.md](references/reporting-sql.md) | Built-in reports, SQL view categories, sample queries |
| SQL Server tuning for MECM | [sql-best-practices.md](references/sql-best-practices.md) | MaxDOP, memory, tempdb, maintenance plans, RCSI, AG, diagnostics |

## Scripts

All scripts write CMTrace-compatible logs. Open the resulting `.log` files with CMTrace for color-coded filtering.

| Script | Purpose |
|--------|---------|
| [Import-CMModule.ps1](scripts/Import-CMModule.ps1) | Fault-tolerant ConfigurationManager module loader. Use: `. .\scripts\Import-CMModule.ps1 -SiteCode "PS1"` |
| [Invoke-CMClientHealthCheck.ps1](scripts/Invoke-CMClientHealthCheck.ps1) | Read-only health check for a ConfigMgr client. Validates services, WMI, policy, inventory, cache, MP connectivity, disk, pending reboot. Log: `C:\Windows\CCM\Logs\ClientHealthCheck.log` |
| [Repair-WMISafely.ps1](scripts/Repair-WMISafely.ps1) | Non-destructive WMI repair. Uses `winmgmt /salvagerepository` (NOT `/resetrepository`), re-registers WMI DLLs, recompiles critical MOFs. Log: `C:\Windows\Logs\WMIRepair.log` |
| [Invoke-CMServerHealthCheck.ps1](scripts/Invoke-CMServerHealthCheck.ps1) | Read-only health check for a ConfigMgr site server. Validates SMS services, SMS Provider, site component status, inbox backlogs, disk space, SQL connectivity, recent event log errors. Log: `C:\Windows\Logs\CMServerHealthCheck.log` |

## Core Concepts

### Configuration Manager Hierarchy

**Reference**: [Design a hierarchy of sites](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/design-a-hierarchy-of-sites)

- **Central Administration Site (CAS)**: Top-level site for multi-site hierarchies (optional)
- **Primary Site**: Main administration point, hosts the database
- **Secondary Site**: Child of primary site, distributes content to remote locations

### Key Site System Roles

**Reference**: [Site system roles](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/plan-for-site-system-servers-and-site-system-roles)

- **Management Point (MP)**: Primary client-to-site communication
- **Distribution Point (DP)**: Content storage and distribution
- **Software Update Point (SUP)**: WSUS integration for patch management
- **State Migration Point**: User state storage during OSD
- **Reporting Services Point**: SSRS integration

## Best Practices

**Reference**: [Site and site system prerequisites](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/configs/site-and-site-system-prerequisites)

1. **Maintenance**: Run WSUS cleanup monthly, reindex SUSDB, monitor component status, back up site database
2. **Performance**: Limit collection incremental updates, distribute content before deployments, use boundary groups effectively
3. **Security**: Use HTTPS where possible, implement RBAC, use least-privilege service accounts
4. **Deployment**: Test in pilot collections first, use phased deployments, configure maintenance windows

## Additional Resources

- **ConfigMgr Blog**: https://techcommunity.microsoft.com/t5/Configuration-Manager-Blog/bg-p/ConfigurationManagerBlog
- **PowerShell Reference**: https://learn.microsoft.com/en-us/powershell/sccm/overview
- **Troubleshooting**: https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/welcome-configuration-manager
- **Forums**: https://learn.microsoft.com/en-us/answers/tags/417/configuration-manager
