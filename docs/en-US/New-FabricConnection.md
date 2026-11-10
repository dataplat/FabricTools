---
document type: cmdlet
external help file: FabricTools-Help.xml
HelpUri: ''
itemType: Core
Locale: en-US
Module Name: FabricTools
ms.date: 11/09/2026
PlatyPS schema version: 2024-05-01
title: New-FabricConnection
---

# New-FabricConnection

## SYNOPSIS

Creates a cloud Web connection in Microsoft Fabric.

## SYNTAX

```
New-FabricConnection -ConnectionName <string> -BaseUrl <uri> -Audience <string>
 -CredentialType <string> [-Credential <PSCredential>] [-TenantId <guid>]
 [-PrivacyLevel <string>] [-SkipTestConnection] [-WhatIf] [-Confirm]
```

## DESCRIPTION

Creates a ShareableCloud WebForPipeline connection. Service principal and Basic
credentials are supplied as a PSCredential; the credential username is the
application ID for service principal authentication. Credentials are excluded
from request-body logging.

## EXAMPLES

### EXAMPLE 1

```powershell
$credential = Get-Credential
New-FabricConnection -ConnectionName 'FUAM API' -BaseUrl 'https://api.contoso.com' -Audience 'api://contoso' -CredentialType ServicePrincipal -TenantId '11111111-1111-1111-1111-111111111111' -Credential $credential
```

## PARAMETERS

- **ConnectionName**: Display name for the connection.
- **BaseUrl**: Absolute HTTPS Web connection base URL.
- **Audience**: Web connection audience.
- **CredentialType**: `ServicePrincipal`, `Anonymous`, or `Basic`.
- **Credential**: PSCredential containing the application ID and secret, or Basic username and password.
- **TenantId**: Required for `ServicePrincipal`.
- **PrivacyLevel**: Optional `None`, `Public`, `Organizational`, or `Private` privacy level.
- **SkipTestConnection**: Skip testing the connection when creating it.
