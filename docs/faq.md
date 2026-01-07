---
layout: default
title: FAQ
nav_order: 5
---

# Frequently Asked Questions

Find answers to common questions about the Impact environment migration.

---

## End User Questions

### What happens to my files during migration?

Your files stored in OneDrive will be migrated to the new Impact environment. Local files on your device will be preserved during the Intune wipe and re-enrollment process. However, we recommend backing up any critical local files before your migration appointment.

### How long will the migration take?

The migration process takes **up to 2 hours**. During this time, a technician will guide you through the device wipe, re-enrollment, and initial setup in the new Impact environment.

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

1. **Level 1** - Local IT Support (first 15 minutes)
2. **Level 2** - Migration Support Team (unresolved after troubleshooting)
3. **Level 3** - Network/Infrastructure Team (connectivity or network issues)
4. **Emergency** - Contact Brian Vaughan (VP Technology) for critical blockers

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

Contact your IT support team or reach out to the Migration Support Team for assistance.
