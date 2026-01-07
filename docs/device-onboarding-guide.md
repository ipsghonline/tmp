---
title: New Windows Device Onboarding and Deployment
nav_order: 1
parent: End User Documentation
---

# Windows Device Deployment Worksheet

**Impact Property Solutions** - Quick Reference Checklist for IT Team

---

## Device Information

| Field                | Value                |
| -------------------- | -------------------- |
| Device Serial Number | ********\_\_******** |
| Device Hostname      | ********\_\_******** |
| Target User (Email)  | ********\_\_******** |
| Deployment Date      | ********\_\_******** |
| Engineer Name        | ********\_\_******** |
| Device Type          | Laptop / Desktop     |

---

## Phase 1: Pre-Deployment Checklist

> **Warning:** Complete these checks BEFORE starting device setup

### Dell Pre-Provisioning Status

- [ ] Device was Dell pre-provisioned (check order confirmation or device packaging for pre-provisioning notation)
- [ ] Verified device hardware hash is already in Autopilot (if Dell pre-provisioned)

> **Note:** Dell pre-provisioned devices use Azure AD Tenant ID and domain name (`impactpropertysolutions.com`) to automatically register with Autopilot. These devices skip manual registration (Phase 3).

### Hardware Hash & Autopilot Status

- [ ] Device hardware hash is imported in Autopilot (check Endpoint Manager > Devices > Windows enrollment > Devices)
- [ ] Device is assigned to "Impact Standard Profile" (or correct Autopilot profile)
- [ ] Target user has Microsoft 365 E3 license assigned (verify in admin.microsoft.com)

> **Note:** If hardware hash is already imported (via Dell pre-provisioning or manual import), skip manual registration (Phase 3) and proceed to Phase 4.

---

## Phase 2: Device Setup & Initial Configuration

### Physical Setup

- [ ] Device unboxed and power adapter connected
- [ ] Network connectivity confirmed (wired Ethernet preferred)
- [ ] Device powered on successfully

### Windows OOBE (Out-of-Box Experience)

- [ ] Language and region selected
- [ ] Terms and conditions accepted
- [ ] NO local account created - proceeded to organizational sign-in

### Organizational Sign-In

- [ ] Signed in with organizational account (@impactpropertysolutions.com)
- [ ] MFA completed (or registered if new user)
- [ ] If admin used own phone for MFA, updated target user's MFA registration

#### Quick Reference: MFA Update Steps

1. Go to admin.microsoft.com or portal.azure.com
2. Users > Active users > Select target user
3. Authentication methods > Remove admin's phone > Add target user's phone

---

## Phase 3: Autopilot Registration

**Skip if Pre-Registered**

> **Important:** Only complete this phase if device was NOT Dell pre-provisioned AND device hardware hash is NOT already imported. If Dell pre-provisioned or pre-registered, skip to Phase 4.

### PowerShell Registration

- [ ] Opened PowerShell as Administrator
- [ ] Executed all 4 registration commands successfully
- [ ] Completed authentication (if prompted)
- [ ] Received "Device is registered" success message

