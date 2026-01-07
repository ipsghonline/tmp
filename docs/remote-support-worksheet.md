---
layout: default
title: Remote Support Migration Worksheet
nav_order: 1
parent: End User Documentation
---

# Remote Support Migration Worksheet

{: .no_toc }

Service Engineer Guide for Small Site Migrations (<5 users)
{: .fs-5 .fw-300 }

---

## Table of Contents

{: .no_toc .text-delta }

1. TOC
   {:toc}

---

## Overview

This worksheet guides service engineers through the complete remote migration process for Impact Property Solutions devices. The process consists of 8 phases and typically takes 60-90 minutes of active time.

{: .note }

> **Original Interactive Version:** This is a static reference version of the interactive HTML worksheet. The original version with progress tracking and form auto-save is available at the [Interactive Remote Support Worksheet](../../Impact_Remote_Support_Migration_Worksheet.html).

---

## Call Information

Record the following information at the start of each support call:

| Field                     | Description                                            |
| ------------------------- | ------------------------------------------------------ |
| **Call Date**             | Date of the support call                               |
| **Call Start Time**       | Time the call began                                    |
| **Service Engineer Name** | Your full name                                         |
| **Site Name**             | e.g., El Paso, TX                                      |
| **End User Name**         | User's full name                                       |
| **User Email**            | user@impactpropertysolutions.com                       |
| **User Phone Number**     | (XXX) XXX-XXXX                                         |
| **Communication Method**  | Phone Call / Microsoft Teams / Teams with Screen Share |
| **Total Users at Site**   | 1-4 users                                              |

---

## Pre-Call Preparation

{: .important }

> **Before starting the call:** Review site information, verify user has devices ready, and confirm they have 60-90 minutes available.

### Pre-Call Checklist

- [ ] Reviewed site information from dispatch ticket (if available)
- [ ] Confirmed user has Windows device and iOS device (if applicable) ready
- [ ] Confirmed user has 60-90 minutes available for migration
- [ ] Confirmed user has stable internet connection (wired Ethernet preferred)
- [ ] If using Teams, confirmed user can share screen (optional but recommended)

### Opening Script

> "Hi [User Name], this is [Your Name] from Impact Property Solutions IT support. I'm calling to help you migrate your devices to our new system. This process will take about 60-90 minutes. Do you have that time available right now? Great! Let's get started. First, I need to verify a few things..."

---

## Phase 1: Pre-Migration Backup (BEFORE RESET)

{: .warning }

> **CRITICAL:** All backups must be completed and verified BEFORE requesting device reset. This is a one-way process.

**Estimated Time:** 15-20 minutes

### Browser Profile Data Backup

{: .important }

> **Complete Browser Backup:** Modern browsers store much more than bookmarks - passwords, extensions, autofill data, and settings. This section ensures ALL critical browser data is either synced to the cloud or exported for restoration.

> **Script:** "Before we reset your device, we need to backup your browser data. This includes your bookmarks, saved passwords, and other important settings. Let's go through each browser you use..."

#### Step 1: Verify Browser Sync Status

> **Script:** "First, let's check if your browsers are signed in and syncing. This is the best way to preserve your data because it will automatically restore after migration."

**Google Chrome Sync:**

> **Script:** "Open Chrome and click your profile picture in the top-right corner. Does it show your Google account email, or does it say 'Sign in to Chrome'? If you're signed in, click your profile picture and then 'Sync is on' - can you confirm sync is enabled for bookmarks, passwords, and extensions?"

- [ ] **Chrome Signed In:** User confirmed signed into Google account
- [ ] **Chrome Sync Enabled:** Settings → You and Google → Sync → Sync is ON
- [ ] **Chrome Sync Items:** Verified syncing: Bookmarks, Passwords, Extensions, Settings

**Microsoft Edge Sync:**

> **Script:** "Now let's check Edge. Open Edge and click your profile picture in the top-right. Are you signed in with your Microsoft account? Click on your profile and check if sync is enabled."

- [ ] **Edge Signed In:** User confirmed signed into Microsoft account
- [ ] **Edge Sync Enabled:** Settings → Profiles → Sync → Sync is ON
- [ ] **Edge Sync Items:** Verified syncing: Favorites, Passwords, Extensions, Settings

