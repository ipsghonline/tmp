---
title: Onsite Migration Coordination Guide
nav_order: 3
parent: Technician Documentation
---

# Impact Property Solutions - Onsite Migration Coordination Guide

**Windows & iOS Device Migration - For Onsite Technicians & Support Engineers**

---

{: .highlight }

> **PHASED MIGRATION STRATEGY**
>
> This guide reflects the **phased migration approach** with pre-migration starting December 1-3, 2025, and main deployment on December 15, 2025. Pre-migration of select machines at each location (Thursday-Friday before main deployment) allows operations teams to maintain functionality while reducing network congestion.
>
> **Key Metrics:** 22 sites | 142 users | Pre-migration Dec 1-3 | Main deployment Dec 15+ | Phased approach to maintain operations

## Overview

This guide provides comprehensive instructions for onsite device migration from the Pinnacle tenant to Impact Property Solutions' Microsoft 365 environment. Each technician visit will handle device backups, reset, and enrollment to the Impact tenant.

### Migration Goals

- **Windows Devices:** Migrate to Impact Autopilot & Intune with full data restoration
- **iOS Devices:** Verify recent backup exists (backup verification only - no reset/restore/enrollment)
- **Data Preservation:** Backup all user data, settings, and configurations
- **Business Continuity:** Ensure minimal downtime and user impact

### Timeline

{: .note }

> **Phased Migration Strategy:** Pre-migration of select machines begins December 1-3, 2025 (3:00 PM) to ensure operations continuity. All sites complete full migration on December 15, 2025.

| Phase               | Date                         | Description                                                                                                                        |
| ------------------- | ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| Pre-Migration Phase | December 1-3, 2025 (3:00 PM) | Select machines at 7 sites migrate early to maintain operations functionality and reduce network congestion during main deployment |
| Main Deployment     | December 15, 2025            | All 22 sites complete full migration - All remaining devices migrate simultaneously                                                |
| Completion          | December 15, 2025            | All 142 users migrated (16 days before Dec 31 deadline)                                                                            |

### Time Estimates (Parallel Processing)

| Scenario           | Time             | Notes                                               |
| ------------------ | ---------------- | --------------------------------------------------- |
| Per User Average   | **45 minutes**   | TOTAL per user if doing only that user              |
| 5 Users (Parallel) | **2-2.25 hours** | NOT 3h 45m (50% time savings from parallel overlap) |

**Typical Breakdown:**

- 0:00-0:15: Fast backups (4-5 users)
- 0:15-0:40: Reset wait window (productive)
- 0:40-1:30: Staggered OOBE
- 1:30-2:00: Concurrent validation

{: .note }

> **Timeline Impact:** Parallel processing is essential for the single-day December 15, 2025 deployment. Without it, sites would take 1.5-2x longer and require multiple days.

{: .important }

> **Setup Strategy:** Set up multiple laptops in a conference room on a table. Technician walks around the table working on devices simultaneously. This parallel approach is critical for meeting the deployment timeline.

---

## Migration Schedule

{: .note }

> **Schedule Overview:** 22 sites, 142 users, pre-migration Dec 1-3 (3:00 PM), main deployment Dec 15-26 (8:00 AM) with extended dates for larger sites

### Pre-Migration Phase: December 1-3, 2025 (3:00 PM) - Select Machines

| Date     | Site            | Time        | Contact          | Users | Notes                                     |
| -------- | --------------- | ----------- | ---------------- | ----- | ----------------------------------------- |
| 12-01-25 | Tucson, AZ      | 3:00 PM MST | Jose Meza        | 2     | **Pre-Migration** - M365 Deploy: 12-15-25 |
| 12-01-25 | Fresno, CA      | 3:00 PM PST | Tabitha Thomas   | 1     | **Pre-Migration** - M365 Deploy: 12-15-25 |
| 12-01-25 | La Mirada, CA   | 3:00 PM PST | Lorraine Arroyas | 19    | **Pre-Migration** - M365 Deploy: 12-20-25 |
| 12-02-25 | Auburn, WA      | 3:00 PM PST | Jared Merryman   | 18    | **Pre-Migration** - M365 Deploy: 12-23-25 |
| 12-02-25 | Sacramento, CA  | 3:00 PM PST | Tabitha Thomas   | 12    | **Pre-Migration** - M365 Deploy: 12-15-25 |
| 12-02-25 | Union City, CA  | 3:00 PM PST | Josue Maldonado  | 10    | **Pre-Migration** - M365 Deploy: 12-18-25 |
| 12-02-25 | Chula Vista, CA | 3:00 PM PST | Rosemary Ruckle  | 11    | **Pre-Migration** - M365 Deploy: 12-19-25 |
| 12-03-25 | Milwaukie, OR   | 3:00 PM PST | Josh Hill        | 26    | **Pre-Migration** - M365 Deploy: 12-26-25 |

