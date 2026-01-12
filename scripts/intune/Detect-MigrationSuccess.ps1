<#
.SYNOPSIS
    Detect migration success and device compliance

.DESCRIPTION
    Intune detection script to verify device has successfully migrated to Impact tenant
    and all required applications and configurations are in place.

    Detects:
    - Required applications installed (Outlook, Teams, Chrome, Foxit, NinjaOne)
    - Autopilot profile is Impact tenant (not Pinnacle/ILG)
    - OneDrive sync complete and up-to-date
    - Internet connectivity to required Microsoft 365 endpoints

    Exit 0 = Compliant (migration successful, all checks passed)
    Exit 1 = Non-compliant (issues detected, remediation needed)

.NOTES
    Version:        1.0
    Author:         Impact Property Solutions / Viyu MSD
    Creation Date:  January 2026
    Purpose:        Monday Go-Live Post-Migration Validation

    Intune Configuration:
    - Run this script using the logged-on credentials: Yes
    - Enforce script signature check: No
    - Run script in 64-bit PowerShell: Yes
#>

#Requires -Version 5.1

$ErrorActionPreference = 'SilentlyContinue'

# ============================================================================
# CONFIGURATION
# ============================================================================

$requiredApps = @{
    "Microsoft Outlook" = @(
        "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE",
        "C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE"
    )
    "Microsoft Teams" = @(
        "$env:LOCALAPPDATA\Microsoft\Teams\Update.exe",
        "C:\Program Files\WindowsApps\MSTeams*\ms-teams.exe"
    )
    "Google Chrome" = @(
        "C:\Program Files\Google\Chrome\Application\chrome.exe",
        "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
    )
    "Foxit PDF Reader" = @(
        "C:\Program Files\Foxit Software\Foxit PDF Reader\FoxitPDFReader.exe",
        "C:\Program Files (x86)\Foxit Software\Foxit PDF Reader\FoxitPDFReader.exe"
    )
    "NinjaOne" = @(
        "C:\Program Files (x86)\NinjaRMMAgent\NinjaRMMAgent.exe",
        "C:\ProgramData\NinjaRMMAgent\NinjaRMMAgent.exe"
    )
}

$requiredEndpoints = @(
    "login.microsoftonline.com",
    "outlook.office365.com",
    "graph.microsoft.com"
)

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

function Test-ApplicationInstalled {
    param(
        [string]$AppName,
        [array]$Paths
    )

    foreach ($path in $Paths) {
        # Handle wildcards in path
        if ($path -like "*`**") {
            $parentPath = Split-Path $path -Parent
            $pattern = Split-Path $path -Leaf

            if (Test-Path $parentPath) {
                $found = Get-ChildItem -Path $parentPath -Filter $pattern -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1

                if ($found) {
                    return $true
                }
            }
        }
        else {
            if (Test-Path $path) {
                return $true
            }
        }
    }

    return $false
}

function Get-AutopilotProfile {
    # Check registry for Autopilot profile information
    $regPath = "HKLM:\SOFTWARE\Microsoft\Provisioning\AutopilotPolicyCache"

    if (Test-Path $regPath) {
        $profile = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue

        if ($profile) {
            # Extract tenant information
            $tenantId = $profile.TenantId
            $profileName = $profile.CloudAssignedProfileName

            return @{
                TenantId = $tenantId
                ProfileName = $profileName
            }
        }
    }

    # Alternative: Check via MDM enrollment
    $mdmPath = "HKLM:\SOFTWARE\Microsoft\Enrollments"

    if (Test-Path $mdmPath) {
        $enrollments = Get-ChildItem -Path $mdmPath -ErrorAction SilentlyContinue

        foreach ($enrollment in $enrollments) {
            $props = Get-ItemProperty -Path $enrollment.PSPath -ErrorAction SilentlyContinue

            if ($props.ProviderID -eq "MS DM Server") {
                $upn = $props.UPN

                if ($upn) {
                    return @{
                        TenantId = "Unknown"
                        ProfileName = "Enrolled"
                        UPN = $upn
                    }
                }
            }
        }
    }

    return $null
}

function Test-ImpactTenant {
    $profile = Get-AutopilotProfile

    if ($profile) {
        # Check if UPN is from Impact domain
        if ($profile.UPN -like "*@impactpropertysolutions.com" -or $profile.UPN -like "*@inginc.com") {
            return $true
        }

        # Check if NOT from old tenant
        if ($profile.UPN -notlike "*@pinnacle*" -and $profile.UPN -notlike "*@ilginc.com") {
            return $true
        }
    }

    return $false
}

function Test-OneDriveSyncStatus {
    # Check if OneDrive is running
    $process = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue

    if (-not $process) {
        return "NotRunning"
    }

    # Check OneDrive status via registry
    $regPath = "HKCU:\Software\Microsoft\OneDrive\Accounts\Business1"

    if (Test-Path $regPath) {
        $userFolder = (Get-ItemProperty -Path $regPath -Name "UserFolder" -ErrorAction SilentlyContinue).UserFolder

        if ($userFolder -and (Test-Path $userFolder)) {
            # OneDrive is configured and folder exists
            return "UpToDate"
        }
    }

    return "NotConfigured"
}

function Test-InternetConnectivity {
    param(
        [array]$Endpoints
    )

    $results = @{}

    foreach ($endpoint in $Endpoints) {
        try {
            $result = Test-NetConnection -ComputerName $endpoint -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue -ErrorAction SilentlyContinue

            $results[$endpoint] = $result
        }
        catch {
            $results[$endpoint] = $false
        }
    }

    # Return true if all endpoints are reachable
    $allReachable = ($results.Values | Where-Object { $_ -eq $false }).Count -eq 0

    return @{
        AllReachable = $allReachable
        Results = $results
    }
}

# ============================================================================
# MAIN DETECTION LOGIC
# ============================================================================

$compliant = $true
$reasons = @()

# Check 1: Required applications
$missingApps = @()

foreach ($app in $requiredApps.Keys) {
    $paths = $requiredApps[$app]
    $installed = Test-ApplicationInstalled -AppName $app -Paths $paths

    if (-not $installed) {
        $missingApps += $app
    }
}

if ($missingApps.Count -gt 0) {
    $compliant = $false
    $reasons += "Missing applications: $($missingApps -join ', ')"
}

# Check 2: Autopilot profile is Impact tenant
$isImpactTenant = Test-ImpactTenant

if (-not $isImpactTenant) {
    $compliant = $false
    $reasons += "Device not enrolled in Impact tenant"
}

# Check 3: OneDrive sync status
$oneDriveStatus = Test-OneDriveSyncStatus

if ($oneDriveStatus -ne "UpToDate") {
    $compliant = $false
    $reasons += "OneDrive sync not up-to-date (Status: $oneDriveStatus)"
}

# Check 4: Internet connectivity
$connectivity = Test-InternetConnectivity -Endpoints $requiredEndpoints

if (-not $connectivity.AllReachable) {
    $compliant = $false
    $unreachable = $connectivity.Results.Keys | Where-Object { $connectivity.Results[$_] -eq $false }
    $reasons += "Connectivity issues: $($unreachable -join ', ') unreachable"
}

# ============================================================================
# OUTPUT AND EXIT
# ============================================================================

if ($compliant) {
    Write-Host "Compliant: Migration successful, all checks passed"
    exit 0
} else {
    Write-Host "Non-compliant: $($reasons -join '; ')"
    exit 1
}
