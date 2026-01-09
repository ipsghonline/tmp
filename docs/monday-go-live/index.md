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

| Date       | Day     | Activity                                                |
| ---------- | ------- | ------------------------------------------------------- |
| Jan 5      | Mon     | Communication begins, identify key users                |
| Jan 12     | Mon     | Reminder email, ILG removes devices from Autopilot      |
| Jan 13     | Tue     | iOS email setup instructions                            |
| Jan 15     | Wed     | Data sync start (BitTitan), Verizon/ABM migration       |
| Jan 16     | Fri     | Key user migration begins                               |
| Jan 16     | Fri     | **7:00 PM Pacific - RFMS & Floorsight shutdown**        |
| Jan 17     | Sat     | AMSYS on-site at 6 large sites, RFMS/Floorsight restore |
| Jan 18     | Sun     | System validation and final checks                      |
| **Jan 19** | **Mon** | **GO-LIVE - Remote hands at all 27 sites**              |
| Jan 20+    | Tue+    | Remote mobile device support                            |

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

## Quick Navigation

| Section                                | Description                                    |
| -------------------------------------- | ---------------------------------------------- |
| [Schedule & Calendar](schedule.html)   | Visual calendar, pre-migration timeline        |
| [Site Directory](sites.html)           | All 27 sites organized by timezone             |
| [Network Status](network-status.html)  | Network migration status for all sites         |
| [Prerequisites](prerequisites.html)    | Pre-visit checklists, user communication       |
| [Migration Workflow](workflow.html)    | 6-phase migration process                      |
| [Contacts & Escalation](contacts.html) | Stakeholders, support teams, escalation matrix |

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