### Main Deployment: December 15, 2025 (8:00 AM) - All Sites Go Live

| Date     | Site               | Time        | Contact          | Users | Notes                                                               |
| -------- | ------------------ | ----------- | ---------------- | ----- | ------------------------------------------------------------------- |
| 12-15-25 | Carrollton, TX     | 8:00 AM CST | Albert Rodarte   | 5     | Central time zone - Main deployment                                 |
| 12-15-25 | El Paso, TX        | 8:00 AM CST | Jose Contreras   | 3     | Central time zone - Main deployment                                 |
| 12-15-25 | Austin, TX         | 8:00 AM CST | Nicole Strong    | 5     | Central time zone - Main deployment                                 |
| 12-15-25 | Houston, TX        | 8:00 AM CST | Erica Castillo   | 8     | Central time zone - Main deployment                                 |
| 12-15-25 | Tampa, FL          | 8:00 AM EST | Marcelo Maluf    | 4     | Eastern time zone - Main deployment                                 |
| 12-15-25 | Jacksonville, FL   | 8:00 AM EST | Craig Johnson    | 2     | Eastern time zone - Main deployment                                 |
| 12-15-25 | Orlando, FL        | 8:00 AM EST | Hector Rivera    | 4     | Eastern time zone - Main deployment                                 |
| 12-15-25 | Pawtucket, RI      | 8:00 AM EST | Steven Giardini  | 3     | Eastern time zone - Main deployment                                 |
| 12-15-25 | Albuquerque, NM    | 8:00 AM MST | Patrick Poland   | 5     | Mountain time zone - Main deployment                                |
| 12-15-25 | Denver, CO         | 8:00 AM MST | Solomon Cariker  | 4     | Mountain time zone - Main deployment                                |
| 12-15-25 | Tucson, AZ         | 8:00 AM MST | Jose Meza        | 2     | Mountain time zone - Main deployment (pre-migrated machines active) |
| 12-15-25 | Phoenix, AZ        | 8:00 AM MST | Joe Wright       | 6     | Mountain time zone - Main deployment                                |
| 12-15-25 | Salt Lake City, UT | 8:00 AM MST | Susan Miller     | 3     | Mountain time zone - Main deployment                                |
| 12-15-25 | Las Vegas, NV      | 8:00 AM PST | Lidia Guzman     | 5     | Pacific time zone - Main deployment                                 |
| 12-15-25 | Sparks, NV         | 8:00 AM PST | John Hill        | 4     | Pacific time zone - Main deployment                                 |
| 12-15-25 | Fresno, CA         | 8:00 AM PST | Tabitha Thomas   | 1     | Pacific time zone - Main deployment (pre-migrated machines active)  |
| 12-15-25 | Sacramento, CA     | 8:00 AM PST | Tabitha Thomas   | 12    | Pacific time zone - Main deployment (pre-migrated machines active)  |
| 12-18-25 | Union City, CA     | 8:00 AM PST | Josue Maldonado  | 10    | Pacific time zone - Main deployment (pre-migrated machines active)  |
| 12-19-25 | Chula Vista, CA    | 8:00 AM PST | Rosemary Ruckle  | 11    | Pacific time zone - Main deployment (pre-migrated machines active)  |
| 12-20-25 | La Mirada, CA      | 8:00 AM PST | Lorraine Arroyas | 19    | Pacific time zone - Main deployment (pre-migrated machines active)  |
| 12-23-25 | Auburn, WA         | 8:00 AM PST | Jared Merryman   | 18    | Pacific time zone - Main deployment (pre-migrated machines active)  |
| 12-26-25 | Milwaukie, OR      | 8:00 AM PST | Josh Hill        | 26    | Pacific time zone - Main deployment (pre-migrated machines active)  |

