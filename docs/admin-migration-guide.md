---
title: Windows Device Migration Administrator Guide
nav_order: 1
parent: Technician Documentation
---

# ILG Windows Device Migration - Administrator Guide

**Pinnacle to Impact M365 Tenant Migration**

Comprehensive guide for administrators performing Windows device migration tasks

---

## Table of Contents

1. [Overview](#1-overview)
2. [Prerequisites & Access Requirements](#2-prerequisites--access-requirements)
3. [Phase 1: Pre-Migration Tasks (Pinnacle Tenant - Source)](#3-phase-1-pre-migration-tasks-pinnacle-tenant---source)
4. [Phase 2: Pre-Migration Tasks (Impact Tenant - Destination)](#4-phase-2-pre-migration-tasks-impact-tenant---destination)
5. [Phase 3: Migration Execution](#5-phase-3-migration-execution)
6. [Phase 4: Post-Migration Tasks](#6-phase-4-post-migration-tasks)
7. [Troubleshooting](#7-troubleshooting)
8. [Scripts Reference](#8-scripts-reference)
9. [Key Contacts](#9-key-contacts)

---

## 1. Overview

This guide provides comprehensive step-by-step instructions for administrators performing the Windows device migration from Pinnacle ILG (Interior Logic Group) to Impact Property Solutions' Microsoft 365 tenant. This migration involves 193 Windows devices and requires coordination between Pinnacle and Impact administrators.

> **Migration Type:** Tenant-to-tenant migration with device wipe and Autopilot re-enrollment. Devices are wiped from Pinnacle tenant and re-enrolled in Impact tenant using Windows Autopilot.

### Migration Administrators

#### Impact Tenant Administrator

**Suleman Manji**

Email: `smanji@viyu.net`

**Responsibilities:**

- Impact tenant preparation
- User account creation
- Autopilot profile setup
- Hardware hash import
- Intune configuration
- Device enrollment verification

#### Pinnacle/ILG Tenant Administrator

**Willie Dallas**

Email: `willie.dallas@ilginc.com`

**Responsibilities:**

- Hardware hash export
- Autopilot configuration export
- Intune configuration export
- Device inventory
- Device wipe coordination

### Migration Scope

- **Total Devices:** 193 Windows devices
- **Source Tenant:** Pinnacle ILG M365 tenant
- **Destination Tenant:** Impact Property Solutions M365 tenant
- **Migration Method:** Device wipe + Autopilot re-enrollment
- **Timeline:** 60-day migration window

### Migration Phases

| Phase                                 | Description                                                                                       |
| ------------------------------------- | ------------------------------------------------------------------------------------------------- |
| **Phase 1: Pre-Migration (Pinnacle)** | Export hardware hashes, Autopilot configuration, and Intune settings from Pinnacle tenant         |
| **Phase 2: Pre-Migration (Impact)**   | Prepare Impact tenant: user creation, Autopilot setup, hardware hash import, Intune configuration |
| **Phase 3: Migration Execution**      | Device wipe, transfer, and Autopilot re-enrollment in Impact tenant                               |
| **Phase 4: Post-Migration**           | Verification, user affinity assignment, application deployment, and cleanup                       |

---

## 2. Prerequisites & Access Requirements

### Migration Administrators

The following administrators are responsible for performing migration tasks on their respective tenants:

| Administrator     | Organization  | Email                      | Responsible For                                                                                                                          |
| ----------------- | ------------- | -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| **Suleman Manji** | Impact Floors | `smanji@viyu.net`          | Impact tenant preparation, Autopilot setup, hardware hash import, Intune configuration, device enrollment verification                   |
| **Willie Dallas** | ILG/Pinnacle  | `willie.dallas@ilginc.com` | Pinnacle tenant exports, hardware hash collection, Autopilot configuration export, Intune configuration export, device wipe coordination |

### Required Azure AD Roles

Each administrator must have the following roles in their respective tenant:

| Role                     | Required For                                         | Tenant                   |
| ------------------------ | ---------------------------------------------------- | ------------------------ |
| **Global Administrator** | App Registration, Autopilot profile creation         | Both (Impact & Pinnacle) |
| **Intune Administrator** | Intune configuration, device management, device wipe | Both (Impact & Pinnacle) |
| **Device Administrator** | Device management operations                         | Both (Impact & Pinnacle) |

> **Note:** Suleman Manji performs all tasks in the Impact tenant. Willie Dallas performs all tasks in the Pinnacle/ILG tenant. Coordination between administrators is required for device wipe and transfer phases.

### PowerShell Modules

Install required PowerShell modules:

```powershell
# Set execution policy
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned

# Core Microsoft Graph modules
Install-Module Microsoft.Graph -Scope CurrentUser -Force
Install-Module Microsoft.Graph.DeviceManagement -Scope CurrentUser -Force
Install-Module Microsoft.Graph.Beta.Devices.CorporateManagement -Scope CurrentUser -Force

# Autopilot script
Install-Script -Name Get-WindowsAutopilotInfo -Force

# Verify installation
Get-Module -ListAvailable | Where-Object {$_.Name -like "Microsoft.Graph*"}
Get-InstalledScript -Name Get-WindowsAutopilotInfo
```

### Azure AD App Registration

For automated scripts, create an App Registration with the following permissions:

- `Device.ReadWrite.All`
- `DeviceManagementManagedDevices.ReadWrite.All`
- `DeviceManagementConfiguration.ReadWrite.All`
- `User.Read.All`
- `Group.Read.All`
- `Directory.Read.All`

> **Important:** All permissions require Admin Consent. Use the `Setup-AppRegistration.ps1` script for interactive setup.

---

## 3. Phase 1: Pre-Migration Tasks (Pinnacle Tenant - Source)

**Administrator:** Willie Dallas (willie.dallas@ilginc.com)

These tasks are performed by the Pinnacle/ILG administrator to export device information and configuration for migration to Impact tenant.

### 3.1 Export Hardware Hashes

Hardware hashes are unique identifiers for each device required for Autopilot registration in the destination tenant.

#### Method 1: Export from Intune (Recommended)

**Script:** `A1-AutopilotDevices.ps1`
**Location:** `1.pinnacle/Scripts/Autopilot-Intune/`

```powershell
# Connect to Pinnacle tenant
Connect-MgGraph -Scopes DeviceManagementConfiguration.Read.All

# Export Autopilot devices
.\A1-AutopilotDevices.ps1 `
    -OutputPath "C:\Exports\Intune" `
    -IncludeAllDevices
```

#### Method 2: Collect from Individual Devices

**Script:** `A2-HardwareHashes.ps1`
**Location:** `1.pinnacle/Scripts/Autopilot-Intune/`

Run on each device to collect hardware hash:

```powershell
# Run on each Windows device
.\A2-HardwareHashes.ps1 `
    -OutputPath "C:\Exports" `
    -GroupTag "Pinnacle-Migration"
```

> **Output:** Hardware hashes will be exported to CSV format. Save this file securely and provide to Impact administrators.

### 3.2 Export Autopilot Configuration

Export Autopilot profiles and device assignments from Pinnacle tenant.

**Script:** `A3-AutopilotProfiles.ps1`
**Location:** `1.pinnacle/Scripts/Autopilot-Intune/`

```powershell
# Export Autopilot profiles
.\A3-AutopilotProfiles.ps1 `
    -OutputPath "C:\Exports\Intune"
```

#### Export Device Group Tags

**Script:** `A4-DeviceGroupTags.ps1`

```powershell
.\A4-DeviceGroupTags.ps1 -OutputPath "C:\Exports\Intune"
```

### 3.3 Export Intune Configuration

Export all Intune configuration that will need to be recreated in Impact tenant.

#### Export Configuration Profiles

**Script:** `A6-ConfigurationProfiles.ps1`

```powershell
.\A6-ConfigurationProfiles.ps1 -OutputPath "C:\Exports\Intune"
```

#### Export Compliance Policies

**Script:** `A7-CompliancePolicies.ps1`

```powershell
.\A7-CompliancePolicies.ps1 -OutputPath "C:\Exports\Intune"
```

#### Export Application Assignments

**Script:** `A8-AssignedApps.ps1`

```powershell
.\A8-AssignedApps.ps1 -OutputPath "C:\Exports\Intune"
```

#### Export Scripts and Remediations

**Script:** `A9-ScriptsAndRemediations.ps1`

```powershell
.\A9-ScriptsAndRemediations.ps1 -OutputPath "C:\Exports\Intune"
```

#### Export Primary User Mappings

**Script:** `A5-IntunePrimaryUsers.ps1`

```powershell
.\A5-IntunePrimaryUsers.ps1 -OutputPath "C:\Exports\Intune"
```

### 3.4 Device Inventory & Validation

Create a complete inventory of all devices to be migrated.

#### Inventory Checklist

- [ ] All 193 devices identified and documented
- [ ] Device serial numbers recorded
- [ ] Hardware hashes collected for all devices
- [ ] Current user assignments documented
- [ ] Device models and specifications recorded
- [ ] Carve-out devices identified (if any not in scope)

> **Completion:** Once all exports are complete, provide the following to Impact administrators:
>
> - Hardware hash CSV file
> - Autopilot profile configuration
> - Intune configuration exports
> - Device inventory spreadsheet

---

## 4. Phase 2: Pre-Migration Tasks (Impact Tenant - Destination)

**Administrator:** Suleman Manji (smanji@viyu.net)

These tasks are performed by the Impact administrator to prepare the destination tenant for device migration.

### 4.1 Login Readiness Validation (CRITICAL)

> **CRITICAL:** This step MUST be completed before proceeding with any migration tasks. Do NOT proceed until login readiness validation passes.

The login readiness audit validates that the M365 tenant is properly configured for user authentication and device enrollment.

#### Run Login Readiness Audit

**Script (PowerShell):** `M365-BaselineAudit.ps1`
**Script (Python - Recommended for macOS):** `M365-BaselineAudit.py`
**Location:** `1.impactFlooring/scripts/.Impact-Preparation/`

##### PowerShell Version

```powershell
.\M365-BaselineAudit.ps1 `
    -TenantId "your-tenant-id" `
    -ClientId "your-client-id" `
    -ClientSecret "your-client-secret" `
    -OutputPath "./LoginAudit" `
    -DetailedReport
```

##### Python Version (Recommended for macOS)

```bash
python3 M365-BaselineAudit.py \
    --tenant-id "your-tenant-id" \
    --client-id "your-client-id" \
    --client-secret "your-client-secret"
```

#### Success Criteria

- [ ] **Login Readiness Score: >=80%** (target)
- [ ] **Critical Blockers: 0** (must be zero)
- [ ] **User Login Ready: >0** (users can authenticate)
- [ ] **Device Enrollment: READY** (Intune configured)

> **DO NOT PROCEED** with migration preparation until all success criteria are met. Resolve any critical blockers before continuing.

### 4.2 Environment Assessment

Assess the Impact tenant capacity, licensing, and current configuration.

**Script:** `I1-ImpactAssessment.ps1`
**Location:** `1.impactFlooring/scripts/.Impact-Preparation/`

```powershell
.\I1-ImpactAssessment.ps1 `
    -TenantId "your-tenant-id" `
    -ClientId "your-client-id" `
    -ClientSecret "your-client-secret" `
    -OutputPath ".\Output" `
    -DetailedReport
```

#### Verify Assessment Results

- Sufficient M365 licenses available (193+ required)
- Intune licensing enabled
- Current device count documented
- No capacity warnings

### 4.3 User Account Creation

Create user accounts in Impact tenant for all Pinnacle users.

**Script:** `I2-UserCreation.ps1`
**Location:** `1.impactFlooring/scripts/.Impact-Preparation/`

#### Prepare User Data

Create `pinnacle_users.csv` from Pinnacle export with the following columns:

- UserPrincipalName
- DisplayName
- GivenName
- Surname
- JobTitle
- Department
- OfficeLocation
- MobilePhone
- Manager

#### Run User Creation Script

```powershell
.\I2-UserCreation.ps1 `
    -InputCsvPath ".\PinnacleData\pinnacle_users.csv" `
    -OutputPath ".\Output" `
    -LicenseSku "ENTERPRISEPACK" `
    -DomainSuffix "impactpropertysolutions.com"
```

#### Verify User Creation

- [ ] All users created successfully
- [ ] Licenses assigned to all users
- [ ] Review creation log for any errors

### 4.4 Group Configuration

Create security groups and distribution lists based on Pinnacle group structure.

**Script:** `I3-GroupConfiguration.ps1`
**Location:** `1.impactFlooring/scripts/.Impact-Preparation/`

#### Prepare Group Data

Create `pinnacle_groups.csv` with the following columns:

- DisplayName
- Description
- MailNickname
- GroupTypes
- MailEnabled
- SecurityEnabled
- Members
- Owners

#### Run Group Configuration Script

```powershell
.\I3-GroupConfiguration.ps1 `
    -InputCsvPath ".\PinnacleData\pinnacle_groups.csv" `
    -OutputPath ".\Output" `
    -DomainSuffix "impactpropertysolutions.com"
```

### 4.5 Autopilot Profile Setup

Configure Windows Autopilot profiles for device enrollment.

**Script:** `I4-AutopilotSetup.ps1`
**Location:** `1.impactFlooring/scripts/.Impact-Preparation/`

#### Create Autopilot Profile

```powershell
.\I4-AutopilotSetup.ps1 `
    -OutputPath ".\Output" `
    -ProfileName "Impact Standard Profile" `
    -DeviceNamingTemplate "IMP-%SERIAL%"
```

#### Autopilot Profile Settings

| Setting                 | Value        | Description                        |
| ----------------------- | ------------ | ---------------------------------- |
| Hide Privacy Settings   | Enabled      | Skips privacy settings during OOBE |
| Hide EULA               | Enabled      | Skips EULA acceptance              |
| Skip Keyboard Selection | Enabled      | Skips keyboard layout selection    |
| Device Naming Template  | IMP-%SERIAL% | Automatic device naming            |
| User Type               | Standard     | Standard user account (not admin)  |

#### Enrollment Status Page (ESP) Configuration

- Show Installation Progress: **Enabled**
- Block Device Setup Retry: **Enabled**
- Allow Device Reset on Failure: **Enabled**
- Allow Log Collection: **Enabled**
- ESP Timeout: **60 minutes**

### 4.6 Hardware Hash Import

Import hardware hashes from Pinnacle tenant into Impact Autopilot.

**Script:** `I8-ImportAutopilotHashes.ps1`
**Location:** `1.impactFlooring/scripts/.Impact-Preparation/`

#### Process Hardware Hash CSV (Optional)

If using Python processing script:

```bash
python3 Process-DeviceCSV.py \
    "path/to/hardware_hashes.csv" \
    "./DeviceProcessing"
```

#### Import Hardware Hashes

```powershell
.\I8-ImportAutopilotHashes.ps1 `
    -OutputPath ".\Output" `
    -AutopilotProfileName "Impact Standard Profile" `
    -GroupTag "Pinnacle-Migration" `
    -UsePythonResults
```

#### Verify Import

- [ ] All 193 devices appear in Autopilot devices list
- [ ] Autopilot profile assigned to all devices
- [ ] Group tag "Pinnacle-Migration" applied
- [ ] Review import log for any failures

### 4.7 Intune Configuration

Configure Intune policies, profiles, and applications for migrated devices.

#### Create Device Group

**Script:** `I7-CreateDeviceGroup.ps1`

```powershell
.\I7-CreateDeviceGroup.ps1 `
    -OutputPath ".\Output" `
    -GroupName "Impact - All Windows Devices (Initial Enrollment)" `
    -GroupDescription "All Windows devices from Pinnacle migration" `
    -UsePythonResults
```

#### Configuration Profiles

**Script:** `I5-IntuneConfigurationProfiles.ps1`

Create configuration profiles for:

- Windows Update for Business
- Administrative Templates (RDC UDP, app associations)
- Settings Catalog (Taskbar, OneDrive, Power settings)

```powershell
.\I5-IntuneConfigurationProfiles.ps1 `
    -OutputPath ".\Output"
```

#### Application Deployment

**Script:** `I6-IntuneAppDeployment.ps1`

Deploy required applications:

- Google Chrome
- Foxit PDF Reader
- Microsoft 365 Apps
- NinjaOne Agent
- IPS.exe (if required)

```powershell
.\I6-IntuneAppDeployment.ps1 `
    -OutputPath ".\Output"
```

> **Note:** See `Intune_App_Deployment_README.md` for detailed application packaging and deployment instructions.

---

## 5. Phase 3: Migration Execution

This phase involves the actual device migration process, including device reset requests, Autopilot enrollment, and post-migration verification. The process involves coordination between onsite technicians, Impact administrators (Suleman Manji), and Pinnacle administrators (Willie Dallas).

> **Workflow Overview:** Onsite technicians perform the physical device work, while administrators handle remote tasks including Autopilot removal, Intune resets, and enrollment verification. See Onsite Coordination Guide for technician workflow details.

### 5.0 Tenant Migration Methods

Microsoft provides two methods for transferring Windows Autopilot devices between tenants. This migration uses **Method 1: Online Migration** as the primary approach, with Method 2 available as a fallback **if Method 1 fails for any reason**.

#### Method 1: Online Migration (Primary Method)

**Status:** PRIMARY METHOD FOR THIS MIGRATION

**Best For:**

- Standard migration scenarios
- Short time frames (days vs weeks/months)
- Immediate access to new tenant for profile assignment
- Up to 500 devices per batch
- 193 devices (single batch for this migration)

**How It Works:** Devices are removed from old tenant Autopilot, registered to new tenant Autopilot, then reset to enroll in new tenant.

#### Method 2: Offline Migration (Fallback Method)

**Status:** FALLBACK WHEN METHOD 1 FAILS

**When to Use:**

- **Primary Use Case:** When Method 1 (Online Migration) fails for any reason
- Autopilot registration errors in new tenant
- Deletion not completing in old tenant
- Device enrollment failures with online method
- Large device uploads (2000+ devices) - not applicable to this migration

**How It Works:** Uses local JSON-based Autopilot configuration file deployed to devices before reset, bypassing Autopilot service communication.

> **Note:** This method is more complex and should only be used if Method 1 encounters issues that cannot be resolved.

### Method 1: Online Migration - Detailed Process

This is the **primary method** used for the Pinnacle to Impact migration. Follow these steps in order:

#### Step 1: Collect Hardware Hashes from Devices

**Administrator:** Willie Dallas (willie.dallas@ilginc.com) - Pinnacle Tenant

Collect hardware hashes from all devices that will be migrated to the new tenant.

**Methods Available:**

- **Get-WindowsAutoPilotInfo Script:** Run on each device to generate hardware hash
- **Configuration Manager:** Export hashes from existing Autopilot devices
- **Intune Portal:** Export from existing Autopilot device registrations

**Script Reference:** `A2-HardwareHashes.ps1` or `Get-WindowsAutoPilotInfo`

```powershell
# Example: Collect hardware hash from device
Install-Script -Name Get-WindowsAutopilotInfo -Force
Get-WindowsAutopilotInfo -OutputFile "C:\DeviceHash.csv"
```

> **Important:** Limit is 500 hashes per upload batch. For 193 devices, this can be done in a single batch.

#### Step 2: Upload Hashes to New Tenant (Tenant B - Impact)

**Administrator:** Suleman Manji (smanji@viyu.net) - Impact Tenant

Register devices to the new tenant (Impact) Autopilot service. Two methods available:

##### Method A: Microsoft Intune Admin Center (UI)

1. Navigate to **Devices** > **Windows** > **Windows enrollment** > **Devices**
2. Click **Import**
3. Upload CSV file with hardware hashes
4. Monitor import batch status via API: `/importedWindowsAutopilotDeviceIdentities/${id}?$select=id,state`
5. UX will pool for import batch status and notify admin of success/failure

##### Method B: PowerShell Script (Automated)

Use the WindowsAutoPilotIntune PowerShell module:

```powershell
# Install module
Install-Module WindowsAutoPilotIntune -Force

# Import hardware hashes CSV
Import-AutopilotCSV -GroupTag "Pinnacle-Migration" -Assign
```

**Script Reference:** `I8-ImportAutopilotHashes.ps1`

```powershell
.\I8-ImportAutopilotHashes.ps1 `
    -OutputPath ".\Output" `
    -CSVPath ".\PinnacleData\ALL-WindowsDevices_AutoPilot_Hashes.csv" `
    -GroupTag "Pinnacle-Migration" `
    -AutopilotProfileName "Impact Standard Profile" `
    -UpdateExisting
```

> **Note:** At this point, devices are registered to Tenant B (Impact) but still managed by Tenant A (Pinnacle). This is expected behavior.

#### Step 3: Remove Autopilot Registration from Old Tenant (Tenant A - Pinnacle)

**Administrator:** Willie Dallas (willie.dallas@ilginc.com) - Pinnacle Tenant

After hashes are registered in Tenant B, remove the Autopilot registration from Tenant A.

##### Method A: Intune Admin Center (UI)

1. Log into Pinnacle Intune portal
2. Navigate to **Devices** > **Windows** > **Windows enrollment** > **Devices**
3. Search for device by serial number
4. Select device(s) and click **Delete**
5. Confirm deletion

> **Important:** The device will still be managed by Intune in Tenant A until reset. Only the Autopilot registration is removed.

##### Method B: PowerShell (Automated)

```powershell
# Remove device from Autopilot (does not delete Intune managed device)
Remove-AutopilotDevice -SerialNumber "XXXXX"
```

**Note:** Both `Remove-AutopilotDevice` and `Import-AutopilotDevice` come from the WindowsAutoPilotIntune module.

#### Step 4: Verify Device Registration in New Tenant

**Administrator:** Suleman Manji (smanji@viyu.net) - Impact Tenant

Confirm device is registered in Impact Autopilot and profile is assigned:

1. Navigate to **Devices** > **Windows** > **Windows enrollment** > **Devices**
2. Search for device by serial number
3. Verify device appears with correct Autopilot profile assigned
4. Verify group tag "Pinnacle-Migration" is applied

> **Troubleshooting:** If you receive an error when attempting to register in Tenant B, this may indicate the deletion was not fully completed in Tenant A. Wait 15-30 minutes and retry.

#### Step 5: Reset the Device

**Action:** Onsite technician or user performs device reset

Once device is registered in Tenant B and desired profile is assigned, reset the device to join the new tenant.

##### Reset Methods:

- **Settings App:** Settings > System > Recovery > Reset this PC
- **Intune Admin Center:** Devices > Windows > Select device > Wipe
- **Remote Wipe:** Performed by administrator via Intune

> **CRITICAL:** Do NOT use the "Autopilot Reset" function. This will NOT initiate Autopilot on the device and will leave it managed by the old tenant. Use "Reset this PC" or "Wipe" instead.

**What Happens:**

- Device is wiped and reset to factory state
- During OOBE, device connects to Autopilot service
- Device downloads Autopilot profile from Tenant B (Impact)
- Device is re-provisioned and enrolled to Impact tenant using Autopilot
- All Intune policies and applications are deployed

### Method 2: Offline Migration - Detailed Process (Fallback)

This method should be used **only if Method 1 (Online Migration) fails for any reason** and cannot be resolved. It uses a local Autopilot JSON-based configuration file to bypass Autopilot service communication issues.

> **When to Use This Method:** Only use Method 2 if you encounter persistent failures with Method 1, such as:
>
> - Autopilot registration errors that cannot be resolved
> - Device deletion from old tenant not completing
> - Enrollment failures after successful registration
> - Service communication issues preventing online migration

> **Important:** When using offline migration, you won't be able to pre-target policies to the device. Once migration is complete, remove the JSON file for subsequent resets.

#### Step 1: Remove Devices from Autopilot Profile Assignments

**Administrator:** Willie Dallas (willie.dallas@ilginc.com) - Pinnacle Tenant

Before deregistration, remove devices from any Autopilot profiles where "Convert existing devices" setting is enabled.

1. Navigate to Autopilot deployment profiles
2. Review profile assignments
3. Remove devices from profiles with "Convert existing devices" enabled

#### Step 2: Deregister Devices from Autopilot in Batches

**Administrator:** Willie Dallas (willie.dallas@ilginc.com) - Pinnacle Tenant

Deregister devices from Autopilot using Graph APIs. Use the one-step removal function (available as of Intune 2108) which removes Autopilot registration without deleting the Intune managed device object.

```powershell
# Example: Batch deregistration script
# Use Graph API to deregister devices
# Perform full device sync for every 2,000 devices deregistered
```

> **Recommendation:** Perform a full device sync for every 2,000 devices deregistered to ensure proper cleanup.

#### Step 3: Create Offline Autopilot JSON File for New Tenant

**Administrator:** Suleman Manji (smanji@viyu.net) - Impact Tenant

Create an offline Autopilot JSON configuration file for Tenant B (Impact) devices.

**Reference:** See [Windows Autopilot deployment for existing devices: Create JSON file for Autopilot profile(s)](https://learn.microsoft.com/en-us/mem/autopilot/existing-devices)

The JSON file contains Autopilot profile configuration that will be used during device reset.

#### Step 4: Deploy JSON File to Devices via Old Tenant

**Administrator:** Willie Dallas (willie.dallas@ilginc.com) - Pinnacle Tenant

Using Tenant A (Pinnacle), deploy a PowerShell script that copies the offline Autopilot profile for Tenant B to the desired devices.

**Critical Path:** The JSON file must be placed at this exact location:

```
%windir%\provisioning\autopilot\AutoPilotConfigurationFile.json
```

**Deployment Method:**

- Create Intune Win32 app or PowerShell script
- Deploy to target devices via Tenant A Intune
- Script copies JSON file to the exact path above

#### Step 5: Initiate Full Device Wipe

**Action:** Onsite technician or administrator

Perform a full wipe of the device (no user data or apps). This can be:

- Local reset via Settings app
- Remote wipe via Intune

**What Happens After Reset:**

- Autopilot profile from Tenant A registration is wiped
- Device is no longer registered with Autopilot
- No new profile is downloaded from Autopilot service
- The JSON file (from step 4) persists across resets
- Device uses the local JSON file for Autopilot configuration

> **Important:** The JSON file will persist across all future resets. Remove it after migration if this isn't desired.

#### Step 6: Device Setup with New Tenant

**Action:** User or onsite technician

Device user sets up the Windows device with the new Tenant B (Impact) Autopilot experience using the local JSON configuration file.

#### Step 7: Create Default Autopilot Profile for Auto-Registration

**Administrator:** Suleman Manji (smanji@viyu.net) - Impact Tenant

Create a default Autopilot profile assigned to the "All Devices" virtual group with the setting "Convert existing devices" enabled.

**Purpose:** This automatically registers all devices into Autopilot during the devices' lifetime. Devices can be targeted with this default profile to automatically register the device to Tenant B in Autopilot.

> **Note:** Before uploading multiple batches of devices, confirm that previous batch(es) are successfully registered.

### Method Comparison

| Feature                    | Method 1: Online Migration                     | Method 2: Offline Migration                    |
| -------------------------- | ---------------------------------------------- | ---------------------------------------------- |
| **Best For**               | Standard migrations, up to 500 devices/batch   | When Method 1 fails - troubleshooting fallback |
| **Pre-target Policies**    | Yes - Can pre-assign policies before reset     | No - Policies assigned after enrollment        |
| **Time Frame**             | Days (short timeline)                          | Weeks/Months (extended timeline)               |
| **Complexity**             | Lower - Direct Autopilot service communication | Higher - Requires JSON file deployment         |
| **Device Limit per Batch** | 500 devices                                    | 2000+ devices (with sync every 2000)           |
| **This Migration Uses**    | **PRIMARY METHOD**                             | **FALLBACK IF METHOD 1 FAILS**                 |

### 5.1 Device Reset Request Process

**Primary Administrator:** Suleman Manji (smanji@viyu.net)

Onsite technicians submit device serial numbers to Suleman Manji via MS Teams for Autopilot removal and Intune device reset.

#### Process Flow

##### Step 1: Receive Device Reset Request

Onsite technician contacts Suleman Manji via MS Teams with the following format:

```
Windows Serial: [XXXXX] | iOS Serial: [XXXXX] | iOS UDID: [XXXXX]
```

Technician provides Windows device serial number for Autopilot removal and Intune reset.

##### Step 2: Remove Device from Pinnacle Autopilot

**Action:** Suleman Manji coordinates with Willie Dallas (willie.dallas@ilginc.com) to remove device from Pinnacle Autopilot.

**Process:**

1. Willie Dallas logs into Pinnacle Intune portal
2. Navigate to **Devices** > **Windows** > **Windows enrollment** > **Devices**
3. Search for device by serial number
4. Select device and click **Delete** to remove from Autopilot
5. Confirm deletion

> **Timeline:** This process typically takes 15-30 minutes. Technician should wait for confirmation before proceeding to OOBE.

##### Step 3: Perform Intune Device Reset

**Action:** Suleman Manji performs Intune device reset to prepare device for Autopilot enrollment in Impact tenant.

**Process:**

1. Log into Impact Intune portal (Microsoft Endpoint Manager)
2. Navigate to **Devices** > **Windows**
3. If device is already enrolled, select device and perform **Wipe** action
4. If device is not enrolled, verify hardware hash is in Autopilot devices list
5. Confirm device reset completion

##### Step 4: Confirm Reset Completion

Send confirmation to onsite technician via MS Teams that device reset is complete and ready for OOBE.

> **Success Indicator:** Device is removed from Pinnacle Autopilot, reset in Intune (if applicable), and hardware hash is present in Impact Autopilot with correct profile assignment.

### 5.2 Windows OOBE Setup (Onsite Technician)

**Note:** This step is performed by onsite technicians. Administrators should verify enrollment status after completion.

After receiving reset confirmation, onsite technician performs Windows Out-of-Box Experience (OOBE) setup:

- Boot device and connect to network (Ethernet preferred)
- User signs in with `@impactpropertysolutions.com` email
- Autopilot enrollment process begins automatically (ESP page appears)
- Allow all applications to install automatically (DO NOT INTERRUPT)
- Verify OneDrive sync starts automatically
- Configure Outlook and Teams
- Verify required applications installed (Chrome, Foxit Reader, NinjaOne Agent, IPS.exe)

#### Administrator Verification Tasks

**Administrator:** Suleman Manji (smanji@viyu.net)

After technician completes OOBE, verify enrollment in Intune:

- [ ] Device appears in Intune devices list
- [ ] Device shows as "Enrolled" status
- [ ] Autopilot profile applied correctly
- [ ] Configuration profiles beginning to apply

### 5.3 Post-Enrollment Verification (Onsite Technician)

**Note:** This step is performed by onsite technicians. Administrators should verify application deployment status.

Technician verifies the following on the device:

- **Outlook Classic:** Account configured, pinned to taskbar
- **Teams:** Work/school account set up, OneDrive synced, pinned to taskbar
- **Google Chrome:** Installed and set as default browser
- **Foxit Reader:** Installed and set as default PDF reader
- **NinjaOne RMM Agent:** Installed and running
- **IPS.exe:** VPN profile created (if not configured by Autopilot)

#### Administrator Application Verification

**Administrator:** Suleman Manji (smanji@viyu.net)

Verify application deployment status in Intune:

1. Navigate to **Apps** > **Monitor** > **App install status**
2. Filter by device or user
3. Verify all required applications show "Installed" or "Installing" status
4. Address any "Failed" installations

### 5.4 User Validation (Onsite Technician)

**Note:** This step is performed by onsite technicians with user present. Administrators should verify network connectivity and functionality.

Technician has user verify the following three critical items:

#### Internet Access

User opens browser and visits a website (e.g., google.com). Confirm connection is working.

#### RFMS RDP Usability

User tests Remote Desktop connection to RFMS server. Confirm connectivity and responsiveness.

#### Printing Functionality

User sends a test print job to the mapped printer. Confirm output is received.

### 5.5 M365 Admin Tasks (Day +2, >=48 Hours Post-Migration)

**Primary Administrator:** Suleman Manji (smanji@viyu.net)
**Coordination Required:** Willie Dallas (willie.dallas@ilginc.com)

After device enrollment is complete (minimum 48 hours post-migration), perform final administrative verification and cleanup.

#### Enrollment Verification

##### Step 1: Verify Autopilot Enrollment Success

In Microsoft Endpoint Manager (Intune):

1. Navigate to **Devices** > **Windows**
2. Search for device by serial number or user
3. Verify device shows as "Enrolled" and "Compliant"
4. Check enrollment date and time
5. Review enrollment logs for any errors

##### Step 2: Coordinate with Willie Dallas: Remove Device from Pinnacle Autopilot

**Action:** Suleman Manji coordinates with Willie Dallas to remove the device from Pinnacle Autopilot after successful enrollment verification.

**Process:**

1. Suleman confirms device is successfully enrolled in Impact Intune
2. Suleman contacts Willie Dallas via email or MS Teams with device serial number
3. Willie Dallas logs into Pinnacle Intune portal
4. Navigate to **Devices** > **Windows** > **Windows enrollment** > **Devices**
5. Search for device by serial number
6. If device still appears in Pinnacle Autopilot, delete it
7. Willie confirms deletion to Suleman

> **Note:** This step ensures devices are fully removed from Pinnacle tenant and prevents any conflicts or confusion.

##### Step 3: Verify Device in Intune Management

Confirm device is fully managed by Impact Intune:

- Device appears in **Devices** > **Windows** list
- Primary user is assigned correctly
- Device is member of correct device groups
- Last sync time is recent (within 24 hours)

##### Step 4: Verify Compliance Policies Applied

Check compliance policy status:

1. Navigate to **Devices** > **Compliance policies**
2. Filter by device or view device compliance status
3. Verify device shows "Compliant" status
4. Review any non-compliance issues and remediate
5. Verify BitLocker encryption status (if applicable)
6. Verify Windows Defender status

### 5.6 Production Rollout Monitoring

**Administrator:** Suleman Manji (smanji@viyu.net)

Monitor device enrollment progress across all sites during production rollout. This migration follows a **distributed site onboarding plan** with 23 sites and 142 Windows devices over a compressed Dec 4-29 timeline.

> **Reference Documentation:** For complete site schedule, team assignments, and onsite workflow details, see the Onsite Coordination Guide. This includes the full migration schedule, site contacts, resource requirements, and network migration dependencies.

#### Migration Schedule Overview

The production rollout is organized into **4 phases** across 23 sites:

| Phase                          | Dates     | Users                 | Key Sites                                                                         | Team Structure                         |
| ------------------------------ | --------- | --------------------- | --------------------------------------------------------------------------------- | -------------------------------------- |
| **Phase 1: Launch & Momentum** | Dec 4-10  | 31 users              | Carrollton, Tampa, El Paso, Austin, Jacksonville, Orlando, Albuquerque, Pawtucket | 1 Team (standard sites)                |
| **Phase 2: Build Phase**       | Dec 11-17 | 26 users + Sacramento | Denver, Las Vegas, Sparks, Salt Lake City, Fresno, Sacramento (12 users)          | 1-2 Teams (Sacramento: 2-team)         |
| **Phase 3: Peak Intensity**    | Dec 18-25 | 51 users              | Union City (10), Chula Vista (11), La Mirada (19), Auburn (18), Tucson, Phoenix   | 2 Teams + Surge (large sites)          |
| **Phase 4: Final Sprint**      | Dec 26-29 | 34 users              | Milwaukie (26 users - 3-team), Houston (8)                                        | 3 Teams (Milwaukie), 2 Teams (Houston) |

> **Critical Prerequisite:** Network infrastructure migration must be completed BEFORE M365 on-site deployment begins. Verify network migration status for each site before technician visit.

#### Phase-Based Monitoring Tasks

Administrator monitoring activities vary by phase based on site complexity and team deployment:

##### Phase 1-2: Standard Monitoring (Dec 4-17)

- **Daily Enrollment Review:** Check Intune portal daily for new device enrollments from standard 1-team sites
- **Reset Request Processing:** Process device reset requests as received from onsite technicians (typically 1-5 devices per site)
- **Site Verification:** Verify network migration completion before each site visit
- **Error Tracking:** Review enrollment errors in **Devices** > **Monitor** > **Enrollment failures**

##### Phase 3: Peak Period Monitoring (Dec 18-25 - Holiday Period)

> **Peak Intensity Period:** This phase includes 51 users across large sites (La Mirada: 19 users, Auburn: 18 users) during the holiday period. Administrator must be available for increased reset request volume.

- **Batch Reset Processing:** Process reset requests in batches for large sites (2-team deployments may submit 5-10 devices simultaneously)
- **Extended Availability:** Maintain availability during holiday period (Dec 20-25) for La Mirada and Auburn site support
- **Queue Management:** Process overnight reset queues to prepare for next-day technician activities
- **Large Site Coordination:** Coordinate with Willie Dallas for bulk Autopilot removals from Pinnacle tenant for large sites
- **Application Deployment Status:** Monitor app installation status across all devices, especially for large sites with concurrent enrollments

##### Phase 4: Final Sprint Monitoring (Dec 26-29)

> **Milwaukie 3-Team Deployment:** Milwaukie site (26 users, Dec 26-28) requires 3-team deployment with 3 concurrent subgroups. Expect high volume of simultaneous reset requests.

- **High-Volume Reset Processing:** Process reset requests for Milwaukie's 3-team deployment (up to 26 devices in rapid succession)
- **Concurrent Enrollment Monitoring:** Monitor 3 parallel enrollment streams for Milwaukie site
- **Final Site Verification:** Complete verification for Houston (final site, Dec 29)
- **Completion Validation:** Verify all 142 devices enrolled and compliant by Dec 27-29

#### Site-Specific Monitoring Considerations

Different site sizes require different monitoring approaches:

- **Standard Sites (1-4 users):** Single technician, sequential device processing. Monitor for standard enrollment patterns.
- **Large Sites (10-12 users):** 2-team parallel deployment. Monitor for concurrent enrollment patterns and potential conflicts.
- **Very Large Sites (18-19 users):** 2-team + Surge deployment. Monitor for extended enrollment periods (2-3 days) and batch processing requirements.
- **Massive Sites (26 users - Milwaukie):** 3-team deployment with 3 concurrent subgroups. Monitor for high-volume simultaneous enrollments and potential service throttling.

#### Enrollment Dashboard

Use Microsoft Endpoint Manager to monitor enrollment progress:

- **Devices** > **Windows** > Enrollment status overview
- **Devices** > **Monitor** > Enrollment errors and warnings
- **Devices** > **Autopilot devices** > Profile assignments and enrollment status
- **Apps** > **Monitor** > App install status by device

#### Site Coordination & Communication

Maintain communication with onsite technicians throughout the rollout:

- **Reset Request Queue:** Monitor MS Teams for device reset requests from onsite technicians
- **Site Contact Verification:** Reference site schedule for primary contacts and site-specific information
- **Issue Escalation:** Coordinate with Willie Dallas for Pinnacle tenant issues, onsite technicians for device-specific problems
- **Progress Tracking:** Track enrollment completion by site using the Onsite Coordination Master Checklist

#### Key Milestones & Completion Targets

- **Dec 4:** Project launch (Carrollton) - immediately after BitTitan completion
- **Dec 4-10:** Phase 1 complete - 31 users migrated
- **Dec 11-17:** Phase 2 complete - 26 users + Sacramento (12) migrated
- **Dec 18-25:** Phase 3 complete - 51 users migrated (peak intensity, holiday period)
- **Dec 26-28:** Milwaukie 3-team deployment - 26 users
- **Dec 27-29:** **All 142 devices complete** (3-4 days before deadline)
- **Dec 30-31:** Buffer/validation days (if needed)

> **Success Indicator:** All 142 Windows devices successfully enrolled in Impact Intune, compliant, and fully configured with all required applications and policies by Dec 27-29, 2025.

---

## 6. Phase 4: Post-Migration Tasks

**Administrator:** Suleman Manji (smanji@viyu.net)

Verification, user assignment, and cleanup tasks after device enrollment performed by the Impact administrator.

### 6.1 Device Verification

Verify all devices enrolled successfully and are compliant.

#### Device Verification Checklist

- [ ] All 193 devices enrolled in Intune
- [ ] Device compliance status: Compliant
- [ ] Configuration profiles applied
- [ ] Applications installed successfully
- [ ] No policy conflicts

### 6.2 User Affinity Assignment

Assign primary users to devices for proper user-device relationships.

**Script:** `A5-IntunePrimaryUsers.ps1`
**Location:** `1.pinnacle/Scripts/Autopilot-Intune/` (adapt for Impact tenant)

```powershell
# Assign primary users to devices
# Use device serial number and user UPN mapping
.\A5-IntunePrimaryUsers.ps1 `
    -InputCsvPath ".\device_user_mapping.csv" `
    -OutputPath ".\Output"
```

### 6.3 Application Verification

Verify all required applications are installed and functioning.

- Check application installation status in Intune
- Remediate any failed installations
- Verify application functionality on test devices
- Document application deployment status

### 6.4 Policy Verification

Verify all policies are applied correctly.

- Configuration profiles: Applied
- Compliance policies: Enforced
- Check for policy conflicts
- Document policy status

### 6.5 Cleanup Tasks

- Remove test devices/accounts
- Clean up temporary configurations
- Update documentation
- Archive migration data
- Retire devices from Pinnacle tenant (if not already done)

---

## 7. Troubleshooting

Common issues and resolutions during Windows device migration.

### 7.1 Hardware Hash Import Issues

#### Issue: Import fails with "Device Already Exists"

> **Solution:** Device may already be registered. Check Autopilot devices list. If device needs to be reassigned, delete and re-import, or update the existing registration.

#### Issue: Device Not Appearing After Import

> **Solution:**
>
> - Wait 5-10 minutes for sync to complete
> - Refresh the Intune portal
> - Verify CSV file format is correct
> - Check for import errors in portal

### 7.2 Autopilot Enrollment Issues

#### Issue: Device doesn't boot to Autopilot OOBE

> **Solution:**
>
> - Verify device was fully reset to factory state
> - Power cycle the device (full shutdown and restart)
> - Ensure device is connected to internet during boot
> - Check Intune to verify device is registered in Autopilot
> - If still failing, may need to re-register device hash

#### Issue: Autopilot enrollment hangs or fails

> **Solution:**
>
> - Ensure internet connection is stable
> - Verify user has active Microsoft 365 credentials
> - Check Intune portal for enrollment errors
> - Wait 5-10 minutes for enrollment sync
> - Restart device and retry enrollment

### 7.3 Policy Application Issues

#### Issue: Policies Not Applied

> **Solution:**
>
> - Check device is assigned to correct security groups
> - Verify Intune policies/assignments target the device
> - On device: Settings > Accounts > Access work or school > Info > Sync
> - Wait 5 minutes after sync
> - Contact Intune administrator if policies still not applying

### 7.4 Application Deployment Issues

#### Issue: Applications Not Installing

> **Solution:**
>
> - Restart device and wait another 10 minutes
> - Check Windows Update Settings
> - Verify device appears in Microsoft Endpoint Manager
> - Check application assignment in Intune
> - Review application installation logs

---

## 8. Scripts Reference

Quick reference for all scripts used in the migration process.

### Pinnacle Tenant Scripts (Source)

| Script                         | Purpose                              | Location                               |
| ------------------------------ | ------------------------------------ | -------------------------------------- |
| `A1-AutopilotDevices.ps1`      | Export Autopilot device identities   | `1.pinnacle/Scripts/Autopilot-Intune/` |
| `A2-HardwareHashes.ps1`        | Collect hardware hashes from devices | `1.pinnacle/Scripts/Autopilot-Intune/` |
| `A3-AutopilotProfiles.ps1`     | Export Autopilot profiles            | `1.pinnacle/Scripts/Autopilot-Intune/` |
| `A5-IntunePrimaryUsers.ps1`    | Export primary user mappings         | `1.pinnacle/Scripts/Autopilot-Intune/` |
| `A6-ConfigurationProfiles.ps1` | Export configuration profiles        | `1.pinnacle/Scripts/Autopilot-Intune/` |
| `A7-CompliancePolicies.ps1`    | Export compliance policies           | `1.pinnacle/Scripts/Autopilot-Intune/` |
| `A8-AssignedApps.ps1`          | Export app assignments               | `1.pinnacle/Scripts/Autopilot-Intune/` |

### Impact Tenant Scripts (Destination)

| Script                               | Purpose                                     | Location                                        |
| ------------------------------------ | ------------------------------------------- | ----------------------------------------------- |
| `M365-BaselineAudit.ps1`             | Login readiness validation (CRITICAL)       | `1.impactFlooring/scripts/.Impact-Preparation/` |
| `M365-BaselineAudit.py`              | Login readiness validation (Python - macOS) | `1.impactFlooring/scripts/.Impact-Preparation/` |
| `I1-ImpactAssessment.ps1`            | Environment assessment                      | `1.impactFlooring/scripts/.Impact-Preparation/` |
| `I2-UserCreation.ps1`                | Bulk user creation                          | `1.impactFlooring/scripts/.Impact-Preparation/` |
| `I3-GroupConfiguration.ps1`          | Security groups setup                       | `1.impactFlooring/scripts/.Impact-Preparation/` |
| `I4-AutopilotSetup.ps1`              | Autopilot profile configuration             | `1.impactFlooring/scripts/.Impact-Preparation/` |
| `I5-IntuneConfigurationProfiles.ps1` | Intune configuration profiles               | `1.impactFlooring/scripts/.Impact-Preparation/` |
| `I6-IntuneAppDeployment.ps1`         | Application deployment                      | `1.impactFlooring/scripts/.Impact-Preparation/` |
| `I7-CreateDeviceGroup.ps1`           | Azure AD device group creation              | `1.impactFlooring/scripts/.Impact-Preparation/` |
| `I8-ImportAutopilotHashes.ps1`       | Hardware hash import                        | `1.impactFlooring/scripts/.Impact-Preparation/` |
| `Process-DeviceCSV.py`               | Process hardware hash CSV                   | `1.impactFlooring/scripts/.Impact-Preparation/` |

### Master Orchestration

**Script:** `Run-ImpactPreparation.ps1`
**Purpose:** Master orchestration script that executes all preparation steps in sequence
**Location:** `1.impactFlooring/scripts/.Impact-Preparation/`

```powershell
.\Run-ImpactPreparation.ps1 `
    -OutputPath ".\Output" `
    -PinnacleDataPath ".\PinnacleData" `
    -DryRun
```

---

## 9. Key Contacts

Primary administrators responsible for Windows device migration tasks.

### Migration Administrators

| Name              | Organization  | Email                      | Primary Responsibilities                                                                                                                                                                                                                    |
| ----------------- | ------------- | -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Suleman Manji** | Impact Floors | `smanji@viyu.net`          | Impact tenant preparation and configuration, User account creation and licensing, Autopilot profile setup, Hardware hash import, Intune configuration and policies, Device enrollment verification, Post-migration verification and cleanup |
| **Willie Dallas** | ILG/Pinnacle  | `willie.dallas@ilginc.com` | Hardware hash export from Pinnacle tenant, Autopilot configuration export, Intune configuration export, Device inventory and documentation, Device wipe coordination and execution, Data export coordination                                |

> **Coordination:** Suleman Manji and Willie Dallas must coordinate during Phase 3 (Migration Execution) for device wipe timing and transfer verification. All other phases are performed independently by each administrator in their respective tenant.

---

**ILG Windows Device Migration - Administrator Guide**

Version 1.0 | Last Updated: November 2025

Project: 3944169 - 365 Migration for Acquisition

For questions or support, contact the project team
