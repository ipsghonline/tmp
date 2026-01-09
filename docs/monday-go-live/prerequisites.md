---
layout: default
title: Prerequisites
parent: Monday Go-Live
nav_order: 4
---

# Prerequisites

Pre-visit checklists, user communication, and remote scheduling requirements.

---

## Before Every Onsite Visit

{: .note }

> Complete this checklist before arriving at any site.

- [ ] **Apple Devices App** - Installed on Windows PC (for iOS backup verification)
- [ ] **VPN Access** - Verified and tested
- [ ] **MS Teams Account** - Active and ready for serial number submissions
- [ ] **Network Connection Tools** - Ping/network diagnostic tools available
- [ ] **Backup Storage** - USB drive or cloud storage for temporary files

### Key Contact

| Name              | Role                     | Contact                      |
| ----------------- | ------------------------ | ---------------------------- |
| **Suleman Manji** | Device Reset Coordinator | `smanji@viyu.net` / MS Teams |

---

## User Communication - January 12, 2026

{: .important }

> **Migration Reminder Email** (sent by Brian/Alisha)

Users will receive communication instructing them to:

- Leave computers at workstations with sticky notes to identify devices
- Report to the office on **Monday, January 19, 2026** to get their device migrated
- **Remote users:** Contact `support@impactpropertysolutions.com` to schedule a migration time
- Be aware they will not have access to email over the weekend (Jan 17-18)

---

## Remote User Scheduling (Microsoft Bookings)

{: .warning }

> **For remote/sales users who cannot come to the office:**

1. Book a migration slot via Microsoft Bookings (link TBD)
2. Provide device serial number when booking (required for Autopilot removal)
3. During scheduled time: ILG pushes wipe → Wait 5 min → Reboot → Login with Impact credentials
4. Migration takes 10-15 minutes per device

**Note:** We cannot help 30 people at once - booking controls the support queue.

---

## Remote Support Migration Procedure

{: .note }

> **Service Engineer Guide for Remote Users**

For remote users who cannot come to the office on January 19, 2026, service engineers follow a comprehensive 7-phase remote support workflow:

| Phase | Name                  | Description                                                                            |
| ----- | --------------------- | -------------------------------------------------------------------------------------- |
| 1     | Pre-Migration Backup  | Browser bookmarks, printer config, OneDrive sync verification, iOS backup verification |
| 2     | Device Documentation  | Serial numbers collected and sent to Suleman for Autopilot coordination                |
| 3     | Windows OOBE          | Guide user through Out-of-Box Experience with Autopilot enrollment                     |
| 4     | Post-ESP Verification | Verify all applications installed correctly                                            |
| 5     | User Validation       | 3-Point Test: Internet, RFMS RDP, Printer functionality                                |
| 6     | Browser Restoration   | Import bookmarks for Chrome, Edge, Firefox                                             |
| 7     | Final Verification    | iOS backup verification, sign-off and documentation                                    |

**Time Estimate:** 60-90 minutes active time per remote user

---

## Key User Pre-Migration (January 16-17)

{: .important }

> **Key User Migration Weekend:** Friday-Saturday for sales team and remote users. Schedule via Microsoft Bookings.

Key users include:

- Sales team members who need devices operational Monday morning
- Customer service personnel at critical locations
- Remote workers who cannot attend Monday go-live

### Scheduling Process

1. Key users identified by Brian Vaughan / Alisha by January 5
2. Users book migration slots via Microsoft Bookings
3. Friday 1/16: Office-based key user migrations begin
4. Saturday 1/17: Continue key user migrations at customer service locations

---

## Small Sites Strategy

{: .note .bg-green-100 }

> **Decision: AMSYS On-Site for ALL Sites**

After cost analysis (Dec 4, 2025 planning session), the team decided to use AMSYS on-site technicians for **all 22 sites**, including those with 1-4 users.

| Factor           | Remote                  | On-Site                  |
| ---------------- | ----------------------- | ------------------------ |
| Time per user    | 3-4 hours (1:1 support) | ~1 hour (3:1 efficiency) |
| Cost comparison  | Higher                  | 3:1 cost reduction       |
| Project capacity | 685 hours budgeted      | 93 consumed              |

**Result:** Small sites (El Paso 3 users, Jacksonville 2 users, Tucson 2 users, etc.) will have AMSYS technicians on-site Monday January 19, 2026.

---

## Phased Approach Benefits

| Benefit                           | Description                                                                                   |
| --------------------------------- | --------------------------------------------------------------------------------------------- |
| **Operations Continuity**         | RFMS/Floorsight cutover happens over the weekend (Jan 17-18) when locations are closed        |
| **Key User Pre-Migration**        | Friday-Saturday migration ensures critical operations have functioning devices Monday morning |
| **Remote User Scheduling**        | Microsoft Bookings controls support queue, avoiding 30+ simultaneous requests                 |
| **Network Congestion Management** | Staggered device migrations prevent overwhelming network infrastructure                       |
| **Call Center Backup**            | Backup laptops at call centers serve as loaner devices during transition                      |
