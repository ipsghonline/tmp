---
layout: default
title: Glossary
nav_order: 6
---

# Glossary

Technical terms and acronyms used throughout the Impact Floors migration documentation.

---

## A

### ABM (Apple Business Manager)

Apple's portal for managing iOS/iPadOS devices in enterprise environments. Used to enroll company iPhones and iPads into mobile device management.

### Autopilot

See [Windows Autopilot](#windows-autopilot).

### Azure AD (Azure Active Directory)

Microsoft's cloud-based identity and access management service. Now known as Microsoft Entra ID. Handles user authentication and authorization for Microsoft 365 and other cloud services.

---

## C

### CNAME Record

A type of DNS record that maps an alias name to a true (canonical) domain name. Used in network configuration during migration.

### Conditional Access

Security policies in Azure AD that control access to applications based on conditions like device compliance, location, or risk level.

---

## D

### Device Wipe

The process of erasing all data and settings from a device, returning it to factory state. During migration, Intune initiates a wipe to prepare the device for re-enrollment.

### DNS (Domain Name System)

The system that translates human-readable domain names (like email.impactfloors.com) into IP addresses. DNS changes are part of the network migration process.

---

## E

### Enrollment Status Page (ESP)

A Windows screen displayed during Autopilot enrollment that shows the progress of device setup, app installation, and policy application. Users cannot proceed until ESP completes.

### Entra ID

Microsoft's rebranded name for Azure Active Directory. The cloud identity platform used for user authentication.

---

## F

### FloorSight

Impact Floors' proprietary business application for flooring project management and operations.

---

## I

### ILG (Impact Legacy Group)

The previous IT environment before migration to the new Impact environment.

### Intune

Microsoft's cloud-based mobile device management (MDM) and mobile application management (MAM) service. Part of Microsoft Endpoint Manager.

---

## M

### MDM (Mobile Device Management)

Technology for managing and securing mobile devices (phones, tablets, laptops) in an organization. Microsoft Intune is an MDM solution.

### MFA (Multi-Factor Authentication)

Security method requiring two or more verification factors to access an account. Typically combines password + phone verification or authenticator app.

---

## O

### OOBE (Out of Box Experience)

The initial setup process when a Windows device is first turned on or after a factory reset. During migration, devices go through OOBE to be configured for the new environment.

### OneDrive

Microsoft's cloud storage service for personal and business files. Files sync between devices and the cloud.

---

## R

### RFMS (Regional Floor Management System)

Impact Floors' system for managing regional flooring operations, scheduling, and business processes.

---

## S

### SAS Token

Shared Access Signature - a secure way to grant limited access to Azure storage resources without exposing account keys.

### SSO (Single Sign-On)

Authentication method allowing users to access multiple applications with one set of credentials.

---

## T

### Tenant

In Microsoft 365/Azure, a tenant is a dedicated instance of Azure AD that an organization receives when signing up for a Microsoft cloud service. The migration moves users from the ILG tenant to the Impact tenant.

---

## V

### VPN (Virtual Private Network)

Secure connection that extends a private network across a public network. May be required for accessing certain Impact resources.

---

## W

### Windows Autopilot

Microsoft's cloud-based deployment technology that enables IT administrators to pre-configure new devices so users can set them up with minimal interaction. Used during migration to automatically configure devices for the Impact environment.

---

## Need a Term Added?

If you encounter a technical term not listed here, contact IT support and we'll add it to the glossary.
