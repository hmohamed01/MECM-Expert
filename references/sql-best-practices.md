# SQL Server Best Practices for MECM

Best practices from the [SQL recommendations for MECM white paper](https://github.com/stephaneserero/Sql-recommendations-for-MECM) by Microsoft consultants (Stephane Serero, Frederic Michalak, Justin Manning, Ryad Ben Salah).

## Table of Contents

- [Instance Settings](#instance-settings)
- [Database Settings](#database-settings)
- [Global Settings](#global-settings)
- [Maintenance Plans](#maintenance-plans)
- [Virtualization and Sizing](#virtualization-and-sizing)
- [WSUS Database](#wsus-database)
- [Always On Availability Groups](#always-on-availability-groups)
- [Diagnostic Queries](#diagnostic-queries)

## Instance Settings

### MaxDOP (Max Degree of Parallelism)

Default is 0 (all cores). MECM Product Group recommends **0** for most environments, but adjust based on CxPacket wait analysis.

```sql
-- Check current MaxDOP
SELECT name, value FROM sys.configurations WHERE name = 'max degree of parallelism'

-- Set MaxDOP (example: set to 0)
EXEC sp_configure 'max degree of parallelism', 0
GO
RECONFIGURE
GO
```

**Monitoring**: If CxPacket is the top wait type with high wait_time_ms, decrease MaxDOP to 8, 4, 2, or 1.

```sql
-- Check top wait stats
SELECT TOP 10 * FROM sys.dm_os_wait_stats ORDER BY wait_time_ms DESC
```

> SQL Server 2016 SP2+ / 2017 CU3+: CXPACKET split into actionable CXPACKET and negligible CXCONSUMER.

### Memory Configuration

Reserve memory for the OS; don't let SQL consume everything.

| Total Memory | SQL Collocated with MECM | SQL Dedicated |
|---|---|---|
| <= 16 GB | Leave 4-8 GB for system | Leave 2-4 GB for system |
| 16-64 GB | 50-60% for SQL | 70-80% for SQL |
| >= 64 GB | 65-75% for SQL | 80-95% for SQL |

```sql
-- Check current memory settings
SELECT name, value FROM sys.configurations
WHERE name IN ('max server memory (MB)', 'min server memory (MB)')

-- Configure (example: 28 GB max, 8 GB min)
EXEC sp_configure 'max server memory (MB)', 28672
GO
EXEC sp_configure 'min server memory (MB)', 8192
GO
RECONFIGURE WITH OVERRIDE
GO
```

**Minimum Server Memory**: Set to 8 GB on large servers, 4-8 GB on servers with <= 16 GB.

### Collation

Required collation: **SQL_Latin1_General_CP1_CI_AS**. Deviating puts MECM in an unsupported state.

```sql
-- Check current collation
SELECT SERVERPROPERTY('Collation')
```

### Additional Instance Settings

**CLR Enabled**: Required — Management Point Control Manager uses CLR.
**Max text repl size**: Set to 2 GB for replica Management Point scenarios.

```sql
-- Check CLR and max text repl size
SELECT name, value FROM sys.configurations
WHERE name IN ('CLR Enabled', 'max text repl size (B)')
```

### Trace Flags (pre-SQL 2016)

- **TF 1117**: All tempdb files autogrow together
- **TF 1118**: Allocate uniform extents, avoiding mixed extent contention

> SQL Server 2016+: These are superseded by AUTOGROW_ALL_FILES and MIXED_PAGE_ALLOCATION options.

```sql
-- Check active trace flags
DBCC TRACESTATUS(-1)
```

### Local Security Policies

Apply to the SQL service engine account:
- **Lock Pages in Memory**: Prevents SQL memory from being paged to disk
- **Perform Volume Maintenance Task**: Enables Instant File Initialization (IFI) for faster data file operations

> SQL Server 2016+: IFI can be enabled during setup via "Grant Perform Volume Maintenance Task" checkbox.

## Database Settings

### TempDB Configuration

Host tempdb data files on a **dedicated volume**. Key rules:

1. **File count**: Match logical processors up to 8; if > 8 processors, start with 8 files and increase by 4 if contention continues
2. **File sizing**: All files must be equal size with equal autogrowth
3. **Autogrowth**: Start at 512 MB per file (not percentage-based)
4. **Initial size**: Dedicate 80-90% of the tempdb volume across files, or 20-30% of total database size

```sql
-- Check current tempdb configuration
USE tempdb
GO
SELECT name, type_desc AS File_type,
    size*8/1024 AS Current_Size_MB,
    is_percent_growth,
    CASE is_percent_growth
        WHEN 1 THEN size*8/1024*growth/100
        ELSE growth*8/1024
    END AS Next_growth_MB
FROM sys.database_files WHERE type = 0
```

### Database Compatibility Level

After SQL upgrades, the new Cardinality Estimator may cause performance issues with MECM queries.

| SQL Server Version | Default Level | Recommended for MECM | Fallback for Perf Issues |
|---|---|---|---|
| SQL Server 2017 | 140 | 140 | 110 |
| SQL Server 2016 | 130 | 130 | 110 |
| SQL Server 2014 | 120 | 110 | 110 |

```sql
-- Check compatibility levels
SELECT name, compatibility_level FROM sys.databases

-- Set compatibility level (example)
ALTER DATABASE <CM_DB> SET COMPATIBILITY_LEVEL = 130
```

### Read Committed Snapshot Isolation (RCSI)

Enable if experiencing blocking/locking issues. Uses tempdb version store to avoid reader-writer contention.

```sql
-- Check current setting
SELECT name, is_read_committed_snapshot_on FROM sys.databases

-- Enable RCSI (requires exclusive DB access — terminates all connections)
ALTER DATABASE <CM_DB> SET READ_COMMITTED_SNAPSHOT ON WITH ROLLBACK IMMEDIATE
```

## Global Settings

### Optimize for Ad Hoc Workloads

Prevents plan cache bloat from single-use ad hoc queries by caching a stub instead of the full plan.

```sql
-- Check current setting
SELECT name, value FROM sys.configurations WHERE name = 'optimize for ad hoc workloads'

-- Enable
EXEC sp_configure 'optimize for ad hoc workloads', 1
GO
RECONFIGURE
GO
```

```sql
-- Check for single-use plan cache bloat
SELECT objtype, cacheobjtype, AVG(usecounts) AS Avg_UseCount,
    SUM(refcounts) AS AllRefObjects,
    SUM(CAST(size_in_bytes AS bigint))/1024/1024 AS Size_MB
FROM sys.dm_exec_cached_plans
WHERE objtype = 'Adhoc' AND usecounts = 1
GROUP BY objtype, cacheobjtype
```

### Forced Parameterization

May reduce CPU usage for large ad hoc workloads by improving plan reuse. Use with caution — MECM workload is heterogeneous and this can help one scenario at the expense of another. Monitor closely with your DBA.

```sql
-- Check current setting
SELECT name, is_parameterization_forced FROM sys.databases WHERE name = '<CM_DB>'

-- Enable (use cautiously)
ALTER DATABASE <CM_DB> SET PARAMETERIZATION FORCED WITH NO_WAIT
```

## Maintenance Plans

### Recommended Sequence

1. **DBCC CHECKDB** — integrity check (ideally daily)
2. **Rebuild Indexes** — defragment indexes
3. **Update Statistics** — refresh query optimizer data
4. **Full Backup** — database backup
5. **Cleanup** — backup retention

Apply to MECM databases AND system databases (master, model, msdb).

### Integrity Check (DBCC CHECKDB)

```sql
-- Check all databases
EXEC sp_MSforeachdb 'USE ?; DBCC CHECKDB (?)'

-- Parallelized check (SQL 2014 SP2+) for large databases
DBCC CHECKDB(<DatabaseName>) WITH MAXDOP = <number_of_processors>

-- Lightweight check for large databases between full checks
DBCC CHECKDB(<DatabaseName>) WITH PHYSICAL_ONLY

-- Last successful CHECKDB date
SELECT DATABASEPROPERTYEX('<DatabaseName>', 'LastGoodCheckDbTime')
```

### Index Maintenance

```sql
-- Check top 20 fragmented indexes
SELECT TOP 20
    OBJECT_NAME(si.object_id) AS TableName,
    si.name AS IndexName, si.index_id,
    ips.index_type_desc, ips.avg_fragmentation_in_percent, ips.page_count
FROM sys.indexes si
CROSS APPLY sys.dm_db_index_physical_stats(DB_ID(), si.object_id, si.index_id, NULL, 'LIMITED') ips
ORDER BY ips.avg_fragmentation_in_percent DESC
```

- SQL 2016+ maintenance plans support fragmentation threshold and minimum page count filters
- Consider [Ola Hallengren's Maintenance Solution](https://ola.hallengren.com/) for production-grade index and statistics maintenance
- Rebuild only applies to clustered/non-clustered indexes, not heaps

### Change Tracking Cleanup

MECM uses SQL Change Tracking. Default retention is 5 days. Monitor with:

```sql
SELECT * FROM sys.change_tracking_databases
```

## Virtualization and Sizing

### VM Best Practices

- **CPU**: Do not overcommit CPU. Use CPU-affinity settings if sharing physical host
- **Memory**: Reserve all guest memory (no ballooning/dynamic memory)
- **Storage**: Use thick provisioning (eager zeroed) for data/log/tempdb volumes
- **NUMA**: Align VM sockets/cores to physical NUMA boundaries

### Site Sizing

Reference: [MECM site sizing and performance guidelines](https://learn.microsoft.com/en-us/mem/configmgr/core/plan-design/configs/site-size-performance-guidelines)

## WSUS Database

### SUSDB Maintenance

WSUS database requires the same maintenance as MECM databases:
- Regular index rebuilds
- Statistics updates
- DBCC CHECKDB

### MECM WSUS Cleanup (v1906+)

MECM can automate WSUS cleanup tasks:
- Decline expired/superseded updates
- Remove obsolete updates from WSUS
- Add non-clustered indexes to SUSDB for performance

### Rebuilding WSUS

If WSUS is severely degraded, consider rebuilding:
1. Remove SUP role from MECM
2. Uninstall WSUS
3. Drop SUSDB
4. Reinstall WSUS with a fresh database
5. Re-add SUP role to MECM

### Shared SUSDB

When multiple SUPs share a WSUS database, ensure all SUPs point to the same SQL instance and database name.

## Always On Availability Groups

MECM supports SQL Always On AG for site database high availability.

Key considerations:
- All replicas must use the same SQL Server version and collation
- Synchronous commit mode is required for the primary and sync replica
- Manual failover is recommended (automatic failover is supported but requires testing)
- MECM does not support readable secondary replicas for the site database

Reference: [Prepare to use an Always On availability group](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/deploy/configure/sql-server-alwayson-for-a-highly-available-site-database)

## Diagnostic Queries

### Quick Health Check

```sql
-- All key instance settings at a glance
SELECT name, value, value_in_use FROM sys.configurations
WHERE name IN (
    'max degree of parallelism',
    'max server memory (MB)',
    'min server memory (MB)',
    'optimize for ad hoc workloads',
    'CLR Enabled',
    'max text repl size (B)'
)
```

### Database Settings Check

```sql
-- MECM database settings
SELECT name, compatibility_level, collation_name,
    is_read_committed_snapshot_on, is_parameterization_forced
FROM sys.databases
WHERE name LIKE 'CM_%' OR name = 'SUSDB'
```

### Antivirus Exclusions

Exclude these paths/processes from antivirus scanning on the SQL Server:
- SQL Server data files (*.mdf, *.ndf, *.ldf)
- SQL Server backup files (*.bak, *.trn)
- SQL Server executables (sqlservr.exe, sqlagent.exe, SQLPS.exe)
- Full-text catalog files
- Tempdb files
- SQL Server Reporting Services files
