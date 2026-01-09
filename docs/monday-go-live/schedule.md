---
layout: default
title: Schedule & Calendar
parent: Monday Go-Live
nav_order: 1
---

# Schedule & Calendar

Visual calendar and detailed timeline for the January 2026 migration.

---

## January 2026 Calendar

{: .note }

> **Schedule Overview:** 27 sites + Remote | 216 users | Communication begins Jan 5 | Data sync Jan 15 | RFMS cutover Jan 17-18 | **Go-Live: Monday, January 19, 2026**

### Week 1: January 5-10

| Sun 4 | Mon 5                | Tue 6 | Wed 7 | Thu 8 | Fri 9 | Sat 10 |
| ----- | -------------------- | ----- | ----- | ----- | ----- | ------ |
| -     | Communication Begins | -     | -     | -     | -     | -      |
|       | Identify Key Users   |       |       |       |       |        |

### Week 2: January 11-17

| Sun 11 | Mon 12                | Tue 13          | Wed 14 | Thu 15                | Fri 16                 | Sat 17           |
| ------ | --------------------- | --------------- | ------ | --------------------- | ---------------------- | ---------------- |
| -      | Reminder Email        | iOS Email Setup | -      | Data Sync Start       | Key User Migration     | **RFMS Restore** |
|        | ILG Autopilot Removal |                 |        | Verizon/ABM Migration | **7PM: RFMS Shutdown** | AMSYS On-Site    |

### Week 3: January 18-24

| Sun 18            | Mon 19            | Tue 20         | Wed 21 | Thu 22 | Fri 23 | Sat 24 |
| ----------------- | ----------------- | -------------- | ------ | ------ | ------ | ------ |
| System Validation | **GO-LIVE**       | Remote Support | -      | -      | -      | -      |
| Final Checks      | All Sites On-Site | Mobile Devices |        |        |        |        |

---

## Calendar Legend

| Color  | Meaning                            |
| ------ | ---------------------------------- |
| Blue   | Communication & Preparation        |
| Purple | Data Sync Activities               |
| Yellow | Key User Pre-Migration             |
| Red    | Critical - RFMS/Floorsight Cutover |
| Green  | Go-Live                            |

---

## Pre-Migration Week Timeline

### Preparation Phase: January 5-14, 2026

| Date     | Day | Activity                                            | Owner                                  | Notes                                                    |
| -------- | --- | --------------------------------------------------- | -------------------------------------- | -------------------------------------------------------- |
| 01-05-26 | Mon | **Begin user communication**                        | Impact / ILG                           | Joint communication to all applicable users              |
| 01-05-26 | Mon | Identify key users for early migration              | Brian Vaughan / Alisha                 | Consider customer service locations for Saturday         |
| 01-12-26 | Mon | Send migration reminder email                       | Brian Vaughan / Alisha                 | Users: leave computers at workstations with sticky notes |
| 01-12-26 | Mon | ILG removes Windows devices from Autopilot          | ILG (Brent/Jish)                       | Requires serial numbers or computer names                |
| 01-13-26 | Tue | Send iOS email setup instructions                   | Brian Vaughan                          | Ensure users can access email on iPhone/iPad             |
| 01-15-26 | Wed | **Start final email/OneDrive/SharePoint data sync** | Suleman Manji                          | BitTitan MigrationWiz - ensures data consistency         |
| 01-15-26 | Wed | Kick off Verizon device account migration           | Trevor / Bradley (ILG) / Lana (Impact) | Migrate iOS devices from ILG ABM to Impact ABM           |

---

### Key User Pre-Migration: January 16-17, 2026

{: .warning }

> **Key User Migration Weekend:** Friday-Saturday for sales team and remote users. Schedule via Microsoft Bookings.

**Registration Status (as of Jan 5):**

| Metric                  | Count   |
| ----------------------- | ------- |
| Key Users Communicated  | 55      |
| Registered for Timeslot | 48      |
| Registration Rate       | 87%     |
| Timeslot Window         | Fri-Sat |

