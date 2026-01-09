---
layout: default
title: Troubleshooting
nav_order: 7
---

# Troubleshooting Guide

Common issues and solutions during the Impact environment migration.

---

## Network Connectivity Issues

### Cannot connect to Microsoft services

**Symptoms:**

- Unable to reach login.microsoftonline.com
- Enrollment fails with network error
- Timeout during Autopilot registration

**Solutions:**

1. Verify internet connection is stable
2. Try a different network (mobile hotspot as backup)
3. Disable VPN if connected
4. Check firewall isn't blocking Microsoft endpoints
5. Flush DNS cache: `ipconfig /flushdns`

**Required Endpoints:**

- `login.microsoftonline.com`
- `portal.azure.com`
- `enterpriseregistration.windows.net`
- `*.manage.microsoft.com`

---

### VPN connection fails after migration

**Symptoms:**

- VPN client shows "connection failed"
- Certificate errors when connecting
- Previous VPN profile doesn't work

**Solutions:**

1. VPN must be reconfigured for Impact environment
2. Remove old ILG VPN profiles
3. Contact IT for new VPN configuration
4. Verify network adapter settings

---

## Autopilot Enrollment Issues

### Device stuck at "Identifying your device"

**Symptoms:**

- Progress spinner shows indefinitely
- OOBE doesn't advance past identification

**Solutions:**

1. Wait at least 10 minutes (network latency)
2. Verify device has internet connectivity
3. Restart device and try again
4. Check if device hardware hash is registered in Intune

---

### Enrollment Status Page (ESP) fails

**Symptoms:**

- ESP shows error code
- Apps fail to install
- Policies don't apply

**Common Error Codes:**

| Error Code | Meaning              | Solution                                |
| ---------- | -------------------- | --------------------------------------- |
| 0x80070774 | Network issue        | Check connectivity, retry               |
| 0x80180014 | Device not found     | Verify Autopilot registration           |
| 0x801c0003 | Azure AD join failed | Check licensing, retry enrollment       |
| 0x80070032 | App install failed   | Skip and install manually, report to IT |

**General ESP Troubleshooting:**

1. Note the specific error code
2. Wait and allow retry (ESP auto-retries)
3. If stuck >30 minutes, contact support
4. Last resort: Reset and re-enroll

---

### Device shows wrong Autopilot profile

**Symptoms:**

- Device assigned to wrong department
- Incorrect apps or policies applied

**Solutions:**

1. Document the incorrect assignment
2. Do NOT proceed with enrollment
3. Contact IT to reassign correct profile
4. Device may need to be reset

---

## App Installation Issues

### Microsoft 365 apps not installing

**Symptoms:**

- Office apps missing after ESP
- Download stuck at percentage
- "Installation failed" message

**Solutions:**

1. Verify internet connectivity
2. Check Windows Update isn't running
3. Wait for background installation (can take 30+ min)
4. Manually trigger: Settings > Apps > Microsoft 365 > Repair
5. If persistent, contact IT for manual installation

---

### FloorSight or RFMS not accessible

**Symptoms:**

- Application won't launch
- Login fails
- "Access denied" error

**Solutions:**

1. Verify profile has fully provisioned (wait until late Sunday)
2. Check you're using Impact credentials (not ILG)
3. Clear browser cache if web-based
4. Verify licensing assignment in admin portal

---

## Email and Profile Issues

### Email not syncing in Outlook

**Symptoms:**

- Outlook shows "Disconnected"
- No emails appearing
- Prompts for password repeatedly

**Solutions:**

1. Wait until late Sunday for profile provisioning
2. Verify using correct Impact email address
3. Remove and re-add email account
4. Check Outlook is configured for Exchange Online

**To reconfigure Outlook:**

1. Open Outlook > File > Account Settings
2. Remove existing account
3. Add new account with Impact email
4. Follow prompts for authentication

---

### Cannot access previous emails or files

**Symptoms:**

- Old emails missing
- OneDrive files not appearing

**Solutions:**

1. Emails migrate automatically - allow time for sync
2. OneDrive files appear after sign-in to new tenant
3. Large mailboxes may take 24-48 hours to fully sync
4. If missing after 48 hours, contact IT

---

## iOS/Mobile Device Issues

### iOS device not recognized in Apple Devices app

**Symptoms:**

- iPhone/iPad not appearing when connected via USB
- Apple Devices app shows no devices

**Solutions:**

1. Try a different USB cable (use Apple-certified cable)
2. Try a different USB port on the computer
3. On the iOS device, tap "Trust" when prompted
4. Restart both the iOS device and computer
5. Update Apple Devices app from Microsoft Store

---

### Cannot verify iOS backup status

**Symptoms:**

- Apple Devices app doesn't show backup date
- Backup appears incomplete

**Solutions:**

1. Ensure sufficient storage on computer for backup
2. Keep device connected until backup completes
3. Check that device is unlocked during backup
4. If backup fails, try backing up to iCloud instead

---

### Company Portal app not working

**Symptoms:**

- Company Portal crashes
- Cannot sign in
- Apps not appearing

**Solutions:**

1. Update Company Portal from App Store
2. Sign out and sign back in
3. Delete and reinstall Company Portal
4. Check device is enrolled in Intune

---

## Hardware Issues

### Laptop won't power on after wipe

**Symptoms:**

- Black screen
- No response to power button

**Solutions:**

1. Connect to power adapter
2. Hold power button 15 seconds
3. Try hard reset (remove battery if possible)
4. Contact IT - may need hardware support

---

### Bluetooth/WiFi not working after migration

**Symptoms:**

- Wireless devices not connecting
- Network adapter missing

**Solutions:**

1. Check Device Manager for driver issues
2. Run Windows Update for driver updates
3. Toggle WiFi/Bluetooth off and on
4. May need manual driver installation

---

## Escalation Guide

If troubleshooting doesn't resolve the issue:

### Level 1: Basic Support

- First 15 minutes of troubleshooting
- Standard restart and retry procedures

### Level 2: Migration Support Team

- Issues persisting after Level 1
- Complex enrollment failures
- Profile or licensing issues

### Level 3: Infrastructure Team

- Network or connectivity issues
- Azure AD or Intune backend problems
- Multi-user or site-wide issues

### Emergency Escalation

- **Contact:** Suleman Manji, Migration Team
- **When:** Critical blockers affecting GO-Live
- **Phone:** 469-364-6222

---

## Report an Issue

When reporting issues, include:

1. **Device:** Make, model, serial number
2. **User:** Name, email, department
3. **Phase:** Which migration step failed
4. **Error:** Exact error message or code
5. **Steps taken:** What troubleshooting was attempted
6. **Screenshots:** If applicable
