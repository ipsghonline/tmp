---
layout: default
title: Migration Tools
parent: Monday Go-Live
nav_order: 7
---

# Migration Tools

Automation scripts and utilities for the Monday Go-Live migration.

---

## Phase 1 Backup Script

{: .highlight }

> **Download:** [Phase1-Backup.ps1](/scripts/Phase1-Backup.ps1) | **Version:** 1.0

The Phase 1 Backup Script automates pre-migration backup tasks, ensuring consistency across all technician visits. Run this script before beginning the manual Phase 1 workflow.

---

### Quick Start

**Option 1: One-Liner (Run Directly)**

```powershell
irm https://ipsghonline.github.io/tmp/scripts/Phase1-Backup.ps1 | iex
```

**Option 2: Download First, Then Run**

```powershell
Invoke-WebRequest -Uri "https://ipsghonline.github.io/tmp/scripts/Phase1-Backup.ps1" -OutFile "Phase1-Backup.ps1"
.\Phase1-Backup.ps1
```

{: .note }

> **PowerShell Execution Policy:** If you get an execution policy error, run:
>
> ```powershell
> Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
> ```

---

### Additional Resources

{: .highlight }

> **End-User Presentation:** Download the [Phase 1 Backup Guide (PowerPoint)](https://github.com/ipsghonline/tmp/blob/main/presentation/Phase1-Backup-Guide.pptx) for a visual walkthrough of the backup process. This presentation can be used for end-user training or as a reference guide during migration.

---

### What the Script Does

| Task                | Automated                                              | Manual Follow-up             |
| ------------------- | ------------------------------------------------------ | ---------------------------- |
| **System Info**     | Collects computer name, serial number, Windows version | None                         |
| **OneDrive Status** | Checks installation, sign-in, Known Folder Backup      | Verify green checkmark       |
| **WiFi SSID**       | Captures current network name                          | Record for OOBE              |
| **Printers**        | Exports list to OneDrive Documents                     | Verify list is complete      |
| **PST Files**       | Finds and copies to OneDrive (with prompt)             | Verify in OneDrive web       |
| **Browsers**        | Opens bookmark export pages                            | Export bookmarks & passwords |
| **iOS Backup**      | Displays reminder                                      | Verify in Apple Devices app  |
| **Report**          | Generates checklist to OneDrive Documents              | Review before proceeding     |

---

### Script Parameters

| Parameter      | Description                                          |
| -------------- | ---------------------------------------------------- |
| `-SkipPSTCopy` | Skip automatic PST file copying (report only)        |
| `-Quiet`       | Suppress interactive prompts (auto-confirm PST copy) |

**Examples:**

```powershell
# Standard run with prompts
.\Phase1-Backup.ps1

# Skip PST copying (just report them)
.\Phase1-Backup.ps1 -SkipPSTCopy

# Auto-confirm all prompts
.\Phase1-Backup.ps1 -Quiet
```

---

### Sample Output

```
╔══════════════════════════════════════════════════════════════╗
║     IMPACT PROPERTY SOLUTIONS - PHASE 1 BACKUP SCRIPT        ║
║                    Monday Go-Live Migration                   ║
║                         Version 1.0                          ║
╚══════════════════════════════════════════════════════════════╝

[INFO] Collecting system information...
  Computer Name: DESKTOP-ABC123
  Serial Number: 5CG1234XYZ
  Current User: jsmith
  UPN: jsmith@inginc.com
  Windows: Windows 11 Pro (10.0.22631)

[INFO] Checking OneDrive status...
  ✓ OneDrive installed
  ✓ OneDrive running
  ✓ Signed in as: jsmith@inginc.com
  ✓ Known Folder Backup: Enabled

[INFO] Capturing WiFi network...
  Current SSID: ImpactFloors-Corp

[INFO] Exporting printer configuration...
  Found 3 printer(s):
    - HP LaserJet Pro MFP M428 (Default)
    - Microsoft Print to PDF
    - Fax
  ✓ Saved to: C:\Users\jsmith\OneDrive\Documents\PrinterBackup.txt

[INFO] Scanning for Outlook data files...
  Location: C:\Users\jsmith\AppData\Local\Microsoft\Outlook
  OST Files: 1 (1.45 GB) - Will recreate after migration
  PST Files: 2 (523 MB total)
    - Archive2024.pst (312 MB)
    - OldEmails.pst (211 MB)

[PROMPT] Copy 2 PST file(s) to OneDrive Documents? (Y/N): Y
  ✓ Copied: Archive2024.pst
  ✓ Copied: OldEmails.pst

[INFO] Detecting browsers...
  ✓ Google Chrome - Installed
  ✓ Microsoft Edge - Installed
  Opening Google Chrome bookmarks page...
  Opening Microsoft Edge bookmarks page...

[ACTION] Please export bookmarks and passwords from each browser window.
  Chrome: Menu (⋮) → Bookmarks → Bookmark Manager → ⋮ → Export
  Edge: Menu (···) → Favorites → ⋮ → Export favorites
  Passwords: Settings → Passwords → ⋮ → Export passwords

[REMINDER] iOS Device Backup
  If user has iPhone/iPad:
  1. Connect device via USB cable
  2. Open Apple Devices app (install from Microsoft Store if needed)
  3. Verify recent backup exists (within 24-48 hours)
  4. If no backup, click 'Back Up Now'

  Apple Devices App: https://apps.microsoft.com/detail/9np83lwlpz9k

════════════════════════════════════════════════════════════════
                    PHASE 1 CHECKLIST SUMMARY
════════════════════════════════════════════════════════════════
[✓] System information collected
[✓] OneDrive signed in
[✓] Known Folder Backup enabled
[ ] OneDrive sync complete (verify green checkmark)
[✓] Printers exported (3 printers)
[✓] WiFi SSID recorded: ImpactFloors-Corp
[✓] PST files found (2 files)
[ ] Browser bookmarks exported (manual)
[ ] Browser passwords exported (manual)
[ ] iOS backup verified (manual)
════════════════════════════════════════════════════════════════

Report saved to: C:\Users\jsmith\OneDrive\Documents\Phase1-Backup-Report.txt

Phase 1 backup script complete. Please verify all manual items before proceeding.
```

---

### Output Files

The script creates two files in the user's OneDrive Documents folder:

| File                       | Contents                              |
| -------------------------- | ------------------------------------- |
| `Phase1-Backup-Report.txt` | Complete backup report with checklist |
| `PrinterBackup.txt`        | List of installed printers with ports |

If PST files are copied, they will also appear in OneDrive Documents.

---

### Troubleshooting

{: .warning }

> **Common Issues and Solutions**

| Issue                    | Solution                                                              |
| ------------------------ | --------------------------------------------------------------------- |
| "Script not recognized"  | Right-click PowerShell → Run as Administrator                         |
| Execution policy error   | Run: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`     |
| OneDrive not detected    | Ensure OneDrive is installed and signed in                            |
| WiFi SSID not found      | User may be on Ethernet - record SSID manually                        |
| PST copy fails           | Verify OneDrive Documents folder exists; Outlook may have file locked |
| Browser pages don't open | Manually open browser and navigate to bookmark settings               |

---

### Telemetry & Event Logging

The script automatically collects telemetry data to help track migration progress and identify issues.

**Telemetry Location:**

```
%USERPROFILE%\AppData\Local\IPS-Migration\Telemetry\
  Phase1-Events-{ComputerName}-{Timestamp}.json
```

**What's Collected:**

- Device information (computer name, serial, Windows version)
- User information (username, UPN)
- OneDrive status and Known Folder Backup
- WiFi SSID
- Printer count and names
- PST file count and sizes
- Browser installations
- Script execution time and success status
- Any errors encountered

**Privacy:**

The telemetry data is stored locally only. No data is sent to cloud services. IT can collect these files manually for migration tracking and troubleshooting.

**Disable Telemetry:**

```powershell
.\Phase1-Backup.ps1 -TelemetryDisabled
```

**Collect Telemetry (For IT):**

Use the collection script to gather telemetry files from machines:

```powershell
# Download collection script
Invoke-WebRequest -Uri "https://ipsghonline.github.io/tmp/scripts/Collect-Phase1-Telemetry.ps1" -OutFile "Collect-Phase1-Telemetry.ps1"

# Collect to USB drive
.\Collect-Phase1-Telemetry.ps1 -OutputPath "E:\MigrationTelemetry"

# Collect to network share
.\Collect-Phase1-Telemetry.ps1 -OutputPath "\\server\share\telemetry"

# Collect and remove local copies
.\Collect-Phase1-Telemetry.ps1 -OutputPath "E:\Telemetry" -RemoveAfterCopy
```

**Sample Telemetry Data:**

```json
{
    "SchemaVersion": "1.0",
    "EventType": "Phase1-Backup-Complete",
    "Timestamp": "2026-01-19T08:15:23Z",
    "ScriptVersion": "1.0",
    "Device": {
        "ComputerName": "DESKTOP-ABC123",
        "SerialNumber": "5CG1234XYZ",
        "WindowsVersion": "Windows 11 Pro (10.0.22631)"
    },
    "User": {
        "Username": "jsmith",
        "UPN": "jsmith@inginc.com"
    },
    "Results": {
        "OneDrive": {
            "Installed": true,
            "SignedIn": true,
            "Account": "jsmith@inginc.com",
            "KnownFolderBackup": true
        },
        "WiFi": {
            "SSID": "ImpactFloors-Corp"
        },
        "Printers": {
            "Count": 3,
            "Names": ["HP LaserJet Pro", "Microsoft Print to PDF"]
        },
        "OutlookDataFiles": {
            "PSTCount": 2,
            "PSTTotalSizeMB": 523,
            "PSTCopied": true
        },
        "Browsers": {
            "Installed": ["Chrome", "Edge"]
        }
    },
    "Execution": {
        "StartTime": "2026-01-19T08:12:45Z",
        "EndTime": "2026-01-19T08:15:23Z",
        "DurationSeconds": 158,
        "Success": true,
        "ErrorCount": 0
    },
    "Errors": []
}
```

---

### After Running the Script

1. **Verify OneDrive sync** - Check for green checkmark in system tray
2. **Export browser data** - Complete bookmark and password exports from opened browser windows
3. **Verify iOS backup** - If applicable, check Apple Devices app
4. **Review report** - Open `Phase1-Backup-Report.txt` to verify all items
5. **Proceed to Phase 2** - Once all checklist items are complete

---

### Script Source

The script is open source and available for review:

- **GitHub:** [Phase1-Backup.ps1](https://github.com/ipsghonline/tmp/blob/main/scripts/Phase1-Backup.ps1)
- **Direct Download:** [Phase1-Backup.ps1](/scripts/Phase1-Backup.ps1)

{: .note }

> **Version History:**
>
> - **v1.0** (January 2026) - Initial release for Monday Go-Live migration

---

## Intune Remediation Scripts

{: .highlight }

> **Purpose:** Post-migration validation scripts that run automatically via Intune to ensure device compliance.

Intune Proactive Remediations detect and fix common post-migration issues on Windows devices in the Impact tenant. These scripts run on a schedule (daily for first 30 days) and automatically remediate issues without user interaction.

---

### Available Remediation Scripts

| Script                       | Purpose                                                    | Downloads                                                                                                      |
| ---------------------------- | ---------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| **OneDrive KFB Enforcement** | Ensures Desktop, Documents, Pictures backed up to OneDrive | [Detect](/scripts/intune/Detect-OneDriveKFB.ps1) \| [Remediate](/scripts/intune/Remediate-OneDriveKFB.ps1)     |
| **Printer Backup**           | Backs up printer configuration to OneDrive Documents       | [Detect](/scripts/intune/Detect-PrinterBackup.ps1) \| [Remediate](/scripts/intune/Remediate-PrinterBackup.ps1) |
| **WiFi Backup**              | Captures WiFi SSID to OneDrive Documents                   | [Detect](/scripts/intune/Detect-WiFiBackup.ps1) \| [Remediate](/scripts/intune/Remediate-WiFiBackup.ps1)       |
| **PST Backup**               | Copies PST files to OneDrive Documents (< 2GB)             | [Detect](/scripts/intune/Detect-PSTBackup.ps1) \| [Remediate](/scripts/intune/Remediate-PSTBackup.ps1)         |

**Direct Downloads:**

- [Detect-OneDriveKFB.ps1](/scripts/intune/Detect-OneDriveKFB.ps1)
- [Remediate-OneDriveKFB.ps1](/scripts/intune/Remediate-OneDriveKFB.ps1)
- [Detect-PrinterBackup.ps1](/scripts/intune/Detect-PrinterBackup.ps1)
- [Remediate-PrinterBackup.ps1](/scripts/intune/Remediate-PrinterBackup.ps1)
- [Detect-WiFiBackup.ps1](/scripts/intune/Detect-WiFiBackup.ps1)
- [Remediate-WiFiBackup.ps1](/scripts/intune/Remediate-WiFiBackup.ps1)
- [Detect-PSTBackup.ps1](/scripts/intune/Detect-PSTBackup.ps1)
- [Remediate-PSTBackup.ps1](/scripts/intune/Remediate-PSTBackup.ps1)

**Documentation:** [Full Deployment Guide](/scripts/intune/) | [View Source on GitHub](https://github.com/ipsghonline/tmp/tree/main/scripts/intune)

---

### Deployment Instructions

For complete step-by-step deployment instructions, monitoring, troubleshooting, and best practices, see the [**Full Deployment Guide**](/scripts/intune/)

---

### Quick Download

**Download All Scripts:**

```powershell
# OneDrive KFB
Invoke-WebRequest -Uri "https://ipsghonline.github.io/tmp/scripts/intune/Detect-OneDriveKFB.ps1" -OutFile "Detect-OneDriveKFB.ps1"
Invoke-WebRequest -Uri "https://ipsghonline.github.io/tmp/scripts/intune/Remediate-OneDriveKFB.ps1" -OutFile "Remediate-OneDriveKFB.ps1"

# Printer Backup
Invoke-WebRequest -Uri "https://ipsghonline.github.io/tmp/scripts/intune/Detect-PrinterBackup.ps1" -OutFile "Detect-PrinterBackup.ps1"
Invoke-WebRequest -Uri "https://ipsghonline.github.io/tmp/scripts/intune/Remediate-PrinterBackup.ps1" -OutFile "Remediate-PrinterBackup.ps1"

# WiFi Backup
Invoke-WebRequest -Uri "https://ipsghonline.github.io/tmp/scripts/intune/Detect-WiFiBackup.ps1" -OutFile "Detect-WiFiBackup.ps1"
Invoke-WebRequest -Uri "https://ipsghonline.github.io/tmp/scripts/intune/Remediate-WiFiBackup.ps1" -OutFile "Remediate-WiFiBackup.ps1"

# PST Backup
Invoke-WebRequest -Uri "https://ipsghonline.github.io/tmp/scripts/intune/Detect-PSTBackup.ps1" -OutFile "Detect-PSTBackup.ps1"
Invoke-WebRequest -Uri "https://ipsghonline.github.io/tmp/scripts/intune/Remediate-PSTBackup.ps1" -OutFile "Remediate-PSTBackup.ps1"
```

---

### Deployment in Intune

**Quick Start:**

1. Sign in to [Microsoft Intune admin center](https://intune.microsoft.com)
2. Go to **Devices** → **Scripts** → **Proactive remediations**
3. Click **+ Create script package**
4. Upload detection and remediation script pair
5. Configure:
    - Run using **logged-on credentials**: Yes
    - Run in **64-bit PowerShell**: Yes
    - Frequency: **Daily** (first 30 days)
6. Assign to all Impact Windows devices
7. Deploy in order:
    1. OneDrive KFB Enforcement (Priority 1 - Enables OneDrive backup infrastructure)
    2. Printer Backup (Priority 2 - Small file, quick backup)
    3. WiFi Backup (Priority 3 - Small file, quick backup)
    4. PST Backup (Priority 4 - Large files, may take time)

---

### Monitoring Remediation Status

**Intune Console:**

1. Go to **Devices** → **Scripts** → **Proactive remediations**
2. Click on remediation package
3. View **Device status**:
    - **With issues** = Problems detected, remediation needed
    - **Without issues** = Compliant
    - **Failed** = Check Event Log for errors

**Event Log (on device):**

```powershell
Get-EventLog -LogName Application -Source IntuneRemediations -Newest 10
```

**Event IDs:**

- 1001: Remediation successful
- 1002: Remediation failed
- 1003: Detection passed (compliant)
- 1004: Detection failed (non-compliant)

---

### Remediation Reports

All remediation scripts create detailed reports in `C:\Support\` on each device:

**Files:**

- `Remediation-{ScriptName}-{Timestamp}.json` - Structured data for automation
- `Remediation-{ScriptName}-{Timestamp}.txt` - Human-readable report

**View Reports on Device:**

```powershell
# List all remediation reports
Get-ChildItem C:\Support\Remediation-*.txt | Sort-Object LastWriteTime -Descending

# Read latest report
Get-Content (Get-ChildItem C:\Support\Remediation-*.txt | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
```

---

### Collecting Remediation Telemetry

Use the collection script to gather remediation data from multiple devices:

**Download Collection Script:**

```powershell
Invoke-WebRequest -Uri "https://ipsghonline.github.io/tmp/scripts/Collect-RemediationTelemetry.ps1" -OutFile "Collect-RemediationTelemetry.ps1"
```

**Collect to USB Drive:**

```powershell
.\Collect-RemediationTelemetry.ps1 -OutputPath "E:\RemediationTelemetry"
```

**Collect to Network Share:**

```powershell
.\Collect-RemediationTelemetry.ps1 -OutputPath "\\server\share\telemetry"
```

**Collect JSON and TXT Files:**

```powershell
.\Collect-RemediationTelemetry.ps1 -OutputPath "E:\Telemetry" -IncludeTxtFiles
```

**Collect and Remove Local Copies:**

```powershell
.\Collect-RemediationTelemetry.ps1 -OutputPath "E:\Telemetry" -RemoveAfterCopy
```

---

### What Each Remediation Does

#### OneDrive KFB Enforcement

**Detection:**

- Checks if OneDrive installed and signed in
- Verifies Desktop, Documents, Pictures backed up to OneDrive
- Tests OneDrive sync status

**Remediation:**

- Starts OneDrive if not running
- Enables Known Folder Move via registry policy
- Triggers OneDrive reconfiguration
- Verifies folders redirected to OneDrive

**Expected Runtime:** 20-30 seconds

---

#### Printer Backup

**Detection:**

- Checks if printer backup file exists in OneDrive Documents
- Verifies backup is recent (< 7 days old)

**Remediation:**

- Uses WMI `Win32_Printer` to enumerate all printers
- Exports printer details to `IPS-Migration-PrinterBackup.txt`
- Includes printer names, ports, drivers, default printer
- Performs high-risk checks: OneDrive running, Print Spooler status, excessive printer count (>50)

**User Notifications:** If the script detects issues requiring action (e.g., OneDrive not running, Print Spooler stopped), it displays a Windows Toast Notification with clear instructions. Users also receive a warning file in their Documents folder.

**Expected Runtime:** 10-15 seconds

---

#### WiFi Backup

**Detection:**

- Checks if WiFi SSID backup file exists in OneDrive Documents
- Verifies backup is recent (< 7 days old)

**Remediation:**

- Uses `netsh wlan show interfaces` to get current SSID
- Exports to `IPS-Migration-WiFiSSID.txt`
- Creates "Not applicable" file if WiFi not available
- Performs high-risk checks: OneDrive running, wireless service availability

**User Notifications:** If the script detects issues requiring action (e.g., OneDrive not running, low disk space), it displays a Windows Toast Notification with clear instructions. Users also receive a warning file in their Documents folder.

**Expected Runtime:** 5-10 seconds

---

#### PST Backup

**Detection:**

- Searches for PST files in Outlook locations and user folders
- Checks if PST files have been backed up to OneDrive Documents

**Remediation:**

- Searches: `%LOCALAPPDATA%\Microsoft\Outlook`, `Documents`, `Desktop`
- Copies PST files to `IPS-Migration-PSTBackup\` folder
- Skips files >2GB (OneDrive sync limit)
- Tests file locks before copying
- Creates detailed summary: `BackupSummary.txt`
- Performs high-risk checks: OneDrive running, Outlook NOT running, total PST size vs available space (80% threshold), network-located PST files skipped, individual file lock testing

**User Notifications:** If the script detects issues requiring action (e.g., OneDrive not running, Outlook needs to be closed, PST files too large), it displays a Windows Toast Notification with clear instructions. Users also receive a warning file in their Documents folder.

**Expected Runtime:** Varies (1-10 minutes depending on PST count and size)

---

### Troubleshooting

**Detection shows "Failed" in Intune:**

1. Check Event Log on device:
    ```powershell
    Get-EventLog -LogName Application -Source IntuneRemediations -EntryType Error -Newest 5
    ```
2. Verify script runs manually:
    ```powershell
    .\Detect-OneDriveKFB.ps1
    echo $LASTEXITCODE  # Should be 0 or 1
    ```
3. Ensure "Run with logged-on credentials" is enabled in Intune

**Remediation doesn't fix issue:**

1. Check `C:\Support\Remediation-*.txt` for error details
2. For OneDrive KFB: May take 5-10 minutes after script runs
3. For missing apps: Deploy via Intune (script only logs the issue)

**No reports in C:\Support\:**

1. Check Event Log for errors
2. Manually run remediation script to see output
3. Verify user has write permissions to `C:\Support\`

---

### Best Practices

1. **Deploy in order**: OneDrive KFB → Printer Backup → WiFi Backup → PST Backup
2. **Monitor Event Logs**: First 7 days post-deployment
3. **Collect telemetry weekly**: Analyze trends and common issues
4. **Adjust frequency**: After 30 days, reduce to weekly or monthly
5. **Test locally first**: Validate scripts on test machine before production