**Firefox Sync (if used):**

- [ ] **Firefox Signed In:** User signed into Firefox Account
- [ ] **Firefox Sync Enabled:** Settings → Sync → Sync is ON
- [ ] **N/A - Firefox Not Used**

{: .highlight }

> **If Sync is Enabled:** Most data will automatically restore when user signs back into the browser after migration. Still export bookmarks as backup.

---

#### Step 2: Export Bookmarks (All Browsers)

> **Script:** "Even with sync enabled, let's export your bookmarks as a backup file. This gives us a safety net."

**Chrome Bookmarks Export:**

> **Script:** "In Chrome, press Ctrl+Shift+O to open Bookmark Manager. Click the three dots menu in the top-right of the Bookmark Manager, then click 'Export bookmarks'. Save the file to your Desktop as 'Chrome_Bookmarks.html'."

- [ ] **Chrome Bookmarks Exported:** Ctrl+Shift+O → ⋮ Menu → Export bookmarks → Saved to Desktop

**Edge Favorites Export:**

> **Script:** "In Edge, press Ctrl+Shift+O to open Favorites. Click the three dots menu, then 'Export favorites'. Save to Desktop as 'Edge_Favorites.html'."

- [ ] **Edge Favorites Exported:** Ctrl+Shift+O → ⋮ Menu → Export favorites → Saved to Desktop

**Firefox Bookmarks Export (if used):**

- [ ] **Firefox Bookmarks Exported:** Ctrl+Shift+O → Import/Export → Export to HTML → Saved to Desktop
- [ ] **N/A - Firefox Not Used**

---

#### Step 3: Export Saved Passwords

{: .warning }

> **Security Note:** Password export files contain sensitive data in plain text. These MUST be deleted after migration is complete.

> **Script:** "Now let's backup your saved passwords. This file will contain your passwords in readable form, so we'll delete it after migration. But it's important to have this backup in case sync doesn't restore everything."

**Chrome Passwords Export:**

> **Script:** "In Chrome, go to Settings, then click 'Passwords' or search for 'passwords' in the settings search. Click the three dots next to 'Saved Passwords' and select 'Export passwords'. You'll need to enter your Windows password. Save the file to your Desktop as 'Chrome_Passwords.csv'."

- [ ] **Chrome Passwords Exported:** Settings → Passwords → ⋮ → Export passwords → Saved to Desktop as CSV
- [ ] **No Saved Passwords in Chrome**

**Edge Passwords Export:**

> **Script:** "In Edge, go to Settings, then Passwords. Click the three dots next to 'Saved passwords' and select 'Export passwords'. Save to Desktop as 'Edge_Passwords.csv'."

- [ ] **Edge Passwords Exported:** Settings → Passwords → ⋮ → Export passwords → Saved to Desktop as CSV
- [ ] **No Saved Passwords in Edge**

{: .danger }

> **CRITICAL:** Password CSV files contain plain-text passwords. Remind user to DELETE these files after migration and empty Recycle Bin.

---

#### Step 4: Document Installed Extensions

> **Script:** "Let's take a screenshot of your browser extensions so you know which ones to reinstall. Extensions don't always sync automatically."

**Chrome Extensions:**

> **Script:** "In Chrome, type 'chrome://extensions' in the address bar and press Enter. Take a screenshot of this page and save it to your Desktop as 'Chrome_Extensions.png'."

- [ ] **Chrome Extensions Screenshot:** chrome://extensions → Screenshot saved to Desktop

**Edge Extensions:**

> **Script:** "In Edge, type 'edge://extensions' in the address bar. Take a screenshot and save as 'Edge_Extensions.png'."

- [ ] **Edge Extensions Screenshot:** edge://extensions → Screenshot saved to Desktop

---

#### Step 5: Move Backup Files to OneDrive

> **Script:** "Now let's move all these browser backup files to your OneDrive Documents folder so they're safely backed up before the reset."

- [ ] **Bookmark Files Moved:** All bookmark HTML files moved to OneDrive Documents
- [ ] **Password Files Moved:** All password CSV files moved to OneDrive Documents
- [ ] **Extension Screenshots Moved:** All extension screenshots moved to OneDrive Documents

**Browser Backup Files Checklist:**

