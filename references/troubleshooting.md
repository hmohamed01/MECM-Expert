# Client Troubleshooting

**Reference**: [Monitor clients](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/manage/monitor-clients)

## Client Health Checks

**Reference**: [Client health](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/manage/monitor-clients#client-health)

ConfigMgr client performs automatic health checks:
- Client installation verification
- WMI repository integrity
- Required services running (CcmExec, WMI, WUA)
- Antimalware service status

Location: `C:\Windows\CCM\CcmEval.xml`

## Key Client Logs

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

## Common Issues and Resolution

**Reference**: [Configuration Manager troubleshooting](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/welcome-configuration-manager)

**Client Not Reporting** - [Client installation properties](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/deploy/about-client-installation-properties):
1. Verify CcmExec service is running
2. Check ClientIDManagerStartup.log for registration errors
3. Verify network connectivity to MP
4. Check certificates if using HTTPS

**Content Download Failures** - [Troubleshoot content distribution](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/content-management/troubleshoot-content-distribution):
1. Check CAS.log and ContentTransferManager.log
2. Verify DP availability
3. Check boundary configuration - [Configure boundaries](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/deploy/configure/define-site-boundaries-and-boundary-groups)
4. Verify client cache size

**Policy Not Updating** - [Clients don't receive policy data](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/client-management/clients-not-receive-policy-data):
1. Run Machine Policy Retrieval cycle
2. Check PolicyAgent.log
3. Verify MP health
4. Check client assignment

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
