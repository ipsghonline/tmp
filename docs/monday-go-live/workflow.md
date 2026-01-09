---
layout: default
title: Migration Workflow
parent: Monday Go-Live
nav_order: 5
---

# Migration Workflow

Complete 5-phase migration process for Windows devices with iOS backup verification.

---

## Parallel Processing Strategy

{: .important }

> **Technicians handle up to 5 users simultaneously.** The phases below are per-user workflows. During wait periods (sync, reset, ESP), move to another user. Never sit idle waiting for one device.

**Recommended Approach:**

1. Set up multiple laptops in a conference room on a table
2. Walk around the table working on devices in rotation
3. When one device is waiting (sync, ESP, reset), start the next device
4. Track each user's current phase to avoid confusion

**Example Flow (5 users):**

- 0:00 - Start User A Phase 1 (backup)
- 0:05 - Start User B Phase 1 while A syncs
- 0:10 - Start User C Phase 1 while A/B sync
- 0:15 - User A sync complete → Submit reset (Phase 2)
- 0:20 - Start User D Phase 1, User B ready for Phase 2
- _(Continue rotating through users)_

---

## Workflow Overview

| Phase | Name                | Time Est. | Description                                           |
| ----- | ------------------- | --------- | ----------------------------------------------------- |
| 1     | Backup              | 20-30 min | OneDrive setup, browser profile, printers, iOS backup |
| 2     | Document & Submit   | 5-10 min  | Serial numbers, submit reset request to Suleman       |
|       | _(Wait for Reset)_  | 15-30 min | **→ Work on next user's Phase 1**                     |
| 3     | OOBE                | 30-90 min | Windows setup, Autopilot ESP, app installation        |
| 4     | User Validation     | 10-15 min | 3-point test: Internet, RDP, Printing                 |
| 5     | Browser Restoration | 10-15 min | Import bookmarks, passwords, cleanup                  |

**Total Active Time:** 75-120 minutes per user (parallel processing reduces wall-clock time significantly)

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

{: .note }

> **Estimated Time:** 20-30 minutes | Set up OneDrive, backup browser profile, printers, and iOS device before reset.

---

### Opening Script

> "Before we reset your device, we need to make sure all your files and settings are backed up. First, let's verify OneDrive is set up correctly - this is where all your backups will be stored. Then we'll backup your browser bookmarks and passwords, your printer settings, and verify your iPhone backup if you have one."

---

### OneDrive Setup & Verification

{: .important }

> **DO NOT SKIP:** OneDrive must be configured and fully synced before proceeding. Users may have circumvented Known Folder Policies.

**Step 1: Verify OneDrive Installation**