| File                  | Location | Moved to OneDrive |
| --------------------- | -------- | ----------------- |
| Chrome_Bookmarks.html | Desktop  | [ ] Yes           |
| Edge_Favorites.html   | Desktop  | [ ] Yes           |
| Chrome_Passwords.csv  | Desktop  | [ ] Yes           |
| Edge_Passwords.csv    | Desktop  | [ ] Yes           |
| Chrome_Extensions.png | Desktop  | [ ] Yes           |
| Edge_Extensions.png   | Desktop  | [ ] Yes           |

{: .note }

> **What Will Auto-Restore vs Manual:**
>
> - **Auto-restore (if synced):** Bookmarks, passwords, some settings, browser history
> - **Manual reinstall required:** Extensions, custom themes, site-specific settings
> - **Cannot be transferred:** Cookies, active sessions (user will need to re-login to websites)

### Printer Configuration Backup

> **Script:** "Now let's backup your printer settings. Please open Settings -> Devices -> Printers & scanners. Take a screenshot showing all your printers and save it to your Desktop as 'PrinterBackup.png'."

- [ ] **Printer Screenshot:** User took screenshot of printer mappings and saved to Desktop as "PrinterBackup.png"

### WiFi Network Backup

> **Script:** "Now let's record your WiFi network name so we can reconnect after the reset. Please click on the WiFi icon in the taskbar - that's the wireless symbol in the bottom right corner. Can you tell me the name of the network you're currently connected to? I'll record that as your primary WiFi network."

- [ ] **WiFi SSID Recorded:** User identified currently connected WiFi network name

**Current WiFi Network (SSID):** **\*\*\*\***\*\*\*\***\*\*\*\***\_\_**\*\*\*\***\*\*\*\***\*\*\*\***

{: .note }

> **Why this matters:** After the device reset, the user will need to reconnect to WiFi during the OOBE setup. Having the exact SSID documented ensures a smooth reconnection, especially if there are multiple similar network names at the site.

### Outlook Data Files Backup (OST/PST)

{: .warning }

> **IMPORTANT:** Outlook OST and PST files are NOT automatically backed up by OneDrive. These files contain locally cached emails and archived mail that could be lost during reset.

> **Script:** "Before we verify OneDrive, we need to check for any Outlook data files on your computer. These are special files that store your email archives and won't sync automatically. Let me guide you through finding and moving them."

#### Locate Outlook Data Files

> **Script:** "Please open File Explorer and paste this path into the address bar: `%LOCALAPPDATA%\Microsoft\Outlook`. Press Enter. Do you see any files ending in .ost or .pst? If so, we need to copy those to your OneDrive Documents folder."

**Default OST/PST Location:** `%LOCALAPPDATA%\Microsoft\Outlook`

- [ ] **Checked Default Location:** User navigated to `%LOCALAPPDATA%\Microsoft\Outlook`
- [ ] **OST Files Found:** **\_\_\_** OST file(s) found (cached mailbox data)
- [ ] **PST Files Found:** **\_\_\_** PST file(s) found (archived mail)

#### Move PST Files to OneDrive

> **Script:** "For any PST files you found, please copy them to your OneDrive Documents folder. Right-click the file, select Copy, then navigate to your Documents folder and paste. OST files don't need to be moved - they'll be recreated automatically. But PST files contain your personal archives and must be backed up."

{: .note }

> **OST vs PST:**
>
> - **OST files** = Cached copy of your mailbox (will be recreated after migration)
> - **PST files** = Personal archives YOU created (must be manually backed up)

- [ ] **PST Files Moved:** All PST files copied to OneDrive Documents folder
- [ ] **No PST Files:** User confirmed no PST files exist (skip if N/A)

**PST Files Backed Up:**

| Filename     | Size     | Moved to OneDrive |
| ------------ | -------- | ----------------- |
| **\_\_\_\_** | \_\_\_\_ | [ ] Yes           |
| **\_\_\_\_** | \_\_\_\_ | [ ] Yes           |

### OneDrive Verification

> **Script:** "Now let's make sure everything is backed up to OneDrive, including those Outlook files we just moved. Please open a web browser and go to portal.office.com. Sign in and check your OneDrive. Can you confirm all your files show a green checkmark indicating they're synced? Great! We cannot proceed until OneDrive shows 100% complete."

