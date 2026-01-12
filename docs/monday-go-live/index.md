---
layout: default
title: Monday Go-Live
nav_order: 4
has_children: true
---

# Monday Go-Live

Comprehensive coordination guide for the January 19, 2026 migration go-live.

---

<div style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; padding: 1.5rem; border-radius: 12px; margin: 1.5rem 0; text-align: center;">
<h2 style="color: white; margin: 0 0 0.5rem 0;">Go-Live Date</h2>
<p style="font-size: 1.5rem; font-weight: bold; margin: 0;">Monday, January 19, 2026</p>
<p style="margin: 0.5rem 0 0 0;">27 sites + Remote | 216 users | RFMS cutover Jan 17-18</p>
</div>

---

## Quick Reference Card

<div style="background: #f8f9fa; border: 2px solid #1e3c72; border-radius: 12px; padding: 1.5rem; margin: 1rem 0;">

<div style="background: linear-gradient(135deg, #6f42c1 0%, #5a32a3 100%); color: white; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; text-align: center;">
<strong style="font-size: 1.1em;">📞 Go-Live Operations Call</strong><br>
<span style="font-size: 1.2em; font-weight: bold;">Teams Call Open 6:00 AM CST - Duration of Operations</span><br>
<span style="font-size: 0.9em; opacity: 0.9;">Monday, January 19, 2026 | Direct Invite Only</span>
</div>

<h3 style="margin-top: 0; color: #1e3c72; border-bottom: 2px solid #1e3c72; padding-bottom: 0.5rem;">Emergency Contacts</h3>

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1rem; margin: 1rem 0;">

<div style="background: white; padding: 1rem; border-radius: 8px; border-left: 4px solid #dc3545;">
<strong style="color: #dc3545;">Device Reset / Wipes</strong><br>
<strong>Suleman Manji</strong><br>
469-364-6222<br>
<code>smanji@viyu.net</code> (Teams)
</div>

<div style="background: white; padding: 1rem; border-radius: 8px; border-left: 4px solid #fd7e14;">
<strong style="color: #fd7e14;">RFMS / Floorsight / Printers</strong><br>
<strong>Brian Vaughan</strong><br>
<code>bvaughan@impactpropertysolutions.com</code>
</div>

<div style="background: white; padding: 1rem; border-radius: 8px; border-left: 4px solid #007bff;">
<strong style="color: #007bff;">Network / VPN / IPsec</strong><br>
<strong>Landon Hill</strong><br>
<code>lhill@viyu.net</code>
</div>

<div style="background: white; padding: 1rem; border-radius: 8px; border-left: 4px solid #28a745;">
<strong style="color: #28a745;">Support Line</strong><br>
<strong>817-662-7226</strong><br>
<code>support@impactpropertysolutions.com</code>
</div>

</div>

<h4 style="margin-top: 1.5rem; margin-bottom: 0.5rem; color: #1e3c72;">Escalation Matrix</h4>

<table style="width: 100%; border-collapse: collapse; font-size: 0.9em;">
<thead>
<tr style="background: #e9ecef;">
<th style="padding: 0.5rem; text-align: left; border-bottom: 2px solid #dee2e6;">Issue Type</th>
<th style="padding: 0.5rem; text-align: left; border-bottom: 2px solid #dee2e6;">Primary Contact</th>
<th style="padding: 0.5rem; text-align: left; border-bottom: 2px solid #dee2e6;">Escalation Chain</th>
</tr>
</thead>
<tbody>
<tr><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">Device Reset/Wipes</td><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">Suleman Manji</td><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">ILG (Willie) for wipes</td></tr>
<tr><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">Autopilot Removal</td><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">ILG IT Team</td><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">Willie, Brett</td></tr>
<tr><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">RDP/RFMS/Floorsight</td><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">Brian Vaughan</td><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">Primary escalation</td></tr>
<tr><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">Network/VPN/IPsec</td><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">Landon Hill</td><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">Nick Christian → Imran</td></tr>
<tr><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">Verizon/iOS ABM</td><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">Trevor</td><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">Bradley (ILG) → Lana</td></tr>
<tr><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">Intune/Autopilot/ABM</td><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">Suleman Manji</td><td style="padding: 0.5rem; border-bottom: 1px solid #dee2e6;">Primary escalation</td></tr>
<tr><td style="padding: 0.5rem;">BitTitan/Email</td><td style="padding: 0.5rem;">Suleman Manji</td><td style="padding: 0.5rem;">Primary escalation</td></tr>
</tbody>
</table>

<h4 style="margin-top: 1.5rem; margin-bottom: 0.5rem;">Device Reset Submission Format</h4>
<code style="background: #e9ecef; padding: 0.5rem; display: block; border-radius: 4px; font-size: 0.9em;">
Windows Serial: [SERIAL] | iOS Serial: [SERIAL] | iOS UDID: [UDID]
</code>
<p style="margin: 0.5rem 0 0 0; font-size: 0.85em; color: #666;">Send to Suleman Manji via Microsoft Teams</p>