- Look for OneDrive icon in system tray (cloud icon, bottom right)
- If missing: Install from [onedrive.com](https://onedrive.com) or Microsoft Store

**Step 2: Sign In**

- Click OneDrive icon → Sign in
- Use **INGINC.com** account credentials
- Complete MFA if prompted

**Step 3: Enable Known Folder Backup**

1. Click OneDrive icon → Settings (gear icon)
2. Select **Sync and backup** tab
3. Click **Manage backup**
4. Enable all three folders:
    - ✓ Desktop
    - ✓ Documents
    - ✓ Pictures
5. Click **Start backup**

**Step 4: Wait for Sync**

- OneDrive icon shows sync arrows while uploading
- Large folders may take 15-30 minutes
- **While waiting:** Move to next user's Phase 1
- Return to verify green checkmark before this user's Phase 2

**Step 5: Verify Completion**

- OneDrive icon shows green checkmark ✓
- Visit [portal.office.com](https://portal.office.com) → OneDrive
- Confirm all files are present

> **Script:** "Click the cloud icon in your taskbar - bottom right corner. Do you see it? If it's not there, we need to install OneDrive first. Once you're signed in, let's make sure your Desktop, Documents, and Pictures folders are being backed up..."

---

### Browser Profile Backup

**Step 1: Enable Browser Sync**

| Browser     | Steps                                                                         | Verify                 |
| ----------- | ----------------------------------------------------------------------------- | ---------------------- |
| **Chrome**  | Menu (⋮) → Settings → You and Google → Turn on sync → Sign in with INGINC.com | "Sync is on" displays  |
| **Edge**    | Menu (···) → Settings → Profiles → Sync → Turn on sync                        | "Sync is on" displays  |
| **Firefox** | Menu (☰) → Settings → Sync → Sign in                                         | "Syncing" status shows |

**Step 2: Export Profile Data**

Save all exports to: `OneDrive > Documents > BrowserBackup`

**Chrome:**

- [ ] Bookmarks: Menu → Bookmarks → Bookmark Manager → ⋮ → Export bookmarks
- [ ] Passwords: Menu → Settings → Passwords → ⋮ → Export passwords (CSV)

**Edge:**

- [ ] Favorites: Menu → Favorites → ⋮ → Export favorites
- [ ] Passwords: Menu → Settings → Passwords → ⋮ → Export passwords (CSV)

**Firefox (if used):**

- [ ] Bookmarks: Menu → Bookmarks → Manage → Import/Export → Export to HTML

{: .warning }

> **Password Security:** Exported CSV files contain sensitive data. Delete from OneDrive after restoration is confirmed.

---

### Printer Configuration Backup

**Step 1:** Open Settings → Devices → Printers & scanners

**Step 2:** Take screenshot of all mapped printers (Win + Shift + S)

**Step 3:** Save to `OneDrive > Documents > PrinterBackup.png`

> **Script:** "Now let's capture your printer settings. Open Settings, then Devices, then Printers & scanners. Take a screenshot and save it to your OneDrive Documents folder."

---

### iOS Backup Verification

**Step 1:** Connect iOS device via USB cable

**Step 2:** Open [Apple Devices app](https://apps.microsoft.com/detail/9np83lwlpz9k)

- If not installed: Download from Microsoft Store

**Step 3:** Check backup status

- Verify recent backup exists (within last 24-48 hours)
- If no backup exists, click **Back Up Now**

> **Script:** "If you have an iPhone or iPad, connect it via USB. Open the Apple Devices app and check when the last backup was. If it's older than a day or two, let's create a fresh backup now."

---

### Phase 1 Checklist

Before proceeding to Phase 2:

- [ ] OneDrive signed in with INGINC.com account
- [ ] Known Folder Backup enabled (Desktop, Documents, Pictures)
- [ ] OneDrive sync complete (green checkmark)
- [ ] Browser sync enabled
- [ ] Browser bookmarks/passwords exported to OneDrive
- [ ] Printer configuration screenshot saved
- [ ] iOS backup verified or created (if applicable)

{: .important }

> **Checkpoint:** Do not request THIS USER's device reset until ALL items above are complete for THIS USER. While waiting for sync, start another user's Phase 1. Data loss cannot be recovered after reset.

---

## Phase 2: Document & Submit

{: .note }

> **Estimated Time:** 5-10 minutes | Collect device serial numbers and submit reset request.

---

### Opening Script

> "Great, your backups are complete. Now I need to collect your device serial numbers so we can request the reset. This will just take a minute, then we'll have a 15-30 minute wait while IT processes the reset request."

---

### Windows Serial Number

**Step 1:** Open Settings → System → About

**Step 2:** Locate "Device ID" or serial number

**Step 3:** Record serial number (format: `ABC123XYZ` - ALL CAPS, no spaces)

---

### iOS Serial + UDID (for inventory)

**Step 1:** On iOS device: Settings → General → About

**Step 2:** Record Serial Number (e.g., `DEF456UVW`)

**Step 3:** Record UDID (listed below serial, or use Apple Configurator)

---

### Submit Reset Request

**Step 1:** Open Microsoft Teams

**Step 2:** Message Suleman Manji (`smanji@viyu.net`)

**Step 3:** Send using this format:

```
Windows Serial: ABC123XYZ | iOS Serial: DEF456UVW | iOS UDID: A1B2C3D4-E5F6-7890...
```

---

### Phase 2 Checklist

- [ ] Windows serial number recorded
- [ ] iOS serial and UDID recorded (if applicable)
- [ ] Reset request sent to Suleman via Teams

{: .warning }

> **Wait Period:** 15-30 minutes for reset confirmation. During wait: Help next user with Phase 1, test network connectivity, or take a break.

---

## Phase 3: OOBE (Windows Out-of-Box Experience)

{: .note }

> **Estimated Time:** 30-90 minutes | Windows setup, Autopilot enrollment, and app installation.

---

### Opening Script

> "Your device has been reset. Now we'll walk through the initial setup together. This process takes 30-60 minutes for the apps to install, so let's get it started and I'll check back with you when it's done."

---

### Device Boot & Network

**Step 1:** Boot device after reset confirmation received

**Step 2:** Connect to network

- **Ethernet preferred** (faster, more reliable)
- WiFi acceptable if Ethernet not available

**Step 3:** Select language and region, accept terms

---

### Organizational Sign-In

**Step 1:** When prompted, sign in with `@impactpropertysolutions.com` email

**Step 2:** Complete MFA verification

{: .warning }

> **Do NOT create a local account.** Always use organizational sign-in.

---

### Autopilot ESP (Enrollment Status Page)

{: .important }

> **DO NOT INTERRUPT:** The device will show "Setting up your device" with app installation progress. This takes 30-60 minutes. Do not power off, disconnect, or close this screen.

{: .note }

> **While ESP runs:** This is the longest wait period (30-60 min). Work on other users' Phase 1-2 or validate completed devices.

**Step 1:** Wait for ESP to complete

- Progress bar shows app installation status
- Device may restart 1-2 times (normal)
- Typical time: 30-45 minutes for updated devices
- Can take 2-3 hours for new devices needing Windows updates

**Step 2:** Desktop appears when complete

> **Script:** "You should see a screen that says 'Setting up your device' - this is installing all your work applications. It will take about 30-60 minutes. Please don't turn off your computer or close this screen. I'll check back with you in about 45 minutes, or call me when you see your desktop."

---

### Phase 3 Checklist

After ESP completes, verify these applications:

- [ ] Outlook Classic (launch & pin to taskbar)
- [ ] Teams (work/school account, pin to taskbar)
- [ ] Chrome (set as default browser)
- [ ] Foxit Reader (set as default PDF reader)
- [ ] NinjaOne RMM Agent (running in system tray)
- [ ] IPS.exe (optional - VPN profile)
- [ ] OneDrive (syncing automatically)

---

## Phase 4: User Validation (3-Point Test)

{: .note }

> **Estimated Time:** 10-15 minutes | User-present validation of core functionality.

---

### Opening Script

> "Everything looks installed. Before I move on, I need you to test three things to make sure your device is fully working. This will only take a few minutes."

---

### Test 1: Internet Access

**Step 1:** Open Chrome browser

**Step 2:** Navigate to google.com

**Step 3:** Confirm page loads successfully

> **Script:** "First, let's test your internet. Open Chrome and go to google.com. Does the page load? Great!"

---

### Test 2: RFMS RDP Connection

**Step 1:** Open Remote Desktop Connection (search "Remote Desktop" in Start)

**Step 2:** Connect to RFMS server address

**Step 3:** Confirm session opens and is responsive

> **Script:** "Now let's test RFMS access. Open Remote Desktop and connect to your RFMS server. Can you see the login screen? Is it responsive?"

---

### Test 3: Printing

**Step 1:** Open Notepad, type "Test"

**Step 2:** File → Print → Select your printer

**Step 3:** Confirm printout is received

> **Script:** "Last test - printing. Open Notepad, type something, and try to print. Did a page come out? Perfect!"

---

### Phase 4 Checklist

{: .important }

> **User must confirm** all three tests pass before proceeding.

- [ ] Internet access confirmed by user
- [ ] RFMS RDP connection confirmed by user
- [ ] Printing confirmed by user

---

## Phase 5: Browser Restoration

{: .note }

> **Estimated Time:** 10-15 minutes | Import bookmarks and passwords from OneDrive backup.

---

### Opening Script

> "Now let's restore your browser bookmarks and passwords. Remember those files we saved to OneDrive earlier? We're going to import them back into your browsers."

---

### Chrome Restoration

**Step 1:** Open Chrome → Menu (⋮) → Bookmarks → Bookmark Manager

**Step 2:** Click ⋮ → Import bookmarks

**Step 3:** Navigate to OneDrive → Documents → BrowserBackup

**Step 4:** Select your Chrome bookmarks file

**Step 5:** For passwords: Settings → Passwords → ⋮ → Import → Select CSV file

> **Script:** "Open Chrome, go to the three-dot menu, then Bookmarks, then Bookmark Manager. Click the three dots again and select Import. Navigate to your OneDrive Documents folder, then BrowserBackup, and select your bookmarks file."

---

### Edge Restoration

**Step 1:** Open Edge → Settings → Profiles → Import browser data

**Step 2:** Select "Favorites or bookmarks HTML file"

**Step 3:** Navigate to OneDrive → Documents → BrowserBackup

**Step 4:** Select your Edge favorites file

**Step 5:** For passwords: Settings → Passwords → ⋮ → Import

---

### Firefox Restoration (if used)

**Step 1:** Menu (☰) → Bookmarks → Manage Bookmarks

**Step 2:** Import and Backup → Import Bookmarks from HTML

**Step 3:** Select your Firefox bookmarks file from OneDrive

---

### Cleanup

{: .warning }

> **Security:** Delete all backup files from OneDrive after restoration is confirmed. These files contain sensitive password data.

**Step 1:** Open OneDrive → Documents → BrowserBackup

**Step 2:** Delete all exported files

**Step 3:** Empty Recycle Bin

---

### Phase 5 Checklist

- [ ] Chrome bookmarks restored
- [ ] Chrome passwords imported (if exported)
- [ ] Edge favorites restored (if used)
- [ ] Firefox bookmarks restored (if used)
- [ ] Backup files deleted from OneDrive

{: .important }

> **Migration Complete!** User's device is fully migrated and ready for use.

---

## Post-Migration Validation

{: .note }

> **Summary:** This checklist consolidates all validation steps from the 5-phase workflow.

### Validation Checklist

| Phase | Item                 | Validation Step                            | Status |
| ----- | -------------------- | ------------------------------------------ | ------ |
| 1     | OneDrive Setup       | Known Folder Backup enabled, sync complete | ☐      |
| 1     | Browser Backup       | Bookmarks/passwords exported to OneDrive   | ☐      |
| 1     | iOS Backup           | Recent backup verified (if applicable)     | ☐      |
| 3     | Apps Installed       | Outlook, Teams, Chrome, Foxit, NinjaOne    | ☐      |
| 4     | Internet Access      | Browser loads google.com                   | ☐      |
| 4     | RFMS RDP             | Remote Desktop connection works            | ☐      |
| 4     | Printing             | Test print successful                      | ☐      |
| 5     | Bookmarks Restored   | Imported from OneDrive backup              | ☐      |
| 5     | Backup Files Deleted | Removed sensitive exports from OneDrive    | ☐      |