#### Autopilot Registration Commands

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
Install-Script -Name Get-WindowsAutopilotInfo -Force
Get-WindowsAutopilotInfo -Online
```

### Verification

- [ ] Verified device appears in Endpoint Manager (may take 15 minutes)
- [ ] Device status shows "Assigned" or "Ready"
- [ ] Deployment profile assignment verified

---

## Phase 4: Enrollment Status Page (ESP) & Policy Deployment

> **Info:** ESP Timeout: 60 minutes. Do NOT interrupt the ESP screen during enrollment.

### Wait Period

- [ ] ESP screen appeared (showing enrollment progress)
- [ ] Waited full 15-20 minutes for policy deployment
- [ ] Device restarted 1-2 times (normal behavior)
- [ ] ESP completed successfully (or allowed device use on failure)

### Expected Application Installation

- [ ] Google Chrome - Installed and set as default browser
- [ ] Foxit PDF Reader - Installed and set as default PDF viewer
- [ ] Office 365 desktop app - Installed (includes Outlook Classic)
- [ ] Microsoft Teams (work and school) - Installed
- [ ] OneDrive sync - Running and syncing

> **Warning:** If Office 365 not installed: Navigate to portal.office.com > Install Office > Office 365 apps

---

## Phase 5: Post-Deployment Verification

### Required Applications & Services

- [ ] **NinjaOne RMM Agent** - System Tray icon visible, device appears in NinjaOne console with correct site
- [ ] **RDP Icon/Shortcut** - Visible on Desktop or Taskbar
- [ ] **RFMS Access** - RDP connection to RFMS server tested and working
- [ ] **Taskbar Configuration** - Pinned apps match standard layout, default shortcuts removed
- [ ] **IPS VPN** - Installed and available in Network settings (all users)
- [ ] **Power & Sleep Settings** - Configured correctly (plugged in: never sleep, battery: 2hr screen/3hr sleep)
- [ ] **Time Zone** - Set correctly for user's location

### Additional Verifications

- [ ] **Outlook** - Installed and company account configured
- [ ] **Teams** - Pinned to taskbar, personal version removed
- [ ] **Antivirus/Security** - Active and up-to-date (Windows Defender or SentinelOne)
- [ ] **Network Printers** - Available in Printers and Scanners settings

### Issues Found

_List any missing items or issues found during verification:_

```
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________
```

---

## Phase 6: Manual Configuration (If Needed)

> **Info:** Only complete items that were missing in Phase 5

- [ ] RFMS RDP connection configured and tested
- [ ] Taskbar configured correctly (pinned/unpinned apps adjusted)
- [ ] Network printers installed (if needed)
- [ ] IPS VPN installed manually (if needed)
- [ ] Power and sleep settings configured manually
- [ ] Time zone set manually

### Manual Configuration Notes

_Document any manual configuration steps performed:_

```
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________
```

---

## Phase 7: Final Handoff Preparation

### Final Checks

- [ ] All verification items from Phase 5 are complete
- [ ] MFA registration verified for target user (not admin's phone)
- [ ] Teams sign-in tested and working
- [ ] Internet connectivity tested
- [ ] RDP access to RFMS tested
- [ ] VPN connection tested (if applicable)
- [ ] Printer access tested
- [ ] Power settings verified
- [ ] Admin account signed out (Settings > Accounts > Your info > Sign out)

> **Success:** Device Ready for End User! The device is now ready for handoff. End user will sign in with their own organizational account when they receive it.

---

## Quick Reference

### Important Links

| Resource                   | URL                                                      |
| -------------------------- | -------------------------------------------------------- |
| Microsoft Endpoint Manager | [endpoint.microsoft.com](https://endpoint.microsoft.com) |
| Microsoft 365 Admin Center | [admin.microsoft.com](https://admin.microsoft.com)       |
| Azure AD Portal            | [portal.azure.com](https://portal.azure.com)             |
| Office Portal              | [portal.office.com](https://portal.office.com)           |

### Troubleshooting Quick Tips

| Issue                            | Resolution                                                                               |
| -------------------------------- | ---------------------------------------------------------------------------------------- |
| Autopilot registration failed    | Verify account has Intune admin rights; retry command                                    |
| Apps not installing after 20 min | Restart device; wait another 10 min; sync in Settings > Accounts > Access work or school |
| RFMS access not working          | Verify network connectivity; check RFMS server address                                   |
| RDP icon missing                 | Create shortcut manually: Right-click Desktop > New > Shortcut > `mstsc.exe`             |
| Device not in Endpoint Manager   | Wait up to 15 min; may need enrollment retry                                             |
| ESP stuck                        | Check Intune portal for device enrollment status; review device logs                     |

---

## Engineer Sign-Off

Complete this section to document successful device deployment.

| Field             | Value                      |
| ----------------- | -------------------------- |
| Engineer Name     | ********\_\_********       |
| Completion Date   | ********\_\_********       |
| Deployment Status | Success / Partial / Failed |

### Issues Encountered (if any)

```
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________
```

---

**Confirmation:** I confirm that this device has been successfully deployed according to the Impact Property Solutions Windows Device Deployment Guide and is ready for end-user handoff.

| Signature            | Date                 |
| -------------------- | -------------------- |
| ********\_\_******** | ********\_\_******** |
