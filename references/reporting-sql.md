# Reporting and SQL Views

**Reference**: [Introduction to reporting](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/introduction-to-reporting)

## Table of Contents

- [Built-in Reports](#built-in-reports)
- [Custom Reports](#custom-reports)
- [SQL View Categories](#sql-view-categories)
- [Sample Queries by Category](#sample-queries-by-category)
- [Common SQL Views Quick Reference](#common-sql-views-quick-reference)

## Built-in Reports

**Reference**: [List of reports](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/list-of-reports)

ConfigMgr includes 400+ built-in SSRS reports:
- Hardware inventory
- Software inventory
- Software updates compliance
- Application deployment status
- Task sequence deployment status

## Custom Reports

Create custom reports using:
- SQL Server Reporting Services - [Creating custom report models](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/creating-custom-report-models-in-sql-server-reporting-services)
- CMPivot for real-time queries - [CMPivot overview](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/cmpivot-overview)
- Power BI integration - [Power BI sample reports](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/powerbi-sample-reports)

## SQL View Categories

**Official SQL Views Documentation**: https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sql-server-views-configuration-manager

Configuration Manager SQL Server views provide a faster path to data than using WMI/WQL directly.

| Category | Documentation URL | Purpose |
|----------|-------------------|---------|
| Schema Views | [schema-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/schema-views-configuration-manager) | View schema information and metadata |
| Discovery Views | [discovery-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/discovery-views-configuration-manager) | System, user, and group resources |
| Inventory Views | [inventory-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/inventory-views-configuration-manager) | General inventory information |
| Hardware Inventory Views | [hardware-inventory-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/hardware-inventory-views-configuration-manager) | Hardware inventory data (v_GS_* views) |
| Software Inventory Views | [software-inventory-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/software-inventory-views-configuration-manager) | Software inventory and file collection |
| Collection Views | [collection-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/collection-views-configuration-manager) | Collections, membership rules, members |
| Application Management Views | [app-management-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/application-management-views-configuration-manager) | Applications, packages, deployments |
| Software Updates Views | [software-updates-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/software-updates-views-configuration-manager) | Updates metadata, groups, compliance |
| Software Metering Views | [software-metering-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/software-metering-views-configuration-manager) | Software usage metering |
| Content Management Views | [content-management-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/content-management-views-configuration-manager) | Content distribution and DPs |
| Compliance Settings Views | [compliance-settings-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/compliance-settings-views-configuration-manager) | Configuration items, baselines |
| OSD Views | [osd-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/operating-system-deployment-views-configuration-manager) | Boot images, OS images, task sequences |
| Endpoint Protection Views | [endpoint-protection-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/endpoint-protection-views-configuration-manager) | Antimalware status, malware activity |
| Client Status Views | [client-status-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/client-status-views-configuration-manager) | Client health and deployment status |
| Status and Alert Views | [status-alert-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/status-alert-views-configuration-manager) | Component, site, site system status |
| Site Administration Views | [site-admin-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/site-admin-views-configuration-manager) | Site config, boundaries, site systems |
| Security Views | [security-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/security-views-configuration-manager) | User permissions and RBAC |
| Query Views | [query-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/query-views-configuration-manager) | Saved queries in the hierarchy |
| MDM Views | [mdm-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/mobile-device-management-views-configuration-manager) | Mobile device config and inventory |
| Wake On LAN Views | [wol-views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/wake-lan-views-configuration-manager) | WOL enabled objects and clients |

## Sample Queries by Category

Microsoft provides sample SQL queries for each view category:
- [Sample queries for discovery](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-discovery-configuration-manager)
- [Sample queries for hardware inventory](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-hardware-inventory-configuration-manager)
- [Sample queries for software inventory](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-software-inventory-configuration-manager)
- [Sample queries for software updates](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-software-updates-configuration-manager)
- [Sample queries for software metering](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-software-metering-configuration-manager)
- [Sample queries for compliance settings](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-compliance-settings-configuration-manager)
- [Sample queries for OSD](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-operating-system-deployment-configuration-manager)
- [Sample queries for endpoint protection](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-endpoint-protection-configuration-manager)
- [Sample queries for client status](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-client-status-configuration-manager)
- [Sample queries for status and alerts](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-status-alerts-configuration-manager)
- [Sample queries for asset intelligence](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-asset-intelligence-configuration-manager)
- [Sample queries for Wake On LAN](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/sample-queries-wake-lan-views-configuration-manager)

For guidance on building custom SSRS reports using SQL views:
- [Create custom reports by using SQL Server views](https://learn.microsoft.com/en-us/mem/configmgr/develop/core/understand/sqlviews/create-custom-reports-using-sql-server-views)

## Common SQL Views Quick Reference

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
