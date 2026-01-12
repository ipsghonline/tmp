<#
.SYNOPSIS
    Detect old tenant data requiring cleanup

.DESCRIPTION
    Intune detection script to identify artifacts from the old Pinnacle/ILG tenant
    that should be removed post-migration to Impact tenant.

    Detects:
    - Old OST files (>30 days) from previous tenant
    - Cached credentials for @pinnacle* or @ilginc.com domains
    - Old tenant device registrations in registry

    Exit 0 = Clean (no old tenant data found)
    Exit 1 = Cleanup needed (old tenant artifacts detected)

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

$oldTenantDomains = @(
    "*@pinnacle*",
    "*@ilginc.com",
    "*@ilg*"
)

$ostAgeThresholdDays = 30

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

function Get-OldOSTFiles {
    $outlookPath = "$env:LOCALAPPDATA\Microsoft\Outlook"

    if (-not (Test-Path $outlookPath)) {
        return @()
    }

    $cutoffDate = (Get-Date).AddDays(-$ostAgeThresholdDays)

    # Find OST files older than threshold
    $oldOstFiles = Get-ChildItem -Path $outlookPath -Filter "*.ost" -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt $cutoffDate }

    return $oldOstFiles
}

function Get-OldTenantCredentials {
    $oldCredentials = @()

    try {
        # Use cmdkey to list credentials
        $cmdkeyOutput = & cmdkey /list 2>&1

        if ($LASTEXITCODE -eq 0) {
            $currentTarget = $null

            foreach ($line in $cmdkeyOutput) {
                if ($line -match "Target:\s*(.+)") {
                    $currentTarget = $matches[1].Trim()
                }

                if ($currentTarget) {
                    foreach ($domain in $oldTenantDomains) {
                        if ($currentTarget -like $domain) {
                            $oldCredentials += $currentTarget
                            break
                        }
                    }
                }
            }
        }
    }
    catch {
        # Silent fail - credential check is best effort
    }

    return $oldCredentials | Select-Object -Unique
}

function Get-OldTenantRegistrations {
    $oldRegistrations = @()

    # Check for Azure AD / Entra ID device registrations
    $regPaths = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\AAD\Storage",
        "HKCU:\Software\Microsoft\Workplace Join"
    )

    foreach ($regPath in $regPaths) {
        if (Test-Path $regPath) {
            $items = Get-ChildItem -Path $regPath -Recurse -ErrorAction SilentlyContinue

            foreach ($item in $items) {
                $properties = Get-ItemProperty -Path $item.PSPath -ErrorAction SilentlyContinue

                if ($properties) {
                    foreach ($prop in $properties.PSObject.Properties) {
                        $value = $prop.Value

                        if ($value) {
                            foreach ($domain in $oldTenantDomains) {
                                $domainPattern = $domain -replace '\*', '.*'

                                if ($value -match $domainPattern) {
                                    $oldRegistrations += @{
                                        Path = $item.PSPath
                                        Property = $prop.Name
                                        Value = $value
                                    }
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    return $oldRegistrations
}

function Get-OldOutlookProfiles {
    $oldProfiles = @()

    # Check Outlook profiles for old tenant
    $profilePath = "HKCU:\Software\Microsoft\Office\16.0\Outlook\Profiles"

    if (Test-Path $profilePath) {
        $profiles = Get-ChildItem -Path $profilePath -ErrorAction SilentlyContinue

        foreach ($profile in $profiles) {
            $accounts = Get-ChildItem -Path $profile.PSPath -Recurse -ErrorAction SilentlyContinue |
                Where-Object { $_.PSChildName -like "*Account*" }

            foreach ($account in $accounts) {
                $properties = Get-ItemProperty -Path $account.PSPath -ErrorAction SilentlyContinue

                if ($properties) {
                    $displayName = $properties.'Display Name'
                    $email = $properties.'Email'

                    foreach ($domain in $oldTenantDomains) {
                        if (($displayName -like $domain) -or ($email -like $domain)) {
                            $oldProfiles += @{
                                ProfileName = $profile.PSChildName
                                AccountPath = $account.PSPath
                                Email = $email
                            }
                            break
                        }
                    }
                }
            }
        }
    }

    return $oldProfiles
}

# ============================================================================
# MAIN DETECTION LOGIC
# ============================================================================

$cleanupNeeded = $false
$reasons = @()

# Check 1: Old OST files
$oldOstFiles = Get-OldOSTFiles
if ($oldOstFiles.Count -gt 0) {
    $cleanupNeeded = $true
    $reasons += "$($oldOstFiles.Count) old OST file(s) found (>$ostAgeThresholdDays days old)"
}

# Check 2: Old tenant credentials
$oldCredentials = Get-OldTenantCredentials
if ($oldCredentials.Count -gt 0) {
    $cleanupNeeded = $true
    $reasons += "$($oldCredentials.Count) old tenant credential(s) in Credential Manager"
}

# Check 3: Old device registrations
$oldRegistrations = Get-OldTenantRegistrations
if ($oldRegistrations.Count -gt 0) {
    $cleanupNeeded = $true
    $reasons += "$($oldRegistrations.Count) old tenant device registration(s) in registry"
}

# Check 4: Old Outlook profiles
$oldProfiles = Get-OldOutlookProfiles
if ($oldProfiles.Count -gt 0) {
    $cleanupNeeded = $true
    $reasons += "$($oldProfiles.Count) old tenant Outlook profile(s) found"
}

# ============================================================================
# OUTPUT AND EXIT
# ============================================================================

if ($cleanupNeeded) {
    Write-Host "Cleanup needed: $($reasons -join '; ')"
    exit 1
} else {
    Write-Host "Clean: No old tenant data found"
    exit 0
}
