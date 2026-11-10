---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
itemType: Item
Locale: en-US
Module Name: FabricTools
ms.date: 11/09/2026
PlatyPS schema version: 2024-05-01
title: Get-FabricItemSchedule
---

# Get-FabricItemSchedule

## SYNOPSIS

Gets the schedules for a Fabric item.

## SYNTAX

```
Get-FabricItemSchedule -WorkspaceId <guid> -ItemId <guid> -JobType <string>
```

## DESCRIPTION

Lists schedules for an item and job type.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-FabricItemSchedule -WorkspaceId '11111111-1111-1111-1111-111111111111' -ItemId '22222222-2222-2222-2222-222222222222' -JobType Pipeline
```

## PARAMETERS

- **WorkspaceId**: ID of the workspace containing the item.
- **ItemId**: ID of the item.
- **JobType**: Job type such as `Pipeline` or `RunNotebook`.
