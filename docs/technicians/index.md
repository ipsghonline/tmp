---
layout: default
title: Technician Documentation
nav_order: 3
has_children: true
---

# Technician Documentation

Technical reference materials and procedures for migration support staff.

---

<div style="background: #fff3cd; border-left: 4px solid #ffc107; padding: 1rem; border-radius: 4px; margin: 1.5rem 0;">
<strong>Key User Migration:</strong> January 16-17, 2026. Review the <a href="../quick-reference.html">Quick Reference</a> for key dates and contacts.
</div>

---

## Technical Guides

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1rem; margin: 1.5rem 0;">

<div style="border: 1px solid #dee2e6; border-radius: 8px; padding: 1.25rem;">
<span style="background: #6c757d; color: white; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.75rem;">INFRASTRUCTURE</span>
<h3 style="margin: 0.75rem 0 0.5rem;">Network Migration</h3>
<p style="color: #6c757d; font-size: 0.9rem;">Complete 14-step network infrastructure migration procedure.</p>
<p><strong>Duration:</strong> ~45 min read</p>
<a href="guides/network-migration.html">View Guide →</a>
</div>

<div style="border: 1px solid #dee2e6; border-radius: 8px; padding: 1.25rem;">
<span style="background: #dc3545; color: white; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.75rem;">COORDINATION</span>
<h3 style="margin: 0.75rem 0 0.5rem;">Onsite Coordination</h3>
<p style="color: #6c757d; font-size: 0.9rem;">Multi-site deployment coordination and 22-site schedule.</p>
<p><strong>Duration:</strong> ~60 min read</p>
<a href="guides/onsite-coordination.html">View Guide →</a>
</div>

<div style="border: 1px solid #dee2e6; border-radius: 8px; padding: 1.25rem;">
<span style="background: #17a2b8; color: white; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.75rem;">ADMIN</span>
<h3 style="margin: 0.75rem 0 0.5rem;">Administrator Guide</h3>
<p style="color: #6c757d; font-size: 0.9rem;">Quick reference for device management and Dell pre-provisioning.</p>
<p><strong>Duration:</strong> ~20 min read</p>
<a href="guides/admin-guide.html">View Guide →</a>
</div>

</div>

---

## Quick Resources

| Resource                                                     | Description                 |
| ------------------------------------------------------------ | --------------------------- |
| [Troubleshooting](../troubleshooting.html)                   | Common issues and solutions |
| [FAQ](../faq.html#technician-questions)                      | Technical FAQ               |
| [Escalation Guide](../troubleshooting.html#escalation-guide) | When and how to escalate    |
| [Glossary](../glossary.html)                                 | Technical terminology       |

---

## Escalation Matrix

| Level         | Scope                          | Contact                      |
| ------------- | ------------------------------ | ---------------------------- |
| **Level 1**   | Basic troubleshooting (15 min) | Local IT Support             |
| **Level 2**   | Complex enrollment issues      | Migration Support Team       |
| **Level 3**   | Network/infrastructure         | Infrastructure Team          |
| **Emergency** | Critical blockers              | Brian Vaughan (720-289-4924) |

---

## Admin Portal Access

| Portal            | URL                    | Purpose                  |
| ----------------- | ---------------------- | ------------------------ |
| **Intune**        | endpoint.microsoft.com | Device management        |
| **Azure AD**      | portal.azure.com       | User/identity management |
| **Microsoft 365** | admin.microsoft.com    | Licensing and services   |

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

## Full Documentation

| Guide                                                              | Description                 | Audience          |
| ------------------------------------------------------------------ | --------------------------- | ----------------- |
| [Network Migration Reference](../network-migration-reference.html) | Complete network procedures | Network Engineers |
| [Onsite Coordination Overview](../onsite-coordination-guide.html)  | Multi-site deployment       | Coordinators      |
| [Administrator Guide](../admin-migration-guide.html)               | Device management           | IT Admins         |

---

## Need Help?

**Migration Support Team:** support@impactfloors.com

**Emergency Contact:** Brian Vaughan - 720-289-4924
