# Intune Remediation Scripts

Post-migration validation scripts for Impact Property Solutions Monday Go-Live migration.

## Overview

These Intune Proactive Remediation scripts detect and fix common post-migration issues automatically on Windows devices in the Impact tenant.

### Available Remediation Pairs

| Remediation                  | Purpose                                                            | Files                                                       |
| ---------------------------- | ------------------------------------------------------------------ | ----------------------------------------------------------- |
| **OneDrive KFB Enforcement** | Ensures Desktop, Documents, and Pictures are backed up to OneDrive | `Detect-OneDriveKFB.ps1`<br>`Remediate-OneDriveKFB.ps1`     |
| **Printer Backup**           | Backs up printer configuration to OneDrive Documents               | `Detect-PrinterBackup.ps1`<br>`Remediate-PrinterBackup.ps1` |
| **WiFi Backup**              | Captures WiFi SSID to OneDrive Documents                           | `Detect-WiFiBackup.ps1`<br>`Remediate-WiFiBackup.ps1`       |
| **PST Backup**               | Copies PST files to OneDrive Documents (< 2GB)                     | `Detect-PSTBackup.ps1`<br>`Remediate-PSTBackup.ps1`         |

---

## Deployment in Intune

### Prerequisites

1. Access to Microsoft Intune admin center
2. Global Administrator or Intune Administrator role
3. Windows devices enrolled in Impact tenant

### Step-by-Step Deployment

#### 1. Navigate to Remediations