- [ ] **OneDrive Known-Folder Backup:** Verified ON (Settings -> Account -> OneDrive -> Manage backup)
- [ ] **OneDrive 100% Synced:** Verified at portal.office.com - all files show as synced
- [ ] **PST Files Visible in OneDrive:** Confirmed PST files appear in OneDrive Documents (if applicable)

{: .danger }

> **DO NOT PROCEED** until OneDrive shows 100% sync completion. This is critical for data safety.

### iOS Device Backup (If Applicable)

> **Script:** "If you have an iPhone or iPad, we need to backup that too. First, please install the 'Apple Devices' app from the Microsoft Store if you don't have it. Then connect your iOS device via USB cable. When prompted, tap 'Trust' on your device. Then in the Apple Devices app, click 'Backup' and wait for it to complete."

- [ ] **iOS Device Present:** User has iOS device that needs migration
- [ ] **Apple Devices App:** Installed on Windows PC (Microsoft Store)
- [ ] **iOS Backup Complete:** Connected via USB, Apple Devices app -> Backup -> Completed

---

## Phase 2: Device Documentation & Reset Request

**Estimated Time:** 5-10 minutes to document, then 15-30 minute wait for reset confirmation

### Windows Device Serial Number

> **Script:** "Now I need to get your device serial numbers. For your Windows computer, please go to Settings, then System, then About. Look for the device identifier or serial number. Can you read that to me? Please use all capital letters and no spaces."

- [ ] **Windows Serial Recorded:** Settings -> System -> About -> Device identifier

**Windows Serial Number:** \***\*\*\*\*\***\_\_\***\*\*\*\*\*** (ALL CAPS, no spaces)

### iOS Device Information (If Applicable)

> **Script:** "For your iPhone/iPad, please go to Settings, then General, then About. I need both the Serial Number and the UDID. The UDID might be below the serial number. Can you read both to me?"

- [ ] **iOS Serial Recorded:** Settings -> General -> About -> Serial Number
- [ ] **iOS UDID Recorded:** Settings -> General -> About -> UDID (or Apple Configurator)

**iOS Serial Number:** \***\*\*\*\*\***\_\_\***\*\*\*\*\***

**iOS UDID:** \***\*\*\*\*\***\_\_\***\*\*\*\*\***

### Submit Reset Request to Suleman

> **Script:** "Now I'm going to send a message to our IT administrator to request your device reset. This will take about 15-30 minutes. While we wait, we can prepare for the next steps. Please don't turn off your device or disconnect from the internet during this time."

- [ ] **Teams Opened:** User opened Microsoft Teams (or engineer will send message)
- [ ] **Reset Message Sent:** Sent to Suleman Manji (smanji@viyu.net) via Teams

#### Reset Request Message Format

```
Windows Serial: [SERIAL] | iOS Serial: [SERIAL] | iOS UDID: [UDID]
```

**Example:**

```
Windows Serial: ABC123XYZ | iOS Serial: DEF456UVW | iOS UDID: A1B2C3D4-E5F6-7890-ABCD-EF1234567890
```

{: .note }

> **Wait Period:** During the 15-30 minute wait, you can help the user understand what's coming next, or if there are multiple users, start preparing the next user's backup.

---

## Phase 3: Windows OOBE (Out-of-Box Experience)

{: .danger }

> **CRITICAL WARNING:** User must NOT interrupt the Autopilot ESP screen. If device is turned off or disconnected during setup, it will require full re-enrollment.

**Estimated Time:** 30-60 minutes (mostly waiting)

> **Script:** "Great! I've received confirmation that your device reset is ready. Now we need to restart your computer. After it restarts, you'll see a setup screen. This is normal - it's called the 'Out-of-Box Experience' or OOBE. Please follow my instructions carefully."

### Device Boot & Network

> **Script:** "Please restart your computer now. After it boots up, you'll see a setup screen. Make sure you're connected to the internet - preferably with an Ethernet cable, but WiFi will work too. Can you confirm you see the setup screen?"

- [ ] **Device Booted:** User restarted device and it booted to setup screen
- [ ] **Network Connected:** Device connected to network (Ethernet preferred, WiFi acceptable)

### Organizational Sign-In