**COMPLETION: December 26, 2025 - ALL 142 USERS MIGRATED (5 days before Dec 31 deadline)**

### Migration Strategy

**Phased Approach Benefits:**

- **Operations Continuity:** Pre-migrating select machines (Dec 1-3) ensures operations teams have functioning computers during main deployment
- **Network Congestion Management:** Staggering device migrations prevents overwhelming network infrastructure with simultaneous driver/update downloads
- **Reduced Downtime:** Phased approach prevents shutting down entire operations for 2-3 hours, allowing jobs to continue processing
- **Call Center Backup:** 2-3 backup laptops at each of four call centers serve as loaner devices with temporary admin access to all stores and printers. Call center staff can process orders and print to any warehouse printer, ensuring business continuity. These loaner devices can be shipped back after migration or left on-site as backup.

{: .warning }

> **Pre-Migration Sites:** Six to seven sites have been identified for pre-migration strategy. Manual setup on ImpactPropertySolution devices will be required for migrated devices to restore user access (excluding RMS and historical email/OneDrive data).

{: .note }

> **Network Congestion Considerations:** Pre-migration helps distribute network load by avoiding simultaneous downloads of drivers and updates across all devices. This prevents network bottlenecks during main deployment.

### Key Dates & Milestones

- **December 1, 2025 (3:00 PM):** Pre-migration begins - Tucson, Fresno, La Mirada (select machines)
- **December 2, 2025 (3:00 PM):** Pre-migration continues - Auburn, Sacramento, Union City, Chula Vista (select machines)
- **December 3, 2025 (3:00 PM):** Pre-migration continues - Milwaukie (select machines)
- **December 15, 2025:** Main deployment - All 22 sites complete full migration simultaneously
- **December 15, 2025:** All 142 users migrated (16 days before Dec 31 deadline)
- **December 16-31, 2025:** Buffer/validation days (if needed)

---

## Network Migration Dependencies

{: .warning }

> **CRITICAL PREREQUISITE:** Network infrastructure migration must be completed BEFORE M365 on-site deployment begins. All affected sites require network validation before technician visit.

### Network Migration Schedule - All 22 Sites

Network infrastructure migration schedule spans November 18 - November 26, 2025.

#### Completed: Already Migrated

| Site       | State | Network Migration Date | M365 Deployment Date | Buffer Days | Status   |
| ---------- | ----- | ---------------------- | -------------------- | ----------- | -------- |
| Carrollton | TX    | November 18, 2025      | December 15, 2025    | 27 days     | Complete |
| Tampa      | FL    | November 20, 2025      | December 15, 2025    | 25 days     | Complete |

#### Scheduled: November 24, 2025

| Site        | State | Network Migration Date | M365 Deployment Date | Buffer Days | Status |
| ----------- | ----- | ---------------------- | -------------------- | ----------- | ------ |
| Albuquerque | NM    | November 24, 2025      | December 15, 2025    | 21 days     | Ready  |
| El Paso     | TX    | November 24, 2025      | December 15, 2025    | 21 days     | Ready  |
| Austin      | TX    | November 24, 2025      | December 15, 2025    | 21 days     | Ready  |

#### Scheduled: November 25, 2025

| Site         | State | Network Migration Date | M365 Deployment Date | Buffer Days | Status |
| ------------ | ----- | ---------------------- | -------------------- | ----------- | ------ |
| Orlando      | FL    | November 25, 2025      | December 15, 2025    | 20 days     | Ready  |
| Jacksonville | FL    | November 25, 2025      | December 15, 2025    | 20 days     | Ready  |
| Pawtucket    | RI    | November 25, 2025      | December 15, 2025    | 20 days     | Ready  |

#### Scheduled: November 26, 2025

| Site           | State | Network Migration Date | M365 Deployment Date | Buffer Days | Status |
| -------------- | ----- | ---------------------- | -------------------- | ----------- | ------ |
| Denver         | CO    | November 26, 2025      | December 15, 2025    | 19 days     | Ready  |
| Las Vegas      | NV    | November 26, 2025      | December 15, 2025    | 19 days     | Ready  |
| Sparks         | NV    | November 26, 2025      | December 15, 2025    | 19 days     | Ready  |
| Salt Lake City | UT    | November 26, 2025      | December 15, 2025    | 19 days     | Ready  |

