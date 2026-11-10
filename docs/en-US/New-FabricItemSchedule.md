---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
itemType: Item
Locale: en-US
Module Name: FabricTools
ms.date: 11/09/2026
PlatyPS schema version: 2024-05-01
title: New-FabricItemSchedule
---

# New-FabricItemSchedule

## SYNOPSIS

Creates a schedule for a Fabric item.

## SYNTAX

```
New-FabricItemSchedule -WorkspaceId <guid> -ItemId <guid> -JobType <string>
 -ScheduleType <Cron|Daily|Weekly> [-IntervalMinutes <int>] [-Times <string[]>]
 [-Weekdays <string[]>] -StartDateTime <DateTimeOffset> -EndDateTime <DateTimeOffset>
 -TimeZone <string> [-Enabled <bool>] [-WhatIf] [-Confirm]
```

## DESCRIPTION

Creates a Cron, Daily, or Weekly schedule. Cron uses an interval in minutes;
Daily uses times; Weekly uses weekdays and times. The schedule includes a start
and end date-time and a Windows time zone ID.

## EXAMPLES

### EXAMPLE 1

```powershell
New-FabricItemSchedule -WorkspaceId '11111111-1111-1111-1111-111111111111' -ItemId '22222222-2222-2222-2222-222222222222' -JobType Pipeline -ScheduleType Daily -Times '08:00' -StartDateTime '2026-11-09T00:00:00' -EndDateTime '2026-12-31T23:59:59' -TimeZone UTC
```

## PARAMETERS

- **WorkspaceId**, **ItemId**, **JobType**: Item and job type identifiers.
- **ScheduleType**: `Cron`, `Daily`, or `Weekly`.
- **IntervalMinutes**: Required for Cron schedules.
- **Times**: Required for Daily and Weekly schedules.
- **Weekdays**: Required for Weekly schedules.
- **StartDateTime**, **EndDateTime**: Active schedule range.
- **TimeZone**: Windows time zone ID.
- **Enabled**: Create enabled (default) or disabled.