> **Script:** "On the setup screen, select your language and region, then accept the terms. When it asks you to sign in, make sure you sign in with your work email - that's your @impactpropertysolutions.com address. Do NOT create a local account. After you sign in, you'll be asked to verify your identity with your phone - that's the multi-factor authentication. Please complete that step."

- [ ] **Language Selected:** User selected language and region
- [ ] **Terms Accepted:** User accepted terms and conditions
- [ ] **NO Local Account:** User did NOT create local account - proceeded to organizational sign-in
- [ ] **Organizational Sign-In:** User signed in with @impactpropertysolutions.com email
- [ ] **MFA Completed:** User completed multi-factor authentication

### Autopilot ESP (Enrollment Status Page)

{: .warning }

> **DO NOT INTERRUPT:** The ESP screen will show apps installing. This takes 30-60 minutes. User must NOT turn off device, disconnect internet, or close the screen.

> **Script:** "Perfect! Now you should see a screen that says something like 'Setting up your device' or 'Installing apps'. This is the Autopilot setup process. It's going to install all the software you need for work. This will take about 30-60 minutes. Please DO NOT turn off your computer, disconnect from the internet, or close this screen. The computer might restart once or twice - that's normal. Just let it do its thing. I'll check back with you in about 45 minutes, or you can call me when you see your desktop appear. Does that make sense?"

- [ ] **ESP Screen Appeared:** User sees enrollment progress screen showing apps installing
- [ ] **Waiting Period:** User understands to wait 30-60 minutes without interrupting
- [ ] **Device Restarts:** Device restarted 1-2 times (normal behavior)
- [ ] **ESP Completed:** Setup finished and user can see desktop

{: .note }

> **Follow-Up Options:** Schedule a callback in 45-60 minutes, or have user call back when ESP completes. During this time, you can help other users or take other calls.

---

## Phase 4: Post-ESP Verification & Application Check

**Estimated Time:** 10-15 minutes

> **Script:** "Great! I can see your desktop now. Let's verify that all your work applications installed correctly. I'll guide you through checking each one."

### Required Applications Verification

> **Script:** "Let's check each application. First, look for Outlook in your Start menu - it should say 'Outlook' or 'Microsoft Outlook'. Can you see it? Great! Now let's check Teams. Look for Microsoft Teams in your Start menu. Do you see it? Let's also check your system tray - that's the area in the bottom right corner of your screen. You should see a OneDrive icon and possibly a NinjaOne icon. Can you confirm you see those?"

- [ ] **Outlook Classic:** Installed and can be launched (pin to taskbar if needed)
- [ ] **Microsoft Teams:** Installed with work/school account (pin to taskbar)
- [ ] **Google Chrome:** Installed and set as default browser
- [ ] **Foxit PDF Reader:** Installed and set as default PDF viewer
- [ ] **NinjaOne RMM Agent:** Running (check system tray icon)
- [ ] **IPS VPN:** IPS.exe run to create VPN profile (if needed)
- [ ] **OneDrive:** Syncing automatically (check taskbar icon)

{: .note }

> **If Office 365 Not Installed:** Guide user to portal.office.com -> Install Office -> Office 365 apps

---

## Phase 5: User Validation (3-Point Test)

**Estimated Time:** 10-15 minutes

{: .important }

> **User Must Be Present:** These tests require the user to verify functionality. Conduct this phase with user on the call or via screen share.

> **Script:** "Now let's test three critical functions to make sure everything is working. I'll guide you through each test, and you'll let me know if it works. Ready?"

### Test 1: Internet Access

> **Script:** "First test - Internet access. Please open your web browser - that should be Chrome. Now type 'google.com' in the address bar and press Enter. Does the Google page load? Great! Internet is working."

- [ ] **Internet Test:** User opened browser, navigated to google.com, page loaded successfully

### Test 2: RFMS RDP Connection

> **Script:** "Second test - RFMS access. Please open Remote Desktop Connection. You can find it by typing 'Remote Desktop' in your Start menu. Now, do you know the RFMS server address? [If not, check dispatch ticket or site info]. Please connect to that server. Does it connect? Can you see the RFMS login screen? Perfect!"

- [ ] **RFMS RDP Test:** User opened Remote Desktop, connected to RFMS server, connection successful

### Test 3: Printer Access