#### Verify Independently: Not on Network Migration Schedule (12 sites)

| Site        | State | Network Migration Date | M365 Deployment Date | Buffer Days | Status |
| ----------- | ----- | ---------------------- | -------------------- | ----------- | ------ |
| Tucson      | AZ    | Unknown                | December 15, 2025    | N/A         | Verify |
| Phoenix     | AZ    | Unknown                | December 15, 2025    | N/A         | Verify |
| Sacramento  | CA    | Unknown                | December 15, 2025    | N/A         | Verify |
| Union City  | CA    | Unknown                | December 18, 2025    | N/A         | Verify |
| Chula Vista | CA    | Unknown                | December 19, 2025    | N/A         | Verify |
| Fresno      | CA    | Unknown                | December 15, 2025    | N/A         | Verify |
| La Mirada   | CA    | Unknown                | December 20, 2025    | N/A         | Verify |
| Auburn      | WA    | Unknown                | December 23, 2025    | N/A         | Verify |
| Milwaukie   | OR    | Unknown                | December 26, 2025    | N/A         | Verify |
| Houston     | TX    | Unknown                | December 15, 2025    | N/A         | Verify |

### Pending Network Migrations

User Cutover follows a **phased approach** with pre-migration Dec 1-3 and main deployment dates:

**December 1 - 3:00 PM:**

- **Tucson, AZ** - Pre-migration: 12-01-25 (3:00 PM) | M365 Deploy: 12-15-25
- **Fresno, CA** - Pre-migration: 12-01-25 (3:00 PM) | M365 Deploy: 12-15-25
- **La Mirada, CA** - Pre-migration: 12-01-25 (3:00 PM) | M365 Deploy: 12-20-25

**December 2 - 3:00 PM:**

- **Auburn, WA** - Pre-migration: 12-02-25 (3:00 PM) | M365 Deploy: 12-23-25
- **Sacramento, CA** - Pre-migration: 12-02-25 (3:00 PM) | M365 Deploy: 12-15-25
- **Union City, CA** - Pre-migration: 12-02-25 (3:00 PM) | M365 Deploy: 12-18-25
- **Chula Vista, CA** - Pre-migration: 12-02-25 (3:00 PM) | M365 Deploy: 12-19-25

**December 3 - 3:00 PM:**

- **Milwaukie, OR** - Pre-migration: 12-03-25 (3:00 PM) | M365 Deploy: 12-26-25

**Other Sites (No Pre-Migration):**

- **Phoenix, AZ** - M365 Deploy: 12-15-25
- **Houston, TX** - M365 Deploy: 12-15-25

### Critical Path: Network to Deployment

{: .note }

> **Dependency Flow:**
>
> Network Migration (11-18, 11-20, 11-24, 11-25, 11-26)
> → Network Stabilization & Validation (11-27 through 12-14)
> → M365 On-Site Deployment Ready (12-15-2025)
>
> **All affected sites have 19-27 day buffer windows for network stabilization before M365 deployment on December 15, 2025.**

### Action Items by Role

**Step 1: Network Lead (By November 27)**

- Confirm network migration completion status for all 10 affected sites
- Provide status report to deployment team
- Escalate any delays or issues immediately

**Step 2: M365 Admin (By November 30)**

- Verify Azure AD Connect health status for all sites
- Test M365 tenant connectivity from each site location
- Confirm DNS resolution working properly
- Document any network-specific configuration needs

{: .highlight }

> **Status:** Network migration schedule is compatible with M365 deployment timeline. All 10 network-migrated sites have sufficient buffer time (19-27 days) for validation and stabilization before single-day deployment on December 15, 2025.

---

## Prerequisites

### Before Every Onsite Visit

- [ ] **Apple Devices App** - Installed on Windows PC (for iOS backup verification)
- [ ] **VPN Access** - Verified and tested
- [ ] **MS Teams Account** - Active and ready for serial number submissions
- [ ] **Network Connection Tools** - Ping/network diagnostic tools available
- [ ] **Backup Storage** - USB drive or cloud storage for temporary files

### Get Started

**Suleman Manji - Device Reset Coordinator**

- Email: `smanji@viyu.net`
- MS Teams: Available for serial number submissions

### User Communication (24 Hours Before Visit)

{: .note }

