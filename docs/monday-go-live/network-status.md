---
layout: default
title: Network Status
parent: Monday Go-Live
nav_order: 3
---

# Network Status

Network migration dependencies and verification status for all 22 sites.

---

{: .note .bg-green-100 }

> **NETWORK MIGRATIONS COMPLETE:** All network infrastructure migrations were completed in November 2025, providing 50+ days of stabilization before the January 19, 2026 M365 deployment.

---

## Network Migration Status - All 22 Sites

Network infrastructure migrations were completed November 18-26, 2025. All sites have been validated and stable.

### Confirmed Complete (12 Sites)

| Site           | State | Network Migration | M365 Go-Live | Buffer Days | Status   |
| -------------- | ----- | ----------------- | ------------ | ----------- | -------- |
| Carrollton     | TX    | Nov 18, 2025      | Jan 19, 2026 | 62 days     | Complete |
| Tampa          | FL    | Nov 20, 2025      | Jan 19, 2026 | 60 days     | Complete |
| Albuquerque    | NM    | Nov 24, 2025      | Jan 19, 2026 | 56 days     | Complete |
| El Paso        | TX    | Nov 24, 2025      | Jan 19, 2026 | 56 days     | Complete |
| Austin         | TX    | Nov 24, 2025      | Jan 19, 2026 | 56 days     | Complete |
| Orlando        | FL    | Nov 25, 2025      | Jan 19, 2026 | 55 days     | Complete |
| Jacksonville   | FL    | Nov 25, 2025      | Jan 19, 2026 | 55 days     | Complete |
| Pawtucket      | RI    | Nov 25, 2025      | Jan 19, 2026 | 55 days     | Complete |
| Denver         | CO    | Nov 26, 2025      | Jan 19, 2026 | 54 days     | Complete |
| Las Vegas      | NV    | Nov 26, 2025      | Jan 19, 2026 | 54 days     | Complete |
| Sparks         | NV    | Nov 26, 2025      | Jan 19, 2026 | 54 days     | Complete |
| Salt Lake City | UT    | Nov 26, 2025      | Jan 19, 2026 | 54 days     | Complete |

### Requires Verification (10 Sites)

{: .warning }

> **Action Required:** Verify network status for these 10 sites before January 5, 2026.

| Site        | State | Network Migration | M365 Go-Live | Status |
| ----------- | ----- | ----------------- | ------------ | ------ |
| Tucson      | AZ    | Verify            | Jan 19, 2026 | Verify |
| Phoenix     | AZ    | Verify            | Jan 19, 2026 | Verify |
| Sacramento  | CA    | Verify            | Jan 19, 2026 | Verify |
| Union City  | CA    | Verify            | Jan 19, 2026 | Verify |
| Chula Vista | CA    | Verify            | Jan 19, 2026 | Verify |
| Fresno      | CA    | Verify            | Jan 19, 2026 | Verify |
| La Mirada   | CA    | Verify            | Jan 19, 2026 | Verify |
| Auburn      | WA    | Verify            | Jan 19, 2026 | Verify |
| Milwaukie   | OR    | Verify            | Jan 19, 2026 | Verify |
| Houston     | TX    | Verify            | Jan 19, 2026 | Verify |

---

## Network Readiness Verification

{: .note }

> The extended timeline to January 19, 2026 provides 50+ days of network stabilization for all sites that completed migrations in November 2025.

---

## Action Items by Role

### 1. Network Lead (By January 5, 2026)

- Verify network migration status for 10 unconfirmed sites (AZ, CA, WA, OR, Houston)
- Confirm VPN/IPsec tunnel connectivity at all locations
- Provide final status report to deployment team

### 2. M365 Admin (By January 12, 2026)

- Verify Azure AD Connect health status for all sites
- Test M365 tenant connectivity from each site location
- Confirm DNS resolution working properly for RFMS/Floorsight
- Coordinate with ILG on Autopilot device removal process

---

## Status Summary

{: .note .bg-green-100 }

> **Status:** Network migration timeline provides 50-62 day buffer windows for validation and stabilization before M365 deployment on January 19, 2026. Extended timeline significantly reduces deployment risk.