> **Script:** "Third test - Printing. Please go to Settings -> Devices -> Printers & scanners. Do you see your printer listed? If not, we may need to re-add it using the screenshot you took earlier. Let's try printing a test page. Open Notepad, type 'Test', and go to File -> Print. Select your printer and click Print. Did a page come out of your printer? Excellent! All three tests passed."

- [ ] **Printer Test:** User sent test print job, confirmed printout received

{: .highlight }

> **All Tests Passed!** Device is functioning correctly. Proceed to browser restoration.

---

## Phase 6: Browser Profile Data Restoration

**Estimated Time:** 15-20 minutes

> **Script:** "Now let's restore your browser data. We backed up bookmarks, passwords, and documented your extensions. Let me guide you through getting everything back."

### Step 1: Sign Into Browser Accounts (Recommended First)

{: .highlight }

> **Best Approach:** If the user had browser sync enabled before migration, signing back in will automatically restore most data. Always try this first.

> **Script:** "First, let's sign you back into your browsers. This should automatically restore most of your data if you had sync enabled before. Let's start with Chrome."

**Google Chrome Sign-In:**

> **Script:** "Open Chrome and click the profile icon in the top-right corner. Click 'Turn on sync' or 'Sign in'. Use your Google account - the same one you were using before the migration. After signing in, wait a minute for Chrome to sync your data. Do you see your bookmarks appearing automatically?"

- [ ] **Chrome Signed In:** User signed into Google account
- [ ] **Chrome Sync Restoring:** Bookmarks, passwords, and settings syncing automatically
- [ ] **N/A - Chrome Sync Not Used:** Skip if user wasn't using Chrome sync

**Microsoft Edge Sign-In:**

> **Script:** "Now let's do the same for Edge. Open Edge, click the profile icon, and sign in with your Microsoft account - that's usually your @impactpropertysolutions.com email or your personal Microsoft account. Wait a moment for sync to complete."

- [ ] **Edge Signed In:** User signed into Microsoft account
- [ ] **Edge Sync Restoring:** Favorites, passwords, and settings syncing automatically
- [ ] **N/A - Edge Sync Not Used:** Skip if user wasn't using Edge sync

---

### Step 2: Import Bookmarks from Backup Files

{: .note }

> **If sync restored bookmarks:** You can skip this step. Only import from backup files if sync didn't restore bookmarks or if user wants to merge/restore from the backup.

> **Script:** "Let's import your bookmarks from the backup files we saved. Even if sync restored them, this ensures nothing was missed."

**Chrome Bookmarks Import:**

> **Script:** "In Chrome, press Ctrl+Shift+O to open Bookmark Manager. Click the three dots menu in the top-right of the Bookmark Manager, then click 'Import bookmarks'. Navigate to your OneDrive Documents folder and find 'Chrome_Bookmarks.html'. Select it and click Open."

- [ ] **Chrome Bookmarks Imported:** OneDrive Documents → Chrome_Bookmarks.html → Imported
- [ ] **Skipped - Sync Restored:** Bookmarks already restored via sync

**Edge Favorites Import:**

> **Script:** "In Edge, press Ctrl+Shift+O to open Favorites. Click the three dots menu, select 'Import favorites', choose 'Favorites or bookmarks HTML file'. Navigate to OneDrive Documents and select 'Edge_Favorites.html'."

- [ ] **Edge Favorites Imported:** OneDrive Documents → Edge_Favorites.html → Imported
- [ ] **Skipped - Sync Restored:** Favorites already restored via sync

---

### Step 3: Import Saved Passwords (If Needed)

{: .warning }

> **Sync Preferred:** If browser sync is working, passwords should restore automatically. Only use the CSV import if passwords didn't sync or if user exported passwords for sites not in sync.

> **Script:** "Let's check if your saved passwords came back. In Chrome, go to Settings and click 'Passwords'. Do you see your saved passwords listed? If not, we can import them from the backup file."

**Chrome Passwords Import:**

> **Script:** "In Chrome, go to Settings → Passwords. Click the three dots next to 'Saved Passwords' and select 'Import'. Navigate to OneDrive Documents, select 'Chrome_Passwords.csv', and import."