> **Send this message to site contact:**
>
> _"A technician will visit on [DATE] at [TIME] to migrate your devices to Impact Property Solutions. Please backup any important files and have both your Windows and iOS devices ready. The process typically takes 2-3 hours per user. Your device will be back and fully functional by end of visit."_

---

## Complete Workflow Overview

High-level overview of the migration process:

| Phase                                  | Description                                                                                   |
| -------------------------------------- | --------------------------------------------------------------------------------------------- |
| Phase 1: Backup (Before Reset)         | Printer mappings, OneDrive verification, browser bookmarks/passwords, iOS backup verification |
| Phase 2: Document & Submit             | Record serial numbers, submit to Suleman via Teams, wait for reset confirmation               |
| Phase 3: OOBE (Windows Setup)          | Boot device, Autopilot enrollment, verify applications installed                              |
| Phase 4: User Validation               | 3-point test with user present: Internet, RDP, Printing                                       |
| Phase 5: Post-OOBE Browser Restoration | Import bookmarks and passwords for Chrome, Edge, Firefox                                      |

---

## Windows Device Migration

### Important Contacts

- **Device Reset Issues:** Suleman Manji | 469-364-6343 | Teams
- **Network Issues:** Site Contact (check dispatch ticket)

### Step 1: Phase 1 - Backup (Before Reset)

Follow your dispatch ticket timing:

