---
layout: default
title: Migration Workflow
parent: Monday Go-Live
nav_order: 5
---

# Migration Workflow

Complete 6-phase migration process for Windows devices and iOS backup verification.

---

## Workflow Overview

| Phase | Name                    | Time Est. | Description                                                                      |
| ----- | ----------------------- | --------- | -------------------------------------------------------------------------------- |
| 1     | Backup                  | 15-20 min | Printer mappings, OneDrive verification, browser bookmarks/passwords, iOS backup |
| 2     | Document & Submit       | 5-10 min  | Record serial numbers, submit to Suleman via Teams, wait for reset confirmation  |
|       | _(Wait for Reset)_      | 15-30 min | Use this time to help next user with backup phase                                |
| 3     | OOBE                    | 30-60 min | Boot device, Autopilot enrollment, verify applications installed                 |
| 4     | User Validation         | 10-15 min | 3-point test with user present: Internet, RDP, Printing                          |
| 5     | Browser Restoration     | 10-15 min | Import bookmarks and passwords for Chrome, Edge, Firefox                         |
| 6     | iOS Backup Verification | 5-10 min  | Verify recent backup exists using Apple Devices app                              |

**Total Active Time:** 60-90 minutes per user (parallel processing reduces wall-clock time significantly)

---

## Quick Reference Contacts

| Issue               | Contact       | Phone/Method                         |
| ------------------- | ------------- | ------------------------------------ |
| Device Reset Issues | Suleman Manji | 469-364-6222 / Teams                 |
| RFMS/Floorsight     | Brian Vaughan | bvaughan@impactpropertysolutions.com |
| Network/VPN Issues  | Landon Hill   | lhill@viyu.net                       |

---

## Troubleshooting Quick Reference

{: .warning }

> **Common issues and quick fixes during migration.**

| Issue                    | Likely Cause             | Quick Fix                                             |
| ------------------------ | ------------------------ | ----------------------------------------------------- |
| ESP taking >60 min       | Network/bandwidth issues | Check connectivity; may need device restart and retry |
| Bookmarks won't import   | Wrong file format        | Verify exported as .html (not .json)                  |
| OneDrive not syncing     | Initial sync delay       | Wait 15-30 min; try sign out/in                       |
| Printer not appearing    | Driver not deployed      | Use Phase 1 screenshot, add manually via Settings     |
| Apps missing after ESP   | Deployment delay         | Wait 10 min, check Intune portal for status           |
| User can't find settings | Not familiar with Win 11 | Windows key + I opens Settings                        |
| RFMS RDP fails           | Network or DNS issue     | Verify VPN; contact Brian Vaughan                     |
| Chrome profile issues    | Sync conflict            | Create new profile, import bookmarks fresh            |

---

## Phase 1: Backup (Before Reset)

{: .important }

> **Estimated Time: 15-20 minutes** | Complete all backups BEFORE requesting device reset. This is a one-way process.

---

### Opening Script (Remote Support)

> "Before we reset your device, we need to backup your browser profile and verify your files are synced to the cloud. This ensures you won't lose any saved websites, passwords, or browsing history. Let's start with your browser..."

---

### Browser Profile Backup

{: .note }

> **Primary Method:** Enable browser sync with your INGINC.com account. This automatically backs up bookmarks, passwords, history, and settings to the cloud.

#### Step 1: Enable Browser Sync

| Browser     | Steps                                                                         | Verify                 |
| ----------- | ----------------------------------------------------------------------------- | ---------------------- |
| **Chrome**  | Menu (⋮) → Settings → You and Google → Turn on sync → Sign in with INGINC.com | "Sync is on" displays  |
| **Edge**    | Menu (···) → Settings → Profiles → Sync → Turn on sync                        | "Sync is on" displays  |
| **Firefox** | Menu (☰) → Settings → Sync → Sign in                                         | "Syncing" status shows |

#### Step 2: Export Profile Data (Backup Copy)

Save all exports to: `OneDrive > Documents > BrowserBackup`

**Chrome:**

- [ ] **Bookmarks:** Menu → Bookmarks → Bookmark Manager → ⋮ → Export bookmarks
- [ ] **Passwords:** Menu → Settings → Passwords → ⋮ → Export passwords (CSV)
- [ ] **History:** Menu → History → Export (or use extension)

**Edge:**

- [ ] **Favorites:** Menu → Favorites → ⋮ → Export favorites
- [ ] **Passwords:** Menu → Settings → Passwords → ⋮ → Export passwords (CSV)

**Firefox (if used):**

- [ ] **Bookmarks:** Menu → Bookmarks → Manage → Import/Export → Export to HTML

{: .warning }

> **Password Security:** Exported password CSV files contain sensitive data. Delete from OneDrive after restoration is confirmed.

---

### Printer Configuration Backup

- [ ] Open Settings → Devices → Printers & scanners
- [ ] Screenshot all mapped printers
- [ ] Save to `OneDrive > Documents > PrinterBackup.png`

> **Script:** "Now let's backup your printer settings. Open Settings, then Devices, then Printers & scanners. Take a screenshot showing all your printers and save it to your OneDrive Documents folder."

---

### OneDrive Verification

{: .important }

> **DO NOT PROCEED** until OneDrive shows 100% sync completion. This is critical for data safety.