- [ ] **Chrome Passwords Restored via Sync:** Passwords already present - no import needed
- [ ] **Chrome Passwords Imported from CSV:** OneDrive Documents → Chrome_Passwords.csv → Imported
- [ ] **N/A - No Password Backup:** User had no saved passwords

**Edge Passwords Import:**

> **Script:** "In Edge, go to Settings → Passwords. Click the three dots and select 'Import passwords'. Choose the CSV file from OneDrive Documents."

- [ ] **Edge Passwords Restored via Sync:** Passwords already present - no import needed
- [ ] **Edge Passwords Imported from CSV:** OneDrive Documents → Edge_Passwords.csv → Imported
- [ ] **N/A - No Password Backup:** User had no saved passwords

---

### Step 4: Reinstall Browser Extensions

> **Script:** "Now let's check your browser extensions. If you had sync enabled, some extensions may have restored automatically. Let's open your extensions page and compare to the screenshot we took."

**Chrome Extensions:**

> **Script:** "In Chrome, type 'chrome://extensions' in the address bar. Compare what you see to the screenshot in your OneDrive Documents folder - 'Chrome_Extensions.png'. For any missing extensions, you'll need to reinstall them from the Chrome Web Store."

- [ ] **Chrome Extensions Checked:** Compared current extensions to screenshot
- [ ] **Chrome Extensions Reinstalled:** Any missing critical extensions reinstalled
- [ ] **N/A - No Extensions Used:** User had no important extensions

**Edge Extensions:**

> **Script:** "In Edge, type 'edge://extensions' in the address bar. Compare to 'Edge_Extensions.png' and reinstall any missing extensions."

- [ ] **Edge Extensions Checked:** Compared current extensions to screenshot
- [ ] **Edge Extensions Reinstalled:** Any missing critical extensions reinstalled
- [ ] **N/A - No Extensions Used:** User had no important extensions

---

### Step 5: Secure Cleanup - Delete Sensitive Files

{: .danger }

> **CRITICAL SECURITY STEP:** Password CSV files contain plain-text passwords. These MUST be permanently deleted after restoration.

> **Script:** "Now, very important for security - we need to delete those password backup files since they contain sensitive information. Let's go to your OneDrive Documents folder and delete the password CSV files, then empty your Recycle Bin."

**Delete Password Files:**

- [ ] **Chrome_Passwords.csv Deleted:** File deleted from OneDrive Documents
- [ ] **Edge_Passwords.csv Deleted:** File deleted from OneDrive Documents
- [ ] **Recycle Bin Emptied:** User confirmed Recycle Bin emptied
- [ ] **N/A - No Password Files:** User didn't export passwords

{: .note }

> **Keep These Files (Optional):** Bookmark HTML files and extension screenshots don't contain sensitive data and can be kept as backup. Password CSV files MUST be deleted.

**Browser Restoration Checklist:**

| Item                          | Status                       |
| ----------------------------- | ---------------------------- |
| **Chrome signed in & synced** | [ ] Yes [ ] N/A              |
| **Edge signed in & synced**   | [ ] Yes [ ] N/A              |
| **Bookmarks restored**        | [ ] Sync [ ] Import [ ] Both |
| **Passwords restored**        | [ ] Sync [ ] Import [ ] N/A  |
| **Extensions reinstalled**    | [ ] Yes [ ] N/A              |
| **Password files deleted**    | [ ] Yes [ ] N/A              |

---

## Phase 7: iOS Device Enrollment (If Applicable)

**Estimated Time:** 15-20 minutes (if applicable)

{: .note }

> **Note:** iOS enrollment requires Apple Configurator and DEM credentials. This may need to be scheduled separately or completed on-site if user doesn't have access to Apple Configurator.

> **Script:** "For your iPhone or iPad, we need to enroll it in our management system. This requires Apple Configurator, which is a free app from the Mac App Store. Do you have a Mac available? [If yes, proceed. If no, schedule on-site visit or provide alternative instructions]. We'll also need to connect your device via USB and use special credentials I'll provide."

- [ ] **iOS Enrollment Required:** User has iOS device that needs enrollment
- [ ] **Apple Configurator Available:** User has Apple Configurator installed or can install it
- [ ] **DEM Credentials Obtained:** Engineer obtained DEM credentials from Suleman
- [ ] **iOS Enrollment Complete:** Device enrolled via Apple Configurator, shows "Managed by Impact Property Solutions"

