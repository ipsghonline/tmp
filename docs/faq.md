---
layout: default
title: FAQ
nav_order: 5
---

# Frequently Asked Questions

Find answers to common questions about the Impact environment migration.

---

## End User Questions

### What is Key User Migration?

Key Users are being migrated into the Impact environment ahead of the January 19th GO-Live date (January 16-17, 2026). This ensures critical personnel are fully operational to support the organization during the broader transition.

**Key Details:**

- **Migration Dates:** Friday & Saturday, January 16-17, 2026
- **Booking Deadline:** End of business Monday, January 12
- **Access Restored:** Late Sunday night, January 18

If you are a Key User, please [schedule your migration appointment](https://outlook.office.com/book/KeyUserMigration@ImpactFloors.com/?ismsaljsauthenabled) and review the [complete Key User Migration information](key-user-migration.html).

---

### What happens to my files during migration?

Your email and OneDrive files have already been pre-migrated to the Impact environment using BitTitan. This means your data is already in the new system before your device migration appointment.

{: .note }

> **Recent Files:** Files created or modified very recently may take a few hours to appear in the new environment. If any files are missing after more than 24 hours, please contact support@impactpropertysolutions.com.

### How long will the migration take?

We have allotted **up to 2 hours** for each user support session. During this time, a technician will guide you through the device wipe, re-enrollment, and initial setup in the new Impact environment.

{: .highlight }

> **We won't leave you hanging!** While we've scheduled 2-hour blocks, our technicians will stay connected with you until the migration is complete and your device is fully functional.

### Can I work during the migration?

No, you will not be able to use your primary device during the migration. We recommend having a mobile device available to join the Teams support call and handle any urgent communications.

### What if I miss my scheduled migration time?

Contact IT support immediately to reschedule. Key Users must complete migration before the January 19th GO-Live date to ensure operational continuity.

### Will my apps still work after migration?

Yes, your applications will be reinstalled and configured for the Impact environment. Expected applications include:

- Microsoft 365 (Outlook, Teams, Word, Excel, etc.)
- FloorSight
- RFMS
- Adobe Acrobat
- Any other Impact-configured applications

### When will I have access to email and systems again?

After migration, your profile needs time to provision in the new environment. You will have access to:

- **RFMS** - Late Sunday night
- **Email** - Late Sunday night
- **FloorSight** - Late Sunday night
- **Other Impact resources** - Late Sunday night

### Do I need to be in the office for migration?

No, migration can be completed from **any location** with a stable internet connection. You do not need to be physically present in the office.

### What should I have ready for my appointment?

Please prepare:

- Your laptop and charger
- A stable internet connection
- A mobile device and charger to join the Teams support call

---

## Technician Questions

### What's the rollback procedure if migration fails?

If the migration fails during any phase:

1. Document the exact error message and phase
2. Attempt the standard troubleshooting steps for that phase
3. If unresolved, escalate to the Migration Support Team
4. A device can be re-enrolled to the original ILG environment as a fallback, but this requires coordinator approval

### How do I handle network connectivity issues?

1. Verify the user has a stable internet connection (recommend wired if available)
2. Check if firewall/VPN is blocking required Microsoft endpoints
3. Test connectivity to `login.microsoftonline.com` and `portal.azure.com`
4. If using corporate network, ensure required ports are open (443, 80)
5. As a last resort, use mobile hotspot for enrollment

### What credentials do I need for migration support?

- **Technician Portal Access** - Your Impact admin credentials
- **Intune Admin Center** - Delegated admin access
- **Azure AD** - Read access for user verification
- **Teams** - For user support calls

### How do I escalate critical issues?

**Escalation Matrix:**

1. **Level 1** - Migration Support Team (Reasat, Trevor, Sean, Doug, Marcus, Suleman*, Brian* via Microsoft Teams)
2. **Level 2** - Infrastructure/Network/Migration Team (Brian Vaughan, Landon Hill, Suleman Manji via dedicated Microsoft Teams channel)
3. **Emergency** - Suleman Manji @ 469-364-6222

---

### Support Escalation Contacts

| Issue Type              | Primary Contact | Escalation Chain                                | Contact Information                                                                    |
| ----------------------- | --------------- | ----------------------------------------------- | -------------------------------------------------------------------------------------- |
| Device Reset Delays     | Suleman Manji   | → Willie Day → Raymond Rodriguez                | smanji@viyu.net, rrodriguez@ilginc.com, wdallas@ilginc.com                             |
| Network/Internet Issues | Landon Hill     | → Nick Christian → Imran Saleem → Goutham Reddy | lhill@viyu.net, nchristian@viyu.net, imran.saleem@ilginc.com, goutham.reddy@ilginc.com |
| RDP/RFMS Issues         | Brian Vaughan   | Primary escalation point                        | bvaughan@impactpropertysolutions.com, MS Teams                                         |
| Printer Issues          | Brian Vaughan   | → Suleman Manji → Brett McGolrick → Sean Skeels | bvaughan@impactpropertysolutions.com, smanji@viyu.net                                  |
| Intune/iOS/ABM Issues   | Suleman Manji   | Primary escalation point                        | smanji@viyu.net, wdallas@ilginc.com                                                    |
| User Data/Identity      | Suleman Manji   | → Raymond Rodriguez                             | smanji@viyu.net (MS Teams), rrodriguez@ilginc.com                                      |

### What are the success criteria for each migration phase?

| Phase        | Success Criteria                                    |
| ------------ | --------------------------------------------------- |
| Backup       | OneDrive sync complete, critical files identified   |
| Device Wipe  | Intune wipe initiated successfully                  |
| OOBE         | Device reaches Windows setup screen                 |
| Enrollment   | Device appears in Intune, Autopilot profile applied |
| ESP          | All required apps installed, policies applied       |
| Verification | User can sign in, apps launch, network connected    |
| Handoff      | User confirms access, support ticket closed         |

### How do I handle users with non-standard configurations?

Document the non-standard configuration and consult the [Administrator Guide](../Windows_Device_Migration_Administrator_Guide.html) for specific procedures. Common exceptions include:

- Dell devices with pre-provisioning
- Users with specialized hardware (printers, scanners)
- Users requiring legacy application support

---

## Still Have Questions?

Contact the Migration Support Team for assistance.

**Support Line:** 817-662-7226

**Email:** support@impactpropertysolutions.com

**Emergency:** Suleman Manji - 469-364-6222
