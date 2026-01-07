---
layout: default
title: Technician Documentation
nav_order: 3
has_children: true
---

# Technician Quick Reference

Migration weekend support guide for January 16-17.

---

<div style="background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%); color: white; padding: 1.5rem; border-radius: 12px; margin: 1.5rem 0; text-align: center;">
<h2 style="color: white; margin: 0 0 0.5rem 0;">Key User Migration Weekend</h2>
<p style="font-size: 1.5rem; font-weight: bold; margin: 0;">Friday & Saturday, January 16-17</p>
<p style="margin: 0.5rem 0 0 0;">55 users | 6 time slots | GO-Live: Monday, January 19</p>
</div>

---

## Migration Workflow Quick Reference

| Phase               | Duration     | Key Actions                                                   | Success Criteria      |
| ------------------- | ------------ | ------------------------------------------------------------- | --------------------- |
| **1. Pre-Backup**   | 15-20 min    | WiFi SSID, Browser sync/export, PST files, Printers, OneDrive | OneDrive 100% synced  |
| **2. Submit Reset** | 5 min + wait | Send serials to Suleman via Teams                             | Confirmation received |
| **3. OOBE**         | 30-60 min    | User signs in with @impactpropertysolutions.com               | ESP completes         |
| **4. App Verify**   | 10 min       | Outlook, Teams, Chrome, Foxit, NinjaOne, OneDrive             | All 7 apps present    |
| **5. 3-Point Test** | 10 min       | Internet → RFMS RDP → Printer                                 | All 3 pass            |
| **6. Restore**      | 15-20 min    | Browser sign-in, bookmarks, passwords, extensions             | User confirms         |

---

## Critical Reminders

{: .warning }

> **DO NOT proceed to OOBE** until reset confirmation received from Suleman

{: .danger }

> **DO NOT interrupt ESP screen** - User must not turn off device during app installation

{: .important }

> **We don't leave users hanging** - Stay connected until migration is complete

---

## Device Reset Submission

**Send to:** Suleman Manji via Microsoft Teams

**Format:**

```
Windows Serial: [SERIAL] | iOS Serial: [SERIAL] | iOS UDID: [UDID]
```

**Get Serial:** Settings → System → About → Device identifier (ALL CAPS, no spaces)

---

## 3-Point Validation Test

| Test         | How to Verify                           | Pass |
| ------------ | --------------------------------------- | ---- |
| **Internet** | Open browser → google.com               | [ ]  |
| **RFMS RDP** | Remote Desktop → Connect to RFMS server | [ ]  |
| **Printer**  | Notepad → Print test page               | [ ]  |

---

## Common Issues & Quick Fixes

| Issue                     | Quick Fix                                 |
| ------------------------- | ----------------------------------------- |
| ESP stuck >60 min         | Check network, may need restart           |
| OneDrive not syncing      | Wait 15 min, sign out/in, restart         |
| Bookmarks won't import    | Verify .html format (not .json)           |
| Apps missing after ESP    | Wait 10 min, check Intune portal          |
| Printer not found         | Use screenshot from Phase 1, add manually |
| Browser passwords missing | Import from CSV backup                    |

---

## Escalation Contacts

<div style="background: #f8d7da; padding: 1rem; border-radius: 8px; margin: 1rem 0; border-left: 4px solid #dc3545;">
<p><strong>Device Reset Issues / Emergency:</strong><br>
📞 <strong>Suleman Manji - 469-364-6343</strong> | Teams: smanji@viyu.net</p>
</div>

| Issue Type          | Primary Contact | Teams/Email                          |
| ------------------- | --------------- | ------------------------------------ |
| Device Reset Delays | Suleman Manji   | smanji@viyu.net                      |
| Network/Internet    | Landon Hill     | lhill@viyu.net                       |
| RDP/RFMS Issues     | Brian Vaughan   | bvaughan@impactpropertysolutions.com |
| Intune/iOS/ABM      | Suleman Manji   | smanji@viyu.net                      |

**Support Line:** 817-662-7226

---

## Key Verification Commands

```powershell
# Check Autopilot profile
Get-AutopilotDiagnostics

# Verify Intune enrollment
dsregcmd /status

# Check device compliance
Get-IntuneDeviceCompliancePolicy
```

---

## Admin Portal Quick Access

| Portal         | URL                    | Purpose           |
| -------------- | ---------------------- | ----------------- |
| **Intune**     | endpoint.microsoft.com | Device management |
| **Entra ID**   | portal.azure.com       | User/identity     |
| **M365 Admin** | admin.microsoft.com    | Licensing         |

---

## Full Documentation

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin: 1rem 0;">

<a href="../remote-support-worksheet.html" style="display: block; padding: 1rem; background: #007bff; color: white; text-decoration: none; border-radius: 8px; text-align: center; font-weight: bold;">
Full Migration Worksheet
</a>

<a href="../troubleshooting.html" style="display: block; padding: 1rem; background: #dc3545; color: white; text-decoration: none; border-radius: 8px; text-align: center; font-weight: bold;">
Troubleshooting Guide
</a>

<a href="../faq.html#technician-questions" style="display: block; padding: 1rem; background: #6c757d; color: white; text-decoration: none; border-radius: 8px; text-align: center; font-weight: bold;">
Technician FAQ
</a>

</div>

---

## Post-Session Checklist

- [ ] All 7 required apps verified
- [ ] 3-Point Test passed (Internet, RFMS, Printer)
- [ ] Browser data restored
- [ ] Sensitive backup files deleted (password CSVs!)
- [ ] OneDrive syncing
- [ ] User confirmed satisfied
- [ ] Document any issues for follow-up