{: .warning }

> **iOS Enrollment Limitation:** If user doesn't have Apple Configurator access, iOS enrollment may need to be scheduled for on-site visit or alternative method. Document this in notes.

---

## Phase 8: Final Verification & Sign-Off

{: .highlight }

> **Almost Done!** Complete final checks before closing the call.

### Final Checklist

> **Closing Script:** "Perfect! Your device migration is complete. Let me just verify a few final things with you. Can you confirm that Outlook opens? Teams works? Your bookmarks are back? Great! Your device is now fully migrated and ready to use. If you have any issues or questions, please don't hesitate to call our support line. Is there anything else you need help with today?"

- [ ] **All Applications Verified:** Outlook, Teams, Chrome, Foxit, NinjaOne all present and working
- [ ] **3-Point Test Passed:** Internet, RFMS, and Printer all tested and working
- [ ] **Browser Data Restored:** User confirmed bookmarks, passwords, and extensions restored
- [ ] **Sensitive Files Deleted:** Password CSV files deleted from OneDrive Documents
- [ ] **OneDrive Syncing:** OneDrive is syncing files (check taskbar icon)
- [ ] **User Satisfied:** User confirmed device is working and ready for use

### Issues & Follow-Up

Document any issues encountered, items that need follow-up, or special notes about this migration.

**Follow-Up Options:**

- No follow-up needed
- iOS enrollment scheduled
- Printer configuration needed
- Application installation issue
- Other (see notes)

---

## Quick Reference & Troubleshooting

### Important Contacts

| Contact                 | Details                                               |
| ----------------------- | ----------------------------------------------------- |
| **Device Reset Issues** | Suleman Manji - 469-364-6343 - Teams: smanji@viyu.net |
| **iOS Enrollment Help** | Suleman Manji - Teams (has DEM credentials)           |
| **Network Issues**      | Site Contact (check dispatch ticket)                  |

### Remote Support Troubleshooting

| Issue                         | Solution                                                                      |
| ----------------------------- | ----------------------------------------------------------------------------- |
| User can't find settings      | Use Windows key + I to open Settings quickly                                  |
| User confused about steps     | Break down into smaller steps, use screen share if available                  |
| ESP taking longer than 60 min | Check network connectivity, may need to restart device                        |
| Bookmarks won't import        | Verify file is .html format, not .json                                        |
| OneDrive not syncing          | Wait 15-30 min, check sync status in taskbar, sign out/in if needed           |
| Printer not appearing         | Use screenshot from Phase 1, manually add via Settings -> Devices -> Printers |
| User needs to pause           | Document current phase, schedule callback for continuation                    |

### Time Estimates

| Phase                   | Duration                       |
| ----------------------- | ------------------------------ |
| Phase 1 (Backup)        | 15-20 minutes                  |
| Phase 2 (Documentation) | 5-10 minutes + 15-30 min wait  |
| Phase 3 (OOBE)          | 30-60 minutes (mostly waiting) |
| Phase 4 (Verification)  | 10-15 minutes                  |
| Phase 5 (Validation)    | 10-15 minutes                  |
| Phase 6 (Restoration)   | 15-20 minutes                  |
| Phase 7 (iOS)           | 15-20 minutes (if applicable)  |
| **Total Active Time**   | **60-90 minutes**              |

---

## Service Engineer Sign-Off

Complete this section to document successful remote migration support:

| Field                | Value                                       |
| -------------------- | ------------------------------------------- |
| **Engineer Name**    | \***\*\*\*\*\***\_\_\***\*\*\*\*\***        |
| **Completion Date**  | \***\*\*\*\*\***\_\_\***\*\*\*\*\***        |
| **Migration Status** | Successful / Partial / In Progress / Failed |

### Status Options

- **Successful** - Device ready for use
- **Partial** - Some issues remain, follow-up scheduled
- **In Progress** - Callback scheduled
- **Failed** - Requires escalation

### Additional Notes

_Document any issues, special circumstances, user feedback, or items that need follow-up._

---

**Confirmation:** I confirm that I have provided remote support for this device migration according to the Impact Property Solutions Remote Support Migration procedures. All completed phases are documented, and any required follow-up actions have been scheduled.