- [ ] Verify OneDrive Known-Folder Backup is ON (Settings → Account → Manage backup)
- [ ] Check OneDrive icon in taskbar shows green checkmark (synced)
- [ ] Verify at [portal.office.com](https://portal.office.com) → OneDrive → All files present

> **Script:** "This is very important - we need to make sure all your files are backed up to OneDrive. Check the OneDrive icon in your taskbar - it should show a green checkmark. Can you confirm all your files are synced? We cannot proceed until OneDrive shows 100% complete."

---

### iOS Backup Verification

{: .note }

> **Scope:** End user migration verifies backup only. iOS device reset/restore/ABM enrollment is handled separately.

- [ ] Connect iOS device via USB
- [ ] Open [Apple Devices app](https://apps.microsoft.com/detail/9np83lwlpz9k)
- [ ] Verify recent backup exists (within last 24-48 hours)
- [ ] If no backup exists, create one now

> **Script:** "If you have an iPhone or iPad, let's verify your backup. Connect it via USB and open the Apple Devices app. Check the backup date - it should be recent. If there's no backup, we'll create one now."

---

## Phase 2: Document & Submit

### Windows Serial Number

1. Settings → System → About → Look for device identifier
2. Format: `ABC123XYZ` (ALL CAPS, no spaces)

### iOS Serial + UDID (for inventory)

1. Settings → General → About → "Serial Number"
2. UDID below it (or use Apple Configurator)

### Teams Message to Suleman (Suggested Format)

```
Windows Serial: ABC123XYZ | iOS Serial: DEF456UVW | iOS UDID: A1B2C3D4-E5F6-7890...
```

{: .warning }

> **WAIT 15-30 MINUTES** for reset confirmation before proceeding. During wait: Help next user backup, test network connectivity.

---

## Phase 3: OOBE (Windows Out-of-Box Experience)

### Steps

1. Boot device after reset confirmation
2. Connect to network (**Ethernet preferred**)
3. Sign in with: `@impactpropertysolutions.com` email
4. **DO NOT INTERRUPT AUTOPILOT ESP PAGE** — Let apps install automatically
5. Wait 30-60 minutes for apps to finish installing

{: .note }

> **Timing Expectations:** Autopilot enrollment typically takes 30-45 minutes for up-to-date devices, but can take 2-3 hours for brand new devices that need Windows updates, driver updates, and application installations.

### After ESP Completes, Verify These Are Installed

- [ ] Outlook Classic (Launch & pin to taskbar)
- [ ] Teams (work/school account, pin to taskbar)
- [ ] Chrome (set as default browser)
- [ ] Foxit Reader (set as default PDF reader)
- [ ] NinjaOne RMM Agent (running)
- [ ] IPS.exe (optional - VPN profile backup only)
- [ ] OneDrive (syncing automatically)

---

## Phase 4: User Validation (3-Point Test)

{: .important }

> **Have the user test these three items while you observe:**

### Internet Access

Open browser and visit a website (e.g., google.com). Confirm connection is working.

### RFMS RDP Usability

Test Remote Desktop connection to RFMS server. Confirm connectivity and responsiveness.

### Printing Functionality

Send a test print job to the mapped printer. Confirm output is received.

{: .note }

> **Ask user to confirm:** All three items are working before you proceed to other devices.

---

## Phase 5: Browser Restoration

### Chrome

1. Open Chrome → Settings → Bookmarks → Bookmark Manager
2. Click ⋮ → Import → Select `Chrome_Bookmarks_[USERNAME].html` from Desktop
3. Verify bookmarks appear in bookmark bar

### Edge

1. Settings → Profiles → Import browser data
2. Select `Edge_Bookmarks_[USERNAME].html`
3. For passwords: Autofill → Passwords → Import → Select CSV

### Firefox

1. Library → Bookmarks → Manage → Import
2. Select `Firefox_Bookmarks_[USERNAME].html`

### Passwords Note

Most passwords cannot be bulk-restored (device-encrypted). User must:

- Re-enter manually, OR
- Use "Forgot Password" for important sites, OR
- Use M365 password sync for work accounts

{: .warning }

> **DELETE FROM DESKTOP:** All bookmark/password files after restoration confirmed. These files contain sensitive data.

---

## Phase 6: iOS Backup Verification

{: .note }

> **Scope:** End user migration verifies backup only. iOS device reset/restore/ABM enrollment is handled separately.

### Verification Steps

1. Connect iOS device via USB
2. Open [Apple Devices app](https://apps.microsoft.com/detail/9np83lwlpz9k)
3. Verify a recent backup exists (within last 24-48 hours)
4. If no backup exists, create one now before proceeding
5. Document backup status in migration notes

### What to Verify

- [ ] Backup date is recent
- [ ] Backup completed successfully (no errors)
- [ ] Device appears in Apple Devices app

---

## Post-Migration Validation

{: .note }

> **Primary Validation:** Phase 4 User Validation (3-Point Test) must be completed with user present before proceeding to browser restoration.

### Validation Checklist

| Item                   | Device  | Validation Step                    | Status |
| ---------------------- | ------- | ---------------------------------- | ------ |
| Internet Access        | Windows | Open browser and visit website     | ☐      |
| RFMS RDP Usability     | Windows | Test Remote Desktop connection     | ☐      |
| Printing Functionality | Windows | Send test print job                | ☐      |
| OneDrive Sync          | Windows | Check sync status in File Explorer | ☐      |
| Outlook                | Windows | Verify can send/receive email      | ☐      |
| Teams                  | Windows | Send test message                  | ☐      |
| Browser Bookmarks      | Windows | Verify bookmarks restored          | ☐      |
| iOS Backup             | iOS     | Verify recent backup exists        | ☐      |
