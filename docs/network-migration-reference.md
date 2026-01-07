---
title: Network Migration Technical Reference Guide
nav_order: 1
parent: Technician Documentation
---

# Network Migration Technical Reference Guide

| **Version** | **Date**          | **Status**            |
| ----------- | ----------------- | --------------------- |
| 1.0         | November 23, 2025 | PREREQUISITE FOR M365 |

---

## Overview

This guide provides detailed technical procedures for network infrastructure migration at all Impact Floors on-site deployment locations. The network migration is a **CRITICAL PREREQUISITE** that must be completed before M365 technician deployment begins.

> **Purpose:** Migrate Meraki networking infrastructure from ILG-PS tenant to Impact tenant, establish redundant IPsec tunnels from both data centers, and validate RFMS CB environment access.

---

## Timeline & Schedule

Network migration follows the master M365 deployment schedule with minimum 48-hour stabilization window before M365 technician arrival.

| Phase                          | Timeframe        | Description                                                                                                                                                  |
| ------------------------------ | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Migration Day**              | Day 0            | Execute 14-Step Procedure (4-6 hours). Network team arrives on-site and completes all technical steps. Site contact and network team sign off on completion. |
| **Stabilization & Monitoring** | Day +1 to +2     | IPsec tunnels stabilize, BGP converges, DNS propagates. Network team monitors for issues. M365 admin performs readiness verification.                        |
| **Pre-Deployment Approval**    | Day +2 (Evening) | M365 admin confirms network migration completion, validates RFMS CB access, authorizes technician deployment.                                                |
| **M365 Deployment Ready**      | Day +3           | M365 technicians arrive on-site. Network infrastructure validated, RFMS access confirmed, deployment can proceed.                                            |

---

## Roles & Responsibilities

### Network Team Lead

- Execute all 14 technical procedure steps
- Validate RFMS CB environment access from RFMS gateway
- Obtain site contact signature on completion form
- Report any deviations or issues to M365 team
- Document configuration details (tunnel IPs, device serials)

### Network Support Technician

- Assist Network Lead with device configuration
- Monitor Meraki dashboard during migration
- Perform initial connectivity testing (ping, tracert)
- Participate in IPsec tunnel validation
- Verify alarm and camera system connectivity

### M365 Admin (Readiness Verification)

- Receive sign-off from Network Lead
- Wait minimum 48 hours for stabilization (Day +2 evening)
- Test M365 connectivity from site location
- Validate RFMS CB access: `I00774GW02.IMPACTFLOORS.LOCAL`
- Confirm no DNS resolution issues
- Authorize M365 technician deployment

### Site Contact (On-site)

- Provide network team physical access to equipment
- Facilitate user testing (RFMS access verification)
- Observe all configuration steps
- Sign completion form confirming all steps executed
- Report any issues to Network Lead immediately

### M365 Field Technician

- Verify network migration completed before arrival (from M365 admin)
- Test RFMS CB access: `I00774GW02.IMPACTFLOORS.LOCAL` on arrival (part of pre-deployment checklist)
- Proceed with M365 user enrollment after network verification

---

## Pre-Migration Checklist

**Network Team:** Complete these items BEFORE arriving on-site

