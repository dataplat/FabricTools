---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
itemType: Core
Locale: en-US
Module Name: FabricTools
ms.date: 11/09/2026
PlatyPS schema version: 2024-05-01
title: Update-FabricConnection
---

# Update-FabricConnection

## SYNOPSIS

Updates a Fabric connection name or credentials.

## SYNTAX

```
Update-FabricConnection -ConnectionId <guid> [-ConnectionName <string>]
 [-CredentialType <string>] [-Credential <PSCredential>] [-TenantId <guid>]
 [-PrivacyLevel <string>] [-WhatIf] [-Confirm]
```

## DESCRIPTION

Changes a connection display name, replaces credentials, or both. Credential
request bodies are excluded from request-body logging.

## EXAMPLES

### EXAMPLE 1

```powershell
Update-FabricConnection -ConnectionId '11111111-1111-1111-1111-111111111111' -ConnectionName 'Updated API'
```

## PARAMETERS

- **ConnectionId**: ID of the connection to update.
- **ConnectionName**: Optional new display name.
- **CredentialType**: Replacement type: `ServicePrincipal`, `Anonymous`, or `Basic`.
- **Credential**: PSCredential containing the application ID and secret, or Basic username and password.
- **TenantId**: Required for `ServicePrincipal`.
- **PrivacyLevel**: Optional privacy level for replacement credentials.
