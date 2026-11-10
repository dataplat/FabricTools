---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
itemType: Item
Locale: en-US
Module Name: FabricTools
ms.date: 11/09/2026
PlatyPS schema version: 2024-05-01
title: Update-FabricItemSchedule
---

# Update-FabricItemSchedule

## SYNOPSIS

Updates a Fabric item schedule.

## SYNTAX

```
Update-FabricItemSchedule -WorkspaceId <guid> -ItemId <guid> -JobType <string>
 -ScheduleId <guid> [-Enabled <bool>] [-ScheduleType <Cron|Daily|Weekly>]
 [-IntervalMinutes <int>] [-Times <string[]>] [-Weekdays <string[]>]
 [-StartDateTime <DateTimeOffset>] [-EndDateTime <DateTimeOffset>]
 [-TimeZone <string>] [-WhatIf] [-Confirm]
```

## DESCRIPTION

Enables or disables a schedule and optionally updates its configuration or date
range. Configuration changes require the complete configuration for the selected type.

## EXAMPLES

### EXAMPLE 1

```powershell
Update-FabricItemSchedule -WorkspaceId '11111111-1111-1111-1111-111111111111' -ItemId '22222222-2222-2222-2222-222222222222' -JobType Pipeline -ScheduleId '33333333-3333-3333-3333-333333333333' -Enabled $false
```

## PARAMETERS

- **WorkspaceId**, **ItemId**, **JobType**, **ScheduleId**: Schedule identifiers.
- **Enabled**: Enable or disable the schedule.
- **ScheduleType**: Replacement configuration type.
- **IntervalMinutes**, **Times**, **Weekdays**: Recurrence settings.
- **StartDateTime**, **EndDateTime**, **TimeZone**: Updated date range and time zone.