1. Sign in to [Microsoft Intune admin center](https://intune.microsoft.com)
2. Go to **Devices** → **Scripts** → **Proactive remediations**
3. Click **+ Create script package**

#### 2. Configure Script Package

For each remediation pair, create a script package with these settings:

**Basics:**

- **Name**: `[Remediation Name] - Post-Migration`
  - Example: `OneDrive KFB Enforcement - Post-Migration`
- **Description**: Copy from table above

**Settings:**

| Setting                                         | Value                                       |
| ----------------------------------------------- | ------------------------------------------- |
| **Detection script**                            | Upload corresponding `Detect-*.ps1` file    |
| **Remediation script**                          | Upload corresponding `Remediate-*.ps1` file |
| **Run this script using logged-on credentials** | **Yes** ✓                                   |
| **Enforce script signature check**              | No                                          |
| **Run script in 64-bit PowerShell**             | **Yes** ✓                                   |

**Assignments:**

- **Include groups**:
  - `All Impact Windows Devices` (or similar group)
  - **Recommended**: Create migration-specific group (e.g., `Migration - Post-Migration Devices`)
- **Exclude groups**: None (or exclude pilot/test devices if needed)

**Schedule:**

| Setting                  | Recommended Value                            |
| ------------------------ | -------------------------------------------- |
| **Run script frequency** | **Daily** (for first 30 days post-migration) |
| **Run script on demand** | **Yes** ✓                                    |

**Review + Create:**

- Review settings
- Click **Create**

#### 3. Deployment Order

Deploy remediation scripts in this order:

1. **OneDrive KFB Enforcement** (Priority 1 - Enables OneDrive backup infrastructure)
2. **Printer Backup** (Priority 2 - Small file, quick backup)
3. **WiFi Backup** (Priority 3 - Small file, quick backup)
4. **PST Backup** (Priority 4 - Large files, may take time)

---

## Reporting & Monitoring

### Viewing Results in Intune

1. Go to **Devices** → **Scripts** → **Proactive remediations**
2. Click on a remediation package
3. View **Device status** tab:
   - **With issues** = Detection found problems
   - **Without issues** = Compliant
   - **Detection failed** = Script error (check Event Log)

### Event Log Monitoring

All scripts write to Windows Event Log:

**Event Source**: `IntuneRemediations`
**Log Name**: `Application`

**Event IDs:**

- **1001**: Remediation successful
- **1002**: Remediation failed
- **1003**: Detection passed (compliant)
- **1004**: Detection failed (non-compliant)

**Check Event Log:**

```powershell
Get-EventLog -LogName Application -Source IntuneRemediations -Newest 10
```

### Local Reports

All remediation scripts create reports in `C:\Support\`:

**Files:**

- `Remediation-{ScriptName}-{Timestamp}.json` - Structured data for automation
- `Remediation-{ScriptName}-{Timestamp}.txt` - Human-readable report

**View Reports:**

```powershell
Get-ChildItem C:\Support\Remediation-*.txt | Sort-Object LastWriteTime -Descending | Select-Object -First 5
```

**Read Latest Report:**

```powershell
Get-Content (Get-ChildItem C:\Support\Remediation-*.txt | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
```

---

## Collecting Telemetry

Use the collection script to gather remediation data from devices:

```powershell
# Download collection script
Invoke-WebRequest -Uri "https://ipsghonline.github.io/tmp/scripts/Collect-RemediationTelemetry.ps1" -OutFile "Collect-RemediationTelemetry.ps1"

# Collect to USB drive
.\Collect-RemediationTelemetry.ps1 -OutputPath "E:\RemediationTelemetry"

# Collect to network share
.\Collect-RemediationTelemetry.ps1 -OutputPath "\\server\share\telemetry"

# Collect JSON and TXT files
.\Collect-RemediationTelemetry.ps1 -OutputPath "E:\Telemetry" -IncludeTxtFiles

# Collect and remove local copies
.\Collect-RemediationTelemetry.ps1 -OutputPath "E:\Telemetry" -RemoveAfterCopy
```

---

## Troubleshooting

### Common Issues

#### Detection Script Fails

**Symptoms**: Detection shows "Failed" in Intune
**Cause**: PowerShell execution policy, permissions, or script error
**Solution**:

1. Check Event Log for error details:
   ```powershell
   Get-EventLog -LogName Application -Source IntuneRemediations -EntryType Error -Newest 5
   ```
2. Verify script runs manually:
   ```powershell
   .\Detect-OneDriveKFB.ps1
   echo $LASTEXITCODE  # Should be 0 or 1
   ```
3. Ensure "Run with logged-on credentials" is enabled

#### Remediation Script Doesn't Fix Issue

**Symptoms**: Detection continues to fail after remediation runs
**Cause**: Issue requires manual intervention or additional permissions
**Solution**:

1. Check `C:\Support\Remediation-*.txt` for error details
2. Verify Event Log for remediation failure reason
3. For OneDrive KFB: May take 5-10 minutes to complete after script runs
4. For missing apps: Script logs issue but cannot install apps (deploy via Intune)

#### No Reports in C:\Support\

**Symptoms**: Scripts run but no files in C:\Support\
**Cause**: Script failed before creating reports
**Solution**:

1. Check Event Log for errors
2. Manually run script to see output:
   ```powershell
   .\Remediate-OneDriveKFB.ps1
   ```
3. Verify user has write permissions to C:\Support\

#### PST Backup Fails or Skips Files

**Symptoms**: PST Backup shows "Issues detected" or creates warning files
**Cause**: Outlook running, files locked, files >2GB, or insufficient space
**Solution**:

1. Close Outlook completely
2. Check for warning file in OneDrive Documents: `IPS-Migration-WARNING-PSTBackup.txt`
3. Review telemetry file: `C:\Support\Remediation-PSTBackup-*.txt`
4. For files >2GB: Contact IT support for manual backup assistance

---

## Testing Before Deployment

Before deploying to all devices, test each script pair locally:

### Local Testing Procedure

```powershell
# 1. Download scripts to test machine
# (Copy files from this directory)

# 2. Test detection
.\Detect-OneDriveKFB.ps1
echo $LASTEXITCODE  # 0 = compliant, 1 = non-compliant

# 3. If non-compliant, test remediation
.\Remediate-OneDriveKFB.ps1
echo $LASTEXITCODE  # 0 = success, 1 = failed

# 4. Verify detection now passes
.\Detect-OneDriveKFB.ps1
echo $LASTEXITCODE  # Should be 0

# 5. Check reports
Get-Content C:\Support\Remediation-*.txt
```

### Pilot Group Testing

1. Create pilot group with 5-10 test devices
2. Deploy remediation scripts to pilot group only
3. Monitor for 24-48 hours
4. Check Intune compliance reports
5. Collect and review `C:\Support\` reports from pilot devices
6. Expand to all devices after validation

---

## Script Details

### OneDrive KFB Enforcement

**What it does:**

- Detects if Desktop, Documents, Pictures are backed up to OneDrive
- Enables Known Folder Move via OneDrive policy
- Restarts OneDrive to apply changes

**Remediation actions:**

- Sets registry policy `KFMSilentOptIn` for tenant
- Triggers OneDrive reconfiguration
- Verifies folders redirected to OneDrive path

**High-risk detection:**

- OneDrive process running check
- Documents folder accessibility
- Sufficient disk space (≥1GB)

**Expected runtime:** 20-30 seconds

### Printer Backup

**What it does:**

- Exports all printer configurations to OneDrive Documents
- Captures printer names, ports, drivers, and default printer
- Creates human-readable backup file for post-migration reference

**Remediation actions:**

- Uses WMI `Win32_Printer` to enumerate all printers
- Exports printer details to `IPS-Migration-PrinterBackup.txt`
- Writes telemetry to `C:\Support\`

**High-risk detection:**

- OneDrive process running check
- Print Spooler service status
- Excessive printer count (>50 = back off)
- Sufficient disk space (≥1GB)

**Expected runtime:** 10-15 seconds

### WiFi Backup

**What it does:**

- Captures current WiFi SSID for post-migration reconnection
- Saves WiFi network name to OneDrive Documents
- Handles devices without WiFi hardware gracefully

**Remediation actions:**

- Uses `netsh wlan show interfaces` to get current SSID
- Exports to `IPS-Migration-WiFiSSID.txt`
- Creates "Not applicable" file if WiFi not available

**High-risk detection:**

- OneDrive process running check
- Wireless service (WlanSvc) availability
- Sufficient disk space (≥1GB)

**Expected runtime:** 5-10 seconds

### PST Backup

**What it does:**

- Searches for PST files in Outlook locations and user folders
- Copies PST files <2GB to OneDrive Documents backup folder
- Creates summary report with copied/skipped files

**Remediation actions:**

- Searches: `%LOCALAPPDATA%\Microsoft\Outlook`, `Documents`, `Desktop`
- Copies PST files to `IPS-Migration-PSTBackup\` folder
- Skips files >2GB (OneDrive sync limit)
- Tests file locks before copying
- Creates detailed summary: `BackupSummary.txt`

**High-risk detection:**

- OneDrive process running check
- Outlook process NOT running (avoid file locks)
- Total PST size vs available space (80% threshold)
- Network-located PST files (UNC paths) skipped
- Individual file lock testing
- 2GB per-file size limit
- Sufficient disk space (≥1GB)

**Expected runtime:** Varies (1-10 minutes depending on PST count and size)

---

## Toast Notifications

When a remediation script detects a high-risk condition requiring user action, it displays a **Windows Toast Notification** to alert the user immediately.

### Toast Behavior

- **Auto-dismiss**: Disappears after 10 seconds
- **Non-blocking**: User can continue working
- **Action-oriented**: Clear message about what to do next
- **Fail-safe**: Warning files are still created in Documents folder

### Example Toast Messages

- "Please close Outlook completely. Your PST files will be backed up automatically once closed."
- "Please start OneDrive and sign in. Your printer configuration will be backed up automatically."
- "Free up at least 1GB of disk space. Backup will retry automatically."

### When Toasts Appear

Toasts are shown only for scenarios requiring user action:

| Script             | Toast Triggers                                                                                                |
| ------------------ | ------------------------------------------------------------------------------------------------------------- |
| **Printer Backup** | OneDrive not running, Low disk space, Print Spooler stopped, Excessive printer count (>50)                    |
| **WiFi Backup**    | OneDrive not running, Low disk space                                                                          |
| **PST Backup**     | OneDrive not running, Outlook running (file lock), Low disk space, PST files too large (>80% available space) |
| **OneDrive KFB**   | No toasts (uses Event Log only)                                                                               |

### Technical Details

**IT Note:** Toast notifications use Windows native API (no external dependencies). The script tries BurntToast module first (if installed), then falls back to `Windows.UI.Notifications` API (Windows 10 1607+ / Windows 11).

If toast display fails, the warning file in Documents folder ensures users are still notified. Toast delivery success/failure is tracked in telemetry JSON files (`C:\Support\Remediation-*.json`).

**Focus Assist:** Toasts may be suppressed if user has Focus Assist enabled. Warning files provide backup notification method.

---

## Best Practices

1. **Deploy in order**: OneDrive KFB → Printer Backup → WiFi Backup → PST Backup
2. **Monitor Event Logs**: First 7 days post-deployment
3. **Collect telemetry weekly**: Analyze trends and common issues
4. **Check warning files**: Review `IPS-Migration-WARNING-*.txt` files in OneDrive Documents
5. **PST backup timing**: Run PST backup when Outlook is closed (after-hours deployment recommended)
6. **Adjust frequency**: After 30 days, reduce to weekly or monthly
7. **Test locally first**: Always validate scripts on test machine before production

---

## Support

For issues or questions:

- **IT Support**: support@impactpropertysolutions.com / 817-662-7226
- **Migration Team**: Suleman Manji (smanji@viyu.net)

---

## Version History

- **v1.0** (January 2026) - Initial release for Monday Go-Live migration
