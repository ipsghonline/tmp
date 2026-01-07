---
layout: default
title: Administrator Guide
parent: Technician Documentation
nav_order: 3
---

# Windows Device Migration Administrator Guide

<span style="background: #dc3545; color: white; padding: 0.25rem 0.5rem; border-radius: 4px; font-size: 0.875rem;">Admin</span>
<span style="background: #17a2b8; color: white; padding: 0.25rem 0.5rem; border-radius: 4px; font-size: 0.875rem;">~20 min read</span>

Quick reference guide for IT administrators managing Windows device migrations.

<p style="margin: 1.5rem 0;">
<a href="../../Windows_Device_Migration_Administrator_Guide.html" style="display: inline-block; padding: 0.75rem 1.5rem; background-color: #dc3545; color: white; text-decoration: none; border-radius: 6px; font-weight: bold;">
Open Administrator Guide →
</a>
</p>

---

## Overview

Concise administrator reference for managing the Windows device migration process, including Dell pre-provisioning shortcuts and Autopilot enrollment procedures.

## The 7 Admin Phases

| Phase                 | Description          | Admin Actions              |
| --------------------- | -------------------- | -------------------------- |
| **1. Pre-Deployment** | Device preparation   | Verify Intune registration |
| **2. Initial Setup**  | Network and power    | Monitor connectivity       |
| **3. Registration**   | Autopilot assignment | Confirm profile applied    |
| **4. ESP**            | App deployment       | Monitor installation       |
| **5. Verification**   | Validation           | Run compliance check       |
| **6. Manual Config**  | Additional setup     | Apply custom settings      |
| **7. Handoff**        | Completion           | Document and close         |

## Dell Pre-Provisioning

For Dell devices with factory pre-provisioning enabled:

1. Skip standard OOBE steps
2. Device auto-enrolls via hardware hash
3. Reduced setup time (~30 min vs ~90 min)
4. Apps pre-staged during manufacturing

**Requirements:**

- Dell device with Autopilot pre-registration
- Hardware hash uploaded to Intune
- Pre-provisioning profile assigned

## Admin Portal Access

| Portal            | URL                    | Purpose                  |
| ----------------- | ---------------------- | ------------------------ |
| **Intune**        | endpoint.microsoft.com | Device management        |
| **Azure AD**      | portal.azure.com       | User/identity management |
| **Microsoft 365** | admin.microsoft.com    | Licensing                |

## Key Verification Commands

```powershell
# Check Autopilot profile
Get-AutopilotDiagnostics

# Verify Intune enrollment
dsregcmd /status

# Check compliance status
Get-IntuneDeviceCompliancePolicy
```

---

## Batch Deployment Tips

- Group devices by department for profile assignment
- Schedule deployments during off-hours
- Monitor Intune dashboard for failures
- Have backup devices ready for critical users

---

[Open Full Administrator Guide →](../../Windows_Device_Migration_Administrator_Guide.html)
