---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
itemType: Item
Locale: en-US
Module Name: FabricTools
ms.date: 11/09/2026
PlatyPS schema version: 2024-05-01
title: Remove-FabricItemSchedule
---

# Remove-FabricItemSchedule

## SYNOPSIS

Removes a Fabric item schedule.

## SYNTAX

```
Remove-FabricItemSchedule -WorkspaceId <guid> -ItemId <guid> -JobType <string>
 -ScheduleId <guid> [-WhatIf] [-Confirm]
```

## EXAMPLES

### EXAMPLE 1

```powershell
Remove-FabricItemSchedule -WorkspaceId '11111111-1111-1111-1111-111111111111' -ItemId '22222222-2222-2222-2222-222222222222' -JobType Pipeline -ScheduleId '33333333-3333-3333-3333-333333333333'
```

## PARAMETERS

- **WorkspaceId**, **ItemId**, **JobType**, **ScheduleId**: Identifiers for the schedule to remove.