- [ ] Confirm Meraki licenses available in Impact tenant (quantity = # of devices)
- [ ] Verify IPsec tunnel configurations loaded in both ILG DC and Impact DC
- [ ] Test VPN connectivity from office to both data centers
- [ ] Download latest Meraki firmware for device model
- [ ] Print this procedure guide + site contact info
- [ ] Prepare device serial numbers and MAC addresses
- [ ] Test Meraki dashboard access (login credentials ready)

---

## 14-Step Technical Procedure

> **CRITICAL DEPENDENCY:** These steps must execute sequentially. Do not skip steps or perform out of order. Each step validates the previous step.

### Step 1: Confirm Remote Access & Connectivity

Confirm remote access to Meraki dashboard. Verify network connectivity and equipment visibility. Coordinate with on-site technicians as needed for physical access or equipment verification. Verify site contact availability for testing phases.

### Step 2: Unclaim Devices from ILG Tenant

Log into Meraki dashboard for ILG-PS tenant. Navigate to Inventory > Devices. Select all site devices. Action: "Unclaim". Document device serial numbers during unclaim process. Confirm devices now show as "Unclaimed" in dashboard.

### Step 3: Claim Devices in Impact Tenant

Log into Meraki dashboard for Impact tenant (use provided credentials). Navigate to Inventory. Add devices by serial number. Confirm claim succeeds for ALL devices. Verify devices appear in Impact tenant inventory (may take 2-3 minutes).

### Step 4: Assign Licenses to Devices

For each claimed device, navigate to Device Settings > License. Assign appropriate license tier (match previous ILG licensing or per M365 team specification). Confirm license assignment succeeds. Devices should show "Licensed" status in dashboard.

### Step 5: Verify WAN Settings

Navigate to Switching > Network Settings > WAN. Confirm WAN configuration matches site specifications (primary ISP, backup provider if applicable). Verify IP addressing, gateway, DNS servers. Check for any configuration warnings or errors in dashboard.

### Step 6: Verify LAN Settings

Navigate to Switching > VLANs and Routing. Confirm site VLANs exist (typical: User Network, Print Server Network, Management). Verify VLAN routing and inter-VLAN connectivity. Confirm IP ranges match site specifications. No configuration errors should appear.

### Step 7: Test Prisma VPN Connect (if applicable)

If site uses Prisma VPN for remote access, navigate to Security > VPN. Confirm VPN tunnel status shows "Connected" or "Active". If status is "Down", troubleshoot: verify VPN pre-shared key, firewall rules, remote gateway accessibility. Document any issues.

### Step 8: Test Access to RFMS

Ask site contact to test RFMS access from end user workstation. URL: `I00774GW02.IMPACTFLOORS.LOCAL` (from impact.impactfloors.com RDS or direct connection). User should see RFMS login prompt. Confirm network connectivity allows RFMS application to load. Document any access issues.

### Step 9: Test Printing from Local Device

Ask site contact to print test page from local workstation to site printer. Verify print job completes successfully. Confirm printer is accessible and responsive. Test from at least one workstation per printer (if multiple printers exist). Document any print failures.

### Step 10: Set Up IPsec Tunnel: ILG DC to Local Site

Using provided IPsec configuration file for ILG DC, create tunnel endpoint at this site. Configure: local gateway IP, remote gateway IP (ILG DC), pre-shared key, encryption algorithm (AES-256), authentication (SHA-256), lifetime settings. Initiate tunnel and confirm status shows "Established" or "Connected". May take 1-2 minutes to converge.

### Step 11: Set Up IPsec Tunnel: Impact DC to Local Site

Using provided IPsec configuration file for Impact DC, create second tunnel endpoint at this site. Configure: local gateway IP, remote gateway IP (Impact DC), pre-shared key, encryption algorithm (AES-256), authentication (SHA-256), lifetime settings. Initiate tunnel and confirm status shows "Established" or "Connected". BOTH tunnels should now show as active.

### Step 12: Test Printing from RFMS

Ask site contact to test printing from RFMS CB environment: log in via `I00774GW02.IMPACTFLOORS.LOCAL`, navigate to Print function, send test print job to local site printer. Verify print job completes successfully from RFMS. This validates end-to-end connectivity through both IPsec tunnels.

### Step 13: Verify Burglar Alarm Connection (if applicable)

If site has alarm system connected to network monitoring: test alarm panel network connectivity. Confirm heartbeat signal to monitoring center. Ask site contact to confirm alarm system status in their management console. Document alarm system status: Connected/Operational.

### Step 14: Verify Camera System Connection (if applicable)

If site has IP cameras or NVR: test camera network connectivity. Confirm cameras respond to ping. If remote viewing available, test access to camera feed from impact.impactfloors.com portal. Verify all cameras show "Online" status. Document camera system status: All Online.

---

## Success Criteria

Network migration is **COMPLETE** and **APPROVED FOR M365 DEPLOYMENT** when ALL of the following are confirmed:

- [ ] All devices claimed and licensed in Impact tenant
- [ ] WAN and LAN configurations verified with no errors
- [ ] RFMS CB access: `I00774GW02.IMPACTFLOORS.LOCAL` working from site
- [ ] Local device printing functional
- [ ] Both IPsec tunnels (ILG DC and Impact DC) established and stable
- [ ] RFMS CB printing functional (through IPsec tunnels)
- [ ] Burglar alarm connected (if applicable)
- [ ] Camera system online (if applicable)
- [ ] Network Lead and Site Contact sign-off obtained
- [ ] M365 Admin readiness verification completed (>=48 hours post-migration)

---

## Sign-Off Form

To be completed by Network Lead and Site Contact on-site, immediately after Step 14 completion.

| Item                            | Status        | Notes                                           |
| ------------------------------- | ------------- | ----------------------------------------------- |
| All 14 technical steps executed | [ ] Complete  | _Record any skipped steps or deviations_        |
| RFMS access verified            | [ ] Confirmed | _User tested: ******\_\_\_\_******_             |
| Both IPsec tunnels established  | [ ] Confirmed | _Tunnel status verified in Meraki dashboard_    |
| No critical issues encountered  | [ ] Confirmed | _Issues resolved on-site: ******\_\_\_\_******_ |

**Network Lead Name:** ******\_\_\_\_****** **Signature:** ******\_\_\_\_****** **Date/Time:** ******\_\_\_\_******

**Site Contact Name:** ******\_\_\_\_****** **Signature:** ******\_\_\_\_****** **Date/Time:** ******\_\_\_\_******

---

## Troubleshooting Guide

### Device Claim Failures

> **Problem:** "Device cannot be claimed" or "License exhausted" error
>
> **Solution:**
>
> - Verify license count in Impact tenant (Inventory > Licenses)
> - If exhausted: check if older devices can be removed from inventory
> - Confirm device is unclaimed from ILG tenant (may take 5-10 minutes to propagate)
> - Try claiming again with exact serial number (no spaces, correct case)

### IPsec Tunnel Not Establishing

> **Problem:** IPsec tunnel shows "Down" or "Not Connected"
>
> **Solution:**
>
> - Verify pre-shared key matches exactly on both ends (case-sensitive)
> - Confirm both ILG DC and Impact DC gateways are reachable (ping test from Meraki device)
> - Check firewall rules allow UDP 500 and UDP 4500 (IKE, IPsec)
> - Verify local and remote subnet configurations are correct
> - Wait 2-3 minutes after configuration, then reboot Meraki device
> - Contact Network Operations team if tunnels still fail to establish

### RFMS Access Not Working

> **Problem:** Cannot access `I00774GW02.IMPACTFLOORS.LOCAL` from site
>
> **Solution:**
>
> - Test basic connectivity: `ping I00774GW02.IMPACTFLOORS.LOCAL`
> - Verify DNS resolution: `nslookup I00774GW02.IMPACTFLOORS.LOCAL`
> - Confirm at least one IPsec tunnel is established (if RFMS behind tunnel)
> - Check firewall rules allow port 443 (HTTPS) to RFMS gateway
> - Clear browser cache and try again
> - Try from different workstation to confirm not a single-device issue

### Printing Not Working from Site

> **Problem:** Print jobs fail or printer offline
>
> **Solution:**
>
> - Verify printer has network connectivity (ping printer IP)
> - Confirm printer is on same VLAN as user workstations
> - Check printer web interface for errors (navigate to printer IP address)
> - Restart printer (power cycle 30 seconds)
> - If using print queue: clear print jobs on workstation (Settings > Devices > Printers)
> - Re-add printer if necessary

### Printing Not Working from RFMS

> **Problem:** Print jobs from RFMS fail or printer appears offline
>
> **Solution:**
>
> - Verify BOTH IPsec tunnels are established (may be redundant paths)
> - Test basic connectivity through RFMS network: `ping printer-ip-from-rfms`
> - Confirm print server has routes to local site through IPsec tunnels
> - Check firewall rules on RFMS print server allow traffic to site printer
> - Verify printer queue on RFMS server shows site printer (may need to re-add)
> - Contact print infrastructure team if issue persists

---

## Escalation & Support

| Issue Category                    | Contact                                | Priority |
| --------------------------------- | -------------------------------------- | -------- |
| Meraki dashboard/licensing issues | Meraki Support + Network Ops Team      | CRITICAL |
| IPsec tunnel failures             | Network Operations + Data Center Teams | CRITICAL |
| RFMS connectivity issues          | RFMS Infrastructure Team               | HIGH     |
| Printer configuration issues      | Print Infrastructure Team              | HIGH     |
| Site-specific network issues      | Local IT support + Network Ops         | MEDIUM   |

> **WARNING:** If any CRITICAL issue cannot be resolved on-site: Network Lead must notify M365 team immediately. Do NOT sign off. M365 deployment will be postponed until network is fully operational.

---

## Configuration Reference

Keep this information available during migration:

| Configuration Item             | Value                                                            |
| ------------------------------ | ---------------------------------------------------------------- |
| RFMS CB Gateway                | `I00774GW02.IMPACTFLOORS.LOCAL`                                  |
| RFMS CB IronOrbit Gateway      | `ironorbit.impactfloors.com`                                     |
| Impact Meraki Tenant Admin URL | `dashboard.meraki.com`                                           |
| IPsec Configuration Files      | Provided by Network Ops (site-specific)                          |
| Device Firmware                | Download from Meraki dashboard (latest stable release)           |
| Meraki API Key                 | Provided by Network Ops (if scripted deployment used)            |
| DNS Servers                    | Match site-specific configuration (typically Impact DNS servers) |

---

_Network Migration Technical Reference Guide v1.0 | November 23, 2025_

_For questions or updates: Network Operations Team_
