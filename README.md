# MECM Expert

A Claude Code skill that provides comprehensive Microsoft Endpoint Configuration Manager (MECM/ConfigMgr/SCCM) administration expertise.

> **Note:** This skill works with both **Claude Code CLI** and **claude.ai**. For claude.ai, simply zip this repository and upload it as a skill in the capabilities section of your settings.

## What is this?

This is a [Claude Code skill](https://docs.anthropic.com/en/docs/claude-code) that enhances Claude's ability to assist with enterprise MECM administration tasks. When installed, Claude gains deep knowledge of ConfigMgr concepts, PowerShell automation, and troubleshooting procedures.

## Capabilities

- **Software Update Management** - WSUS configuration, Automatic Deployment Rules (ADR), patch compliance
- **Application Deployment** - Packaging, detection methods, deployment types, supersedence
- **Operating System Deployment (OSD)** - Task sequences, boot images, driver management
- **Collection Management** - WQL queries, membership rules, evaluation optimization
- **PowerShell Automation** - ConfigurationManager module, bulk operations, scripting
- **Client Troubleshooting** - Log analysis, health checks, common issue resolution
- **Reporting & SQL Views** - Comprehensive SQL Server views reference (20+ view categories), CMPivot, custom SSRS reports, compliance reporting
- **Live Documentation Fetching** - Automatically retrieves current Microsoft documentation for accurate cmdlet syntax, troubleshooting steps, and version-specific features

## Installation

Copy the `SKILL.md` file to your Claude Code skills directory:

**macOS/Linux:**
```bash
mkdir -p ~/.claude/skills/mecm-expert
```
```bash
cp SKILL.md ~/.claude/skills/mecm-expert/SKILL.md
```

**Windows (PowerShell):**
```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills\mecm-expert"
```
```powershell
Copy-Item SKILL.md "$env:USERPROFILE\.claude\skills\mecm-expert\SKILL.md"
```

## Usage

Once installed, Claude Code will automatically use this skill when you ask about MECM/ConfigMgr topics. Example prompts:

- "Help me create a WQL query for all Windows 11 devices"
- "What's the best way to troubleshoot a failing task sequence?"
- "Create an ADR for monthly security updates"
- "Why is my ConfigMgr client not reporting?"
- "Write a SQL query to show software update compliance by collection"
- "Which SQL views should I use to build a hardware inventory report?"

## Documentation References

This skill includes **130+ inline reference URLs** to official Microsoft documentation, ensuring accuracy and enabling deep-dives into specific topics.

### Live Documentation Fetching

Claude will automatically fetch live content from Microsoft Learn when you ask about:
- **PowerShell cmdlets** - Gets current syntax, parameters, and examples
- **Troubleshooting** - Retrieves latest resolution steps for errors
- **Version-specific features** - Confirms feature availability in your ConfigMgr version
- **SQL view schemas** - Fetches accurate column names and join relationships

This ensures responses reflect the most current Microsoft documentation rather than potentially outdated information.

### Key Reference Areas

- [Configuration Manager Documentation](https://learn.microsoft.com/en-us/mem/configmgr/)
- [SQL Server Views Reference](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sql-server-views-configuration-manager) - 20+ view categories with sample queries
- [PowerShell Cmdlet Reference](https://learn.microsoft.com/en-us/powershell/module/configurationmanager/)
- [Troubleshooting Guide](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/)
- [Log Files Reference](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/hierarchy/log-files)

## Requirements

- Claude Code CLI
- No additional dependencies

## License

MIT