</div>

---

## Quick Navigation

| Section                                | Description                                    |
| -------------------------------------- | ---------------------------------------------- |
| [Schedule & Calendar](schedule.html)   | Visual calendar, pre-migration timeline        |
| [Site Directory](sites.html)           | All 27 sites organized by timezone             |
| [Network Status](network-status.html)  | Network migration status for all sites         |
| [Prerequisites](prerequisites.html)    | Pre-visit checklists, user communication       |
| [Migration Workflow](workflow.html)    | 5-phase migration process                      |
| [Contacts & Escalation](contacts.html) | Stakeholders, support teams, escalation matrix |
| [Migration Tools](tools.html)          | PowerShell scripts for automated backup        |

---

## Phased Migration Strategy

This guide reflects the **phased migration approach**:

- **Jan 5:** Communication begins, identify key users
- **Jan 16-17:** Key user pre-migration
- **Jan 17-18:** RFMS/Floorsight cutover weekend
- **Jan 19:** Full go-live

---

## Migration Goals

| Target                  | Objective                                                             |
| ----------------------- | --------------------------------------------------------------------- |
| **Windows Devices**     | Migrate to Impact Autopilot & Intune with full data restoration       |
| **iOS Devices**         | Verify recent backup exists (backup verification only)                |
| **Data Preservation**   | Backup all user data, settings, and configurations                    |
| **Business Continuity** | RFMS/Floorsight cutover during weekend to minimize operational impact |
| **Remote User Support** | Microsoft Bookings for scheduled migration appointments               |

---

## Timeline Overview

| Date       | Day     | Activity                                                  |
| ---------- | ------- | --------------------------------------------------------- |
| Jan 5      | Mon     | Communication begins, identify key users                  |
| Jan 12     | Mon     | Reminder email, ILG removes devices from Autopilot        |
| Jan 13     | Tue     | iOS email setup instructions                              |
| Jan 15     | Wed     | Data sync start (BitTitan), Verizon/ABM migration         |
| Jan 16     | Fri     | **3:00 PM Central - Key User migration activities begin** |
| Jan 16     | Fri     | **7:00 PM Pacific - RFMS & Floorsight shutdown**          |
| Jan 17     | Sat     | RFMS/Floorsight restore                                   |
| Jan 18     | Sun     | System validation and final checks                        |
| **Jan 19** | **Mon** | **GO-LIVE - Remote hands at all 27 sites**                |
| Jan 20+    | Tue+    | Remote mobile device support                              |

---

## Time Estimates (Parallel Processing)

{: .note }

> **Setup Strategy:** Set up multiple laptops in a conference room on a table. Technician walks around the table working on devices simultaneously. This parallel approach is critical for meeting the deployment timeline.

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin: 1rem 0;">

<div style="border: 1px solid #dee2e6; border-radius: 8px; padding: 1rem; text-align: center;">
<h4 style="margin-top: 0;">Per User Average</h4>
<p style="font-size: 1.5rem; font-weight: bold; margin: 0.5rem 0;">45 minutes</p>
<p style="font-size: 0.9em; color: #666; margin: 0;">TOTAL if doing only that user</p>
</div>

<div style="border: 1px solid #dee2e6; border-radius: 8px; padding: 1rem; text-align: center;">
<h4 style="margin-top: 0;">5 Users (Parallel)</h4>
<p style="font-size: 1.5rem; font-weight: bold; margin: 0.5rem 0;">2-2.25 hours</p>
<p style="font-size: 0.9em; color: #666; margin: 0;">NOT 3h 45m (50% time savings)</p>
</div>

<div style="border: 1px solid #dee2e6; border-radius: 8px; padding: 1rem;">
<h4 style="margin-top: 0;">Typical Breakdown</h4>
<ul style="margin: 0; padding-left: 1.5rem; font-size: 0.9em;">
<li>0:00-0:15: Fast backups (4-5 users)</li>
<li>0:15-0:40: Reset wait window</li>
<li>0:40-1:30: Staggered OOBE</li>
<li>1:30-2:00: Concurrent validation</li>
</ul>
</div>

</div>

{: .important }

> **Timeline Impact:** Parallel processing is essential for the January 19, 2026 deployment. Without it, sites would take 1.5-2x longer and require multiple days.

---

## Key Metrics

| Metric                 | Value                    |
| ---------------------- | ------------------------ |
| Total Physical Sites   | 27                       |
| Remote Users           | 34                       |
| Total Users            | 216                      |
| Sites with Onsite Tech | 21                       |
| No Hands Needed Sites  | 6                        |
| Call Centers           | 5                        |
| Go-Live Date           | Monday, January 19, 2026 |
