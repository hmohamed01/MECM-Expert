# MECM Expert

A Claude Code skill that provides comprehensive Microsoft Endpoint Configuration Manager (MECM/ConfigMgr/SCCM) administration expertise.

## What is this?

This is a [Claude Code skill](https://docs.anthropic.com/en/docs/claude-code) that enhances Claude's ability to assist with enterprise MECM administration tasks. When installed, Claude gains deep knowledge of ConfigMgr concepts, PowerShell automation, and troubleshooting procedures.

## Capabilities

- **Software Update Management** - WSUS configuration, Automatic Deployment Rules (ADR), patch compliance
- **Application Deployment** - Packaging, detection methods, deployment types, supersedence
- **Operating System Deployment (OSD)** - Task sequences, boot images, driver management
- **Collection Management** - WQL queries, membership rules, evaluation optimization
- **PowerShell Automation** - ConfigurationManager module, bulk operations, scripting
- **Client Troubleshooting** - Log analysis, health checks, common issue resolution
- **Reporting** - SQL views, CMPivot, compliance reports

## Installation

Copy the `SKILL.md` file to your Claude Code skills directory:

```bash
# macOS/Linux
cp SKILL.md ~/.claude/skills/mecm-expert/SKILL.md

# Windows
copy SKILL.md %USERPROFILE%\.claude\skills\mecm-expert\SKILL.md
```

## Usage

Once installed, Claude Code will automatically use this skill when you ask about MECM/ConfigMgr topics. Example prompts:

- "Help me create a WQL query for all Windows 11 devices"
- "What's the best way to troubleshoot a failing task sequence?"
- "Create an ADR for monthly security updates"
- "Why is my ConfigMgr client not reporting?"

## Requirements

- Claude Code CLI
- No additional dependencies

## License

MIT
