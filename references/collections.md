# Collection Management

**Reference**: [Collections overview](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/manage/collections/introduction-to-collections)

## Collection Types

- **Device Collections**: Target computers/devices
- **User Collections**: Target user accounts

## Membership Rules

**Reference**: [Create collections](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/manage/collections/create-collections)

**Direct Rule**: Manually add specific resources
**Query Rule**: Dynamic membership via WQL - [How to create queries](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/create-queries)
**Include Rule**: Include members from another collection
**Exclude Rule**: Exclude members from another collection

## Common WQL Queries

**Reference**: [WQL (WMI Query Language)](https://learn.microsoft.com/en-us/mem/configmgr/core/servers/manage/queries-technical-reference)

**All Windows 10/11 Workstations**:
```sql
SELECT * FROM SMS_R_System 
WHERE SMS_R_System.OperatingSystemNameandVersion LIKE "%Workstation 10%"
   OR SMS_R_System.OperatingSystemNameandVersion LIKE "%Workstation 11%"
```

**All Servers**:
```sql
SELECT * FROM SMS_R_System 
INNER JOIN SMS_G_System_SYSTEM ON SMS_G_System_SYSTEM.ResourceId = SMS_R_System.ResourceId 
WHERE SMS_G_System_SYSTEM.SystemRole = "Server"
```

**Devices by Manufacturer**:
```sql
SELECT * FROM SMS_R_System 
INNER JOIN SMS_G_System_COMPUTER_SYSTEM ON SMS_G_System_COMPUTER_SYSTEM.ResourceID = SMS_R_System.ResourceId 
WHERE SMS_G_System_COMPUTER_SYSTEM.Manufacturer LIKE "%Dell%"
```

**Devices Missing ConfigMgr Client**:
```sql
SELECT * FROM SMS_R_System 
WHERE SMS_R_System.Client = 0 OR SMS_R_System.Client IS NULL
```

**Devices by OU**:
```sql
SELECT * FROM SMS_R_System 
WHERE SMS_R_System.SystemOUName = "DOMAIN.COM/OU/SUBOU"
```

## Collection Evaluation

**Reference**: [Collection evaluation](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/manage/collections/collection-evaluation)

- **Full Update**: Complete re-evaluation of all rules
- **Incremental Update**: Delta changes only (enable cautiously) - [Best practices for collections](https://learn.microsoft.com/en-us/mem/configmgr/core/clients/manage/collections/best-practices-for-collections)
- Configure evaluation schedules to avoid performance impact
- Monitor collection evaluation with colleval.log