- [ ] Screenshot printer mappings (Save to Desktop as `PrinterBackup.png`)
- [ ] Verify OneDrive Known-Folder Backup is ON (Settings > Account > OneDrive)
- [ ] **CHROME:** Menu → Bookmarks → Bookmark Manager → Export → Desktop
- [ ] **EDGE:** Settings → Favorites → Export → Desktop
- [ ] **FIREFOX:** Bookmarks → Manage → Import → Export → Desktop
- [ ] **iOS Backup Verification:** Connect via USB → [Apple Devices app](https://apps.microsoft.com/detail/9np83lwlpz9k?hl=en-US&gl=US) → Verify recent backup exists (create new backup if none within last week)
- [ ] **CRITICAL:** Verify OneDrive 100% synced ([portal.office.com](https://portal.office.com)) BEFORE proceeding

### Step 2: Phase 2 - Document & Submit

- [ ] **Windows Serial:**
    - Settings → System → About → Look for device identifier
    - Format: ABC123XYZ (ALL CAPS, no spaces)
- [ ] **iOS Serial + UDID:**
    - Settings → General → About → "Serial Number"
    - UDID below it (or use Apple Configurator)
- [ ] **TEAMS MESSAGE TO SULEMAN (Suggested Format):**
    - `Windows Serial: ABC123XYZ | iOS Serial: DEF456UVW | iOS UDID: A1B2C3D4-E5F6-7890...`
- [ ] WAIT 15-30 MINUTES for reset confirmation
- [ ] During wait: Help next user backup, test network connectivity

{: .warning }

> **Important:** Do not proceed to OOBE until you have received confirmation that the device reset is complete.

### Step 3: Phase 3 - OOBE (Windows Out-of-Box Experience)

- [ ] Boot device after reset confirmation
- [ ] Connect to network (Ethernet preferred)
- [ ] Sign in with: `@impactpropertysolutions.com` email
- [ ] **DO NOT INTERRUPT AUTOPILOT ESP PAGE** - Let apps install automatically
- [ ] Wait 30-60 minutes for apps to finish installing (check status in ESP)

{: .note }

> **Timing Expectations:** Autopilot enrollment typically takes 30-45 minutes for up-to-date devices, but can take 2-3 hours for brand new devices that need Windows updates, driver updates, and application installations. Users can skip ESP and continue working, but must return to complete the setup process.

**After ESP Completes, Verify These Are Installed:**

- [ ] Outlook Classic (Launch & pin to taskbar)
- [ ] Teams (work/school account, pin to taskbar)
- [ ] Chrome (set as default browser)
- [ ] Foxit Reader (set as default PDF reader)
- [ ] NinjaOne RMM Agent (running)
- [ ] IPS.exe (optional - VPN profile backup only, not required for authentication with Modern Auth)
- [ ] OneDrive (syncing automatically)

### Step 4: Phase 4 - User Validation (3-Point Test with User Present)

**Have the user test these three items while you observe:**

| Test                   | Action                                                                                  | Confirmed |
| ---------------------- | --------------------------------------------------------------------------------------- | --------- |
| Internet Access        | Open browser and visit a website (e.g., google.com). Confirm connection is working.     | [ ]       |
| RFMS RDP Usability     | Test Remote Desktop connection to RFMS server. Confirm connectivity and responsiveness. | [ ]       |
| Printing Functionality | Send a test print job to the mapped printer. Confirm output is received.                | [ ]       |

{: .note }

> **Ask user to confirm:** All three items are working before you proceed to other devices.

### Step 5: Phase 5 - Post-OOBE Browser Restoration

- [ ] **CHROME:**
    - Open Chrome → Settings → Bookmarks → Bookmark Manager
    - Click three-dot menu → Import → Select `Chrome_Bookmarks_[USERNAME].html` from Desktop
    - Verify bookmarks appear in bookmark bar

- [ ] **EDGE:**
    - Settings → Profiles → Import browser data → Select `Edge_Bookmarks_[USERNAME].html`
    - For passwords: Autofill → Passwords → Import → Select CSV

- [ ] **FIREFOX:**
    - Library → Bookmarks → Manage → Import → Select `Firefox_Bookmarks_[USERNAME].html`

- [ ] **PASSWORDS:** Most cannot be bulk-restored (device-encrypted). User must:
    - Re-enter manually, OR
    - Use "Forgot Password" for important sites, OR
    - Use M365 password sync for work accounts

- [ ] **DELETE FROM DESKTOP:** All bookmark/password files after restoration confirmed (These files contain sensitive data)

---

## Post-Migration Validation Checklist

{: .note }

> **Primary Validation:** Phase 4 User Validation (3-Point Test) must be completed with user present before proceeding to browser restoration.

### Phase 4: User Validation (3-Point Test)

| Test Item              | Validation Step                                   | Status |
| ---------------------- | ------------------------------------------------- | ------ |
| Internet Access        | Open browser and visit website (e.g., google.com) | [ ]    |
| RFMS RDP Usability     | Test Remote Desktop connection to RFMS server     | [ ]    |
| Printing Functionality | Send test print job to mapped printer             | [ ]    |

### Additional Validation Items

| Item              | Device  | Validation Step                     | Status |
| ----------------- | ------- | ----------------------------------- | ------ |
| OneDrive Sync     | Windows | Check sync status in File Explorer  | [ ]    |
| Outlook           | Windows | Verify can send/receive email       | [ ]    |
| Teams             | Windows | Send test message                   | [ ]    |
| Browser Bookmarks | Windows | Verify bookmarks restored (Phase 5) | [ ]    |
| iOS Backup        | iOS     | Verify recent backup exists         | [ ]    |

---

## Expected Device Models

### Windows Devices

The organization has approximately 170 Windows devices across the fleet:

**HP Devices (71)**

- EliteBook 850 G8
- EliteBook 860 G9/G10/G11
- Various desktop models

**Lenovo Devices (99)**

- ThinkPad series variants
- X1, E, L series models
- Various desktop configurations

### Apple/iOS Devices

The organization has 500+ iOS devices across the fleet:

**iPhones**

- iPhone 12, 13, 15, 16e
- Various color/storage configurations

**iPads**

- iPad 7th, 8th, 9th, 10th generation
- iPad Air and iPad Pro variants

{: .note }

> **Tip:** Device models are provided for context. Refer to the user tracking spreadsheet for device-specific serial numbers and enrollment status during site visits.

---

## Troubleshooting Guide

### Autopilot Enrollment Issues

**Autopilot Enrollment Stalls or Shows Error**

- [ ] Restart the device and retry enrollment
- [ ] Verify network connection (Ethernet preferred)
- [ ] Check ESP screen for error messages
- [ ] If stuck >15 min: Skip OOBE and continue (contact Suleman for status)
- [ ] **DO NOT:** Force shutdown the device

### OneDrive & Data Sync Issues

**OneDrive Sync Not Starting**

- [ ] Verify user signed in with `@impactpropertysolutions.com` email
- [ ] Wait additional 2-3 minutes for initial sync to begin
- [ ] Manually open OneDrive and re-authenticate if needed
- [ ] Restart device if sync still not starting

### Network & Printing Issues

**Printer Mapping Failed**

- [ ] Verify printer IP address matches site printer IP in schedule
- [ ] Check network connectivity to printer (ping test)
- [ ] Test printer directly from site location
- [ ] Document failure and note in Issues/Notes column

**Internet Access Not Working**

- [ ] Verify network connection is active (WiFi or Ethernet)
- [ ] Restart network adapter
- [ ] Check if proxy is required and configured
- [ ] Verify DNS resolution (nslookup google.com)
- [ ] If still failing: Escalate to network team

**RFMS RDP Connection Failing**

- [ ] Verify RDP client is installed
- [ ] Confirm RFMS server IP/hostname is correct
- [ ] Check firewall rules allow RDP (port 3389)
- [ ] Verify user has permissions to connect
- [ ] If still failing: Contact RFMS support team

### Authentication Issues

**Teams or Outlook Not Authenticating**

- [ ] Clear app cache and restart application
- [ ] Verify user credentials are correct (@impactpropertysolutions.com)
- [ ] Check if MFA is required (ask user for phone)
- [ ] Try signing out and signing back in
- [ ] Document and escalate if persistent

### Device-Specific Troubleshooting

**HP EliteBook/Desktop Issues**

- [ ] BIOS boot order: May need to enable USB boot for Autopilot
- [ ] Network adapters: Ensure Intel/Realtek network drivers are available
- [ ] TPM: Verify TPM 2.0 is enabled in BIOS (required for Autopilot)
- [ ] Touchpad: May require driver from Intune after initial enrollment

**Lenovo ThinkPad/Desktop Issues**

- [ ] BIOS settings: Check for Secure Boot and UEFI requirements
- [ ] Vantage App: May auto-install; ensure Intune policies don't conflict
- [ ] ThinkPad TrackPoint: Drivers may require post-enrollment installation
- [ ] Docking stations: Test USB and video output post-enrollment

**iPad/iPhone Issues**

- [ ] WiFi connectivity: Ensure device connected to WiFi for backup verification
- [ ] Backup status: Check Apple Devices app for last backup date
- [ ] USB connection: If device not recognized, try different USB cable/port

---

## Important Contacts

### Primary Escalation Contact

**Suleman Manji**

- Role: Device Reset Coordinator & Support
- Email: `smanji@viyu.net`
- MS Teams: Direct message for serial submissions and device reset status

### Support Escalation

| Issue Type                  | Primary Contact | Escalation Chain                                | Contact Information                                                                                      |
| --------------------------- | --------------- | ----------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| Device Reset Delays         | Suleman Manji   | → Willie Day → Raymond Rodriguez                | `smanji@viyu.net`, `rrodriguez@ilginc.com`, `wdallas@ilginc.com`                                         |
| Network/Internet Issues     | Landon Hill     | → Nick Christian → Imran Saleem → Goutham Reddy | `lhill@viyu.net`, `nchristian@viyu.net`, `imran.saleem@ilginc.com`, `goutham.reddy@ilginc.com`           |
| RDP/RFMS Issues             | Brian Vaughan   | Primary escalation point                        | `bvaughan@impactpropertysolutions.com`, MS Teams direct message                                          |
| Printer Issues              | Brian Vaughan   | → Suleman Manji → Brett McGolrick → Sean Skeels | `bvaughan@impactpropertysolutions.com`, `smanji@viyu.net`, `rrodriguez@ilginc.com`, `wdallas@ilginc.com` |
| Intune/iOS/ABM Issues       | Suleman Manji   | Primary escalation point                        | `smanji@viyu.net`, `wdallas@ilginc.com`                                                                  |
| User Data / Identity Issues | Suleman Manji   | → Raymond Rodriguez                             | `smanji@viyu.net` (MS Teams), `rrodriguez@ilginc.com`                                                    |

---

## Documentation & Reporting

### During Visit

- [ ] Report any issues to Teams Chat
- [ ] Capture before/after screenshots for unusual configurations
- [ ] Record actual time spent per user

### After Visit

- [ ] Submit completed device list to Suleman via MS Teams
- [ ] Include: All serial numbers captured, any issues encountered
- [ ] Provide estimated time per user for future planning
- [ ] Note user feedback or concerns for support team
- [ ] Return all backup media and cables to site contact

---

_Impact Property Solutions - Onsite Migration Coordination Guide_

_Version 1.0 | Last Updated: 2025_

_For support, contact Suleman Manji at smanji@viyu.net_
