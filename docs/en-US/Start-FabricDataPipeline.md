---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
itemType: Data Pipeline
Locale: en-US
Module Name: FabricTools
ms.date: 11/09/2026
PlatyPS schema version: 2024-05-01
title: Start-FabricDataPipeline
---

# Start-FabricDataPipeline

## SYNOPSIS

Starts a data pipeline in Microsoft Fabric.

## SYNTAX

```
Start-FabricDataPipeline -WorkspaceId <guid> -DataPipelineId <guid>
 [-Parameters <hashtable>] [-NoWait] [-WhatIf] [-Confirm]
Start-FabricDataPipeline -WorkspaceId <guid> -DataPipelineName <string>
 [-Parameters <hashtable>] [-NoWait] [-WhatIf] [-Confirm]
```

## DESCRIPTION

Submits a Pipeline job, optionally passes `executionData.parameters`, and waits
for completion by default. Pipeline names must match exactly one item in the
workspace. Polling honors `Retry-After`.

## EXAMPLES

### EXAMPLE 1

```powershell
Start-FabricDataPipeline -WorkspaceId '11111111-1111-1111-1111-111111111111' -DataPipelineName 'Daily load'
```

### EXAMPLE 2

```powershell
$parameters = @{ loadDate = '2026-11-09' }
Start-FabricDataPipeline -WorkspaceId '11111111-1111-1111-1111-111111111111' -DataPipelineId '22222222-2222-2222-2222-222222222222' -Parameters $parameters -NoWait
```

## PARAMETERS

- **WorkspaceId**: ID of the workspace containing the pipeline.
- **DataPipelineId**: Pipeline ID. Mutually exclusive with `DataPipelineName`.
- **DataPipelineName**: Exact pipeline display name.
- **Parameters**: Hashtable passed as `executionData.parameters`.
- **NoWait**: Return the current job instance without waiting for completion.
