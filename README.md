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

## Installation

Copy the `SKILL.md` file to your Claude Code skills directory:

**macOS/Linux:**
```bash
cp SKILL.md ~/.claude/skills/mecm-expert/SKILL.md
```

**Windows:**
```cmd
copy SKILL.md %USERPROFILE%\.claude\skills\mecm-expert\SKILL.md
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

This skill includes references to official Microsoft documentation:

- [Configuration Manager Documentation](https://learn.microsoft.com/en-us/intune/configmgr/)
- [SQL Server Views Reference](https://learn.microsoft.com/en-us/intune/configmgr/develop/core/understand/sqlviews/sql-server-views-configuration-manager) - 20+ view categories with sample queries
- [PowerShell Reference](https://learn.microsoft.com/en-us/powershell/sccm/overview)
- [Troubleshooting Guide](https://learn.microsoft.com/en-us/troubleshoot/mem/configmgr/welcome-configuration-manager)

## Requirements

- Claude Code CLI
- No additional dependencies

## License

MIT
