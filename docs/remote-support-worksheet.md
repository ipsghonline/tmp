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

### Browser Bookmarks Export

> **Script:** "Before we reset your device, we need to backup your browser bookmarks. This ensures you won't lose any saved websites. Let's start with Chrome..."

- [ ] **Chrome Bookmarks:** User exported to Desktop (Menu -> Bookmarks -> Bookmark Manager -> ... -> Export)
- [ ] **Edge Bookmarks:** User exported to Desktop (Settings -> Favorites -> Export)
- [ ] **Firefox Bookmarks:** User exported to Desktop (if Firefox is used)

{: .note }

> **Password Note:** "I should mention that browser passwords are encrypted and can't be easily transferred. You'll need to re-enter passwords for websites after migration. However, your Microsoft 365 passwords will sync automatically."

### Printer Configuration Backup

> **Script:** "Now let's backup your printer settings. Please open Settings -> Devices -> Printers & scanners. Take a screenshot showing all your printers and save it to your Desktop as 'PrinterBackup.png'."

- [ ] **Printer Screenshot:** User took screenshot of printer mappings and saved to Desktop as "PrinterBackup.png"

### WiFi Network Backup

> **Script:** "Now let's record your WiFi network name so we can reconnect after the reset. Please click on the WiFi icon in the taskbar - that's the wireless symbol in the bottom right corner. Can you tell me the name of the network you're currently connected to? I'll record that as your primary WiFi network."

- [ ] **WiFi SSID Recorded:** User identified currently connected WiFi network name

**Current WiFi Network (SSID):** ********************\_\_********************

{: .note }

> **Why this matters:** After the device reset, the user will need to reconnect to WiFi during the OOBE setup. Having the exact SSID documented ensures a smooth reconnection, especially if there are multiple similar network names at the site.

### OneDrive Verification

> **Script:** "This is very important - we need to make sure all your files are backed up to OneDrive. Please open a web browser and go to portal.office.com. Sign in and check your OneDrive. Can you confirm all your files show a green checkmark indicating they're synced? Great! We cannot proceed until OneDrive shows 100% complete."

- [ ] **OneDrive Known-Folder Backup:** Verified ON (Settings -> Account -> OneDrive -> Manage backup)
- [ ] **OneDrive 100% Synced:** Verified at portal.office.com - all files show as synced

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

**Windows Serial Number:** ****\*\*****\_\_****\*\***** (ALL CAPS, no spaces)

### iOS Device Information (If Applicable)

> **Script:** "For your iPhone/iPad, please go to Settings, then General, then About. I need both the Serial Number and the UDID. The UDID might be below the serial number. Can you read both to me?"

- [ ] **iOS Serial Recorded:** Settings -> General -> About -> Serial Number
- [ ] **iOS UDID Recorded:** Settings -> General -> About -> UDID (or Apple Configurator)

**iOS Serial Number:** ****\*\*****\_\_****\*\*****

**iOS UDID:** ****\*\*****\_\_****\*\*****

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

## Phase 6: Browser Bookmarks Restoration

**Estimated Time:** 10-15 minutes

> **Script:** "Now let's restore your browser bookmarks. Remember those files we saved to your Desktop earlier? We're going to import them back into your browsers."

### Chrome Bookmarks Restoration

> **Script:** "For Chrome, please open Chrome, then click the three dots menu in the top right. Go to Bookmarks -> Bookmark Manager. Now click the three dots again in the Bookmark Manager, and select 'Import bookmarks'. Navigate to your Desktop and find the file that starts with 'Chrome_Bookmarks' and has your name in it. Select it and click Open. Do you see your bookmarks appear? Great!"

- [ ] **Chrome Bookmarks:** Settings -> Bookmarks -> Bookmark Manager -> Import -> Selected Chrome*Bookmarks*[USERNAME].html from Desktop

### Edge Bookmarks Restoration

> **Script:** "For Edge, please open Edge, then click the three dots menu. Go to Settings -> Profiles. Look for 'Import browser data' and click it. Select 'From an HTML file' and navigate to your Desktop. Find the file that starts with 'Edge_Bookmarks' and select it. Did your bookmarks import?"

- [ ] **Edge Bookmarks:** Settings -> Profiles -> Import browser data -> Selected Edge*Bookmarks*[USERNAME].html

### Cleanup - Delete Backup Files

> **Script:** "Perfect! Now, for security, please delete those backup files from your Desktop. They contain sensitive information. Just right-click each file and select Delete. Make sure to empty your Recycle Bin too. Have you done that? Good!"

- [ ] **Backup Files Deleted:** User deleted all bookmark/password files from Desktop (contains sensitive data)

{: .warning }

> **Password Reminder:** Remind user that browser passwords cannot be bulk-restored. They'll need to re-enter passwords manually or use password recovery for important sites. Microsoft 365 passwords will sync automatically.

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
- [ ] **Bookmarks Restored:** User confirmed bookmarks are back in browsers
- [ ] **Desktop Cleanup:** Backup files deleted from Desktop
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
| **Device Reset Issues** | Suleman Manji - 281-904-1969 - Teams: smanji@viyu.net |
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
| Phase 6 (Restoration)   | 10-15 minutes                  |
| Phase 7 (iOS)           | 15-20 minutes (if applicable)  |
| **Total Active Time**   | **60-90 minutes**              |

---

## Service Engineer Sign-Off

Complete this section to document successful remote migration support:

| Field                | Value                                       |
| -------------------- | ------------------------------------------- |
| **Engineer Name**    | ****\*\*****\_\_****\*\*****                |
| **Completion Date**  | ****\*\*****\_\_****\*\*****                |
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
