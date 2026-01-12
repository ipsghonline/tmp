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