| Date     | Day | Activity                                         | Owner            | Notes                                                       |
| -------- | --- | ------------------------------------------------ | ---------------- | ----------------------------------------------------------- |
| 01-16-26 | Fri | Begin migrating key user machines in offices     | Viyu / Impact IT | Sales team and remote users schedule via Microsoft Bookings |
| 01-16-26 | Fri | **7:00 PM Pacific - RFMS & Floorsight SHUTDOWN** | Impact IT        | No computer system access Saturday                          |

---

### System Cutover Weekend: January 17-18, 2026

{: .important }

> **Critical Weekend:** RFMS and Floorsight systems migrate during this window while locations are closed.

| Date     | Day | Activity                                             | Owner                 | Notes                                                             |
| -------- | --- | ---------------------------------------------------- | --------------------- | ----------------------------------------------------------------- |
| 01-17-26 | Sat | AMSYS remote hands at key locations (10+ users)      | Colin / AMSYS / Alice | Union City, Chula Vista, Sacramento, Auburn, La Mirada, Milwaukie |
| 01-17-26 | Sat | Restore RFMS database backup into Impact environment | Impact IT             | Start RFMS services after restore                                 |
| 01-17-26 | Sat | Verify Twilio account and services                   | Impact IT             |                                                                   |
| 01-17-26 | Sat | Restore Floorsight; verify DNS settings              | Impact IT             | Test all Floorsight URLs                                          |
| 01-17-26 | Sat | Test printing and IPsec tunnels                      | Impact IT / Viyu      |                                                                   |
| 01-18-26 | Sun | System validation and final checks                   | Impact IT / Viyu      | Verify RFMS/Floorsight operational; final go/no-go decision       |

---

### Go-Live: Monday, January 19, 2026

<div style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; padding: 1rem; border-radius: 8px; margin: 1rem 0;">
<strong>GO-LIVE DAY</strong> - Remote hands on-site at all 27 locations
</div>

| Date     | Day | Activity                                                        | Owner                    | Notes                              |
| -------- | --- | --------------------------------------------------------------- | ------------------------ | ---------------------------------- |
| 01-19-26 | Mon | Remote hands on-site at all 27 locations                        | AMSYS / Viyu / Impact IT | Work with users to migrate devices |
| 01-19-26 | Mon | ILG initiates device wipes; users login with Impact credentials | ILG / Users              | 5-min wait after wipe + reboot     |

---

### Post Go-Live: January 20+, 2026

| Date      | Day  | Activity                          | Owner            | Notes                            |
| --------- | ---- | --------------------------------- | ---------------- | -------------------------------- |
| 01-20-26+ | Tue+ | Remote support for mobile devices | Impact IT / Viyu | Backup → Wipe → Enroll → Restore |

---

### Remote Users Scheduling

{: .note }

> **34 Remote Users** will be contacted to schedule their migration appointments via Microsoft Bookings, similar to the Key User process.

| Metric       | Count                  |
| ------------ | ---------------------- |
| Remote Users | 34                     |
| Pilot Group  | 15                     |
| Not Pilot    | 19                     |
| Scheduling   | Via Microsoft Bookings |

---

## Key Dates Summary

| Date                             | Milestone                                                 |
| -------------------------------- | --------------------------------------------------------- |
| **January 5, 2026**              | Communication begins, identify key users                  |
| **January 12, 2026**             | Reminder email, ILG Autopilot removal                     |
| **January 13, 2026**             | iOS email setup instructions                              |
| **January 15, 2026**             | Data sync start (BitTitan), Verizon/ABM migration         |
| **January 16, 2026**             | Key user migration begins                                 |
| **January 16, 2026 7PM Pacific** | RFMS & Floorsight shutdown                                |
| **January 17, 2026**             | Saturday on-site (6 large sites), RFMS/Floorsight restore |
| **January 18, 2026**             | System validation, final go/no-go checks                  |
| **January 19, 2026**             | **GO-LIVE - All 27 sites**                                |
| **January 20, 2026+**            | Remote mobile device support                              |
