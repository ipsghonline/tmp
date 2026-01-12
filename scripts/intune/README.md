# Intune Remediation Scripts

Post-migration validation scripts for Impact Property Solutions Monday Go-Live migration.

## Overview

These Intune Proactive Remediation scripts detect and fix common post-migration issues automatically on Windows devices in the Impact tenant.

### Available Remediation Pairs

| Remediation                      | Purpose                                                                  | Files                                                             |
| -------------------------------- | ------------------------------------------------------------------------ | ----------------------------------------------------------------- |
| **OneDrive KFB Enforcement**     | Ensures Desktop, Documents, and Pictures are backed up to OneDrive       | `Detect-OneDriveKFB.ps1`<br>`Remediate-OneDriveKFB.ps1`           |
| **Old Tenant Cleanup**           | Removes Pinnacle/ILG tenant artifacts (OST files, credentials, registry) | `Detect-OldTenantData.ps1`<br>`Remediate-OldTenantData.ps1`       |
| **Migration Success Validation** | Verifies required apps installed and connectivity working                | `Detect-MigrationSuccess.ps1`<br>`Remediate-MigrationSuccess.ps1` |

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

1. **OneDrive KFB Enforcement** (Priority 1 - Data protection)
2. **Old Tenant Cleanup** (Priority 2 - Remove confusion artifacts)
3. **Migration Success Validation** (Priority 3 - Overall validation)

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

#### Old Tenant Data Still Present

**Symptoms**: Old Tenant Cleanup shows "Issues detected" repeatedly
**Cause**: Outlook may have OST files locked, or credentials recreated by cached apps
**Solution**:

1. Close Outlook completely
2. Run remediation script manually:
   ```powershell
   .\Remediate-OldTenantData.ps1
   ```
3. Check `C:\Support\Remediation-OldTenantCleanup-*.txt` for specific items not removed

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

**Expected runtime:** 20-30 seconds

### Old Tenant Cleanup

**What it does:**

- Finds old OST files (>30 days) from Pinnacle tenant
- Detects cached credentials for `@pinnacle*`, `@ilginc.com`
- Identifies old device registrations in registry

**Remediation actions:**

- Deletes old OST files from `%LOCALAPPDATA%\Microsoft\Outlook`
- Removes credentials via `cmdkey /delete`
- Cleans registry keys under `HKCU:\Software\Microsoft\Windows\CurrentVersion\AAD\Storage`

**Expected runtime:** 10-20 seconds

### Migration Success Validation

**What it does:**

- Verifies required apps installed (Outlook, Teams, Chrome, Foxit, NinjaOne)
- Checks device enrolled in Impact tenant
- Tests connectivity to Microsoft 365 endpoints

**Remediation actions:**

- Logs missing applications (cannot install - requires Intune app deployment)
- Repairs OneDrive sync if stuck
- Clears DNS cache and resets network if connectivity issues

**Expected runtime:** 30-45 seconds

---

## Best Practices

1. **Deploy in order**: OneDrive KFB → Old Tenant → Migration Success
2. **Monitor Event Logs**: First 7 days post-deployment
3. **Collect telemetry weekly**: Analyze trends and common issues
4. **Adjust frequency**: After 30 days, reduce to weekly or monthly
5. **Test locally first**: Always validate scripts on test machine before production

---

## Support

For issues or questions:

- **IT Support**: support@impactpropertysolutions.com / 817-662-7226
- **Migration Team**: Suleman Manji (smanji@viyu.net)

---

## Version History

- **v1.0** (January 2026) - Initial release for Monday Go-Live migration
