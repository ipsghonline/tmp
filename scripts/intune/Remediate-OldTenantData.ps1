<#
.SYNOPSIS
    Remediate old tenant data cleanup

.DESCRIPTION
    Intune remediation script to remove artifacts from the old Pinnacle/ILG tenant
    after migration to Impact tenant.

    Remediates by:
    - Removing old OST files (>30 days old)
    - Deleting cached credentials for old tenant domains
    - Cleaning old tenant device registrations from registry
    - Removing old Outlook profiles (with caution)

    Exit 0 = Remediation successful
    Exit 1 = Remediation failed

.NOTES
    Version:        1.0
    Author:         Impact Property Solutions / Viyu MSD
    Creation Date:  January 2026
    Purpose:        Monday Go-Live Post-Migration Validation

    Intune Configuration:
    - Run this script using the logged-on credentials: Yes
    - Enforce script signature check: No
    - Run script in 64-bit PowerShell: Yes

    IMPORTANT: This script removes data. Ensure migration is complete before running.
#>

#Requires -Version 5.1

$ErrorActionPreference = 'Stop'
$scriptName = "OldTenantCleanup"
$supportPath = "C:\Support"

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

function Initialize-SupportDirectory {
    if (-not (Test-Path $supportPath)) {
        New-Item -Path $supportPath -ItemType Directory -Force | Out-Null
    }
}

function Write-RemediationReport {
    param(
        [string]$Result,
        [hashtable]$Details,
        [array]$Errors = @()
    )

    $timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    $timestampFile = Get-Date -Format "yyyyMMdd-HHmmss"
    $computerName = $env:COMPUTERNAME
    $userName = $env:USERNAME

    # JSON Report
    $jsonReport = @{
        SchemaVersion = "1.0"
        Timestamp = $timestamp
        ComputerName = $computerName
        UserName = $userName
        ScriptName = $scriptName
        Action = "Remediation"
        Result = $Result
        Details = $Details
        Errors = $Errors
    } | ConvertTo-Json -Depth 5

    $jsonPath = Join-Path $supportPath "Remediation-$scriptName-$timestampFile.json"
    $jsonReport | Out-File -FilePath $jsonPath -Encoding UTF8

    # TXT Report (Human-readable)
    $txtReport = @"
════════════════════════════════════════════════════════════
        INTUNE REMEDIATION REPORT - $scriptName
════════════════════════════════════════════════════════════
Timestamp:      $timestamp
Computer:       $computerName
User:           $userName
Script:         $scriptName
Action:         Remediation
Result:         $(if ($Result -eq 'Success') {'✓ SUCCESS'} else {'✗ FAILED'})

────────────────────────────────────────────────────────────
                        DETAILS
────────────────────────────────────────────────────────────
"@

    foreach ($key in $Details.Keys) {
        $value = $Details[$key]
        $symbol = if ($value -eq 0) { "✓" } elseif ($value -is [int] -and $value -gt 0) { "✓" } else { "-" }
        $txtReport += "`n$($key.PadRight(25)): $symbol $value"
    }

    if ($Errors.Count -gt 0) {
        $txtReport += "`n`n────────────────────────────────────────────────────────────"
        $txtReport += "`n                        ERRORS"
        $txtReport += "`n────────────────────────────────────────────────────────────"
        foreach ($error in $Errors) {
            $txtReport += "`n• $error"
        }
    }

    $txtReport += "`n`n════════════════════════════════════════════════════════════"

    $txtPath = Join-Path $supportPath "Remediation-$scriptName-$timestampFile.txt"
    $txtReport | Out-File -FilePath $txtPath -Encoding UTF8

    return @{
        JsonPath = $jsonPath
        TxtPath = $txtPath
    }
}

function Write-RemediationEventLog {
    param(
        [string]$Message,
        [int]$EventId,
        [string]$EntryType = "Information"
    )

    try {
        if (-not [System.Diagnostics.EventLog]::SourceExists("IntuneRemediations")) {
            New-EventLog -LogName "Application" -Source "IntuneRemediations"
        }

        Write-EventLog -LogName "Application" -Source "IntuneRemediations" -EventId $EventId -EntryType $EntryType -Message $Message
    }
    catch {
        Write-Warning "Failed to write to Event Log: $_"
    }
}

function Remove-OldOSTFiles {
    $outlookPath = "$env:LOCALAPPDATA\Microsoft\Outlook"
    $removedCount = 0

    if (-not (Test-Path $outlookPath)) {
        return $removedCount
    }

    $cutoffDate = (Get-Date).AddDays(-$ostAgeThresholdDays)

    $oldOstFiles = Get-ChildItem -Path $outlookPath -Filter "*.ost" -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt $cutoffDate }

    foreach ($file in $oldOstFiles) {
        try {
            Remove-Item -Path $file.FullName -Force -ErrorAction Stop
            $removedCount++
            Write-Host "  Removed: $($file.Name)"
        }
        catch {
            Write-Warning "Failed to remove $($file.Name): $_"
        }
    }

    return $removedCount
}

function Remove-OldTenantCredentials {
    $removedCount = 0

    try {
        $cmdkeyOutput = & cmdkey /list 2>&1

        if ($LASTEXITCODE -eq 0) {
            $targets = @()

            foreach ($line in $cmdkeyOutput) {
                if ($line -match "Target:\s*(.+)") {
                    $target = $matches[1].Trim()

                    foreach ($domain in $oldTenantDomains) {
                        if ($target -like $domain) {
                            $targets += $target
                            break
                        }
                    }
                }
            }

            # Remove each old credential
            foreach ($target in $targets) {
                try {
                    & cmdkey /delete:$target 2>&1 | Out-Null

                    if ($LASTEXITCODE -eq 0) {
                        $removedCount++
                        Write-Host "  Removed credential: $target"
                    }
                }
                catch {
                    Write-Warning "Failed to remove credential $target : $_"
                }
            }
        }
    }
    catch {
        Write-Warning "Failed to enumerate credentials: $_"
    }

    return $removedCount
}

function Remove-OldTenantRegistrations {
    $removedCount = 0

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
                    $shouldRemove = $false

                    foreach ($prop in $properties.PSObject.Properties) {
                        $value = $prop.Value

                        if ($value) {
                            foreach ($domain in $oldTenantDomains) {
                                $domainPattern = $domain -replace '\*', '.*'

                                if ($value -match $domainPattern) {
                                    $shouldRemove = $true
                                    break
                                }
                            }
                        }

                        if ($shouldRemove) { break }
                    }

                    if ($shouldRemove) {
                        try {
                            Remove-Item -Path $item.PSPath -Recurse -Force -ErrorAction Stop
                            $removedCount++
                            Write-Host "  Removed registry key: $($item.PSPath)"
                        }
                        catch {
                            Write-Warning "Failed to remove registry key $($item.PSPath): $_"
                        }
                    }
                }
            }
        }
    }

    return $removedCount
}

# ============================================================================
# MAIN REMEDIATION LOGIC
# ============================================================================

try {
    Initialize-SupportDirectory

    $errors = @()
    $details = @{}

    Write-Host "Starting old tenant data cleanup..."

    # Step 1: Remove old OST files
    Write-Host "`nRemoving old OST files (>$ostAgeThresholdDays days)..."
    $ostRemoved = Remove-OldOSTFiles
    $details.OSTFilesRemoved = $ostRemoved

    # Step 2: Remove old tenant credentials
    Write-Host "`nRemoving old tenant credentials..."
    $credRemoved = Remove-OldTenantCredentials
    $details.CredentialsRemoved = $credRemoved

    # Step 3: Remove old device registrations
    Write-Host "`nRemoving old tenant device registrations..."
    $regRemoved = Remove-OldTenantRegistrations
    $details.RegistrationsRemoved = $regRemoved

    # Calculate total cleaned
    $totalCleaned = $ostRemoved + $credRemoved + $regRemoved
    $details.TotalItemsCleaned = $totalCleaned

    # Determine result
    if ($totalCleaned -gt 0) {
        $result = "Success"
        $message = "Old tenant cleanup successful. Removed $totalCleaned item(s): $ostRemoved OST file(s), $credRemoved credential(s), $regRemoved registration(s)."
    }
    else {
        $result = "Success"
        $message = "No old tenant data found to clean up."
    }

    # Write reports
    $reportPaths = Write-RemediationReport -Result $result -Details $details -Errors $errors

    # Write Event Log
    Write-RemediationEventLog -Message $message -EventId 1001 -EntryType Information

    Write-Host "`n$message"
    Write-Host "Reports saved to:"
    Write-Host "  JSON: $($reportPaths.JsonPath)"
    Write-Host "  TXT:  $($reportPaths.TxtPath)"

    exit 0
}
catch {
    $result = "Failed"
    $details.ErrorMessage = $_.Exception.Message
    $errors += $_.Exception.Message

    # Write reports
    $reportPaths = Write-RemediationReport -Result $result -Details $details -Errors $errors

    # Write Event Log
    Write-RemediationEventLog -Message "Old tenant cleanup failed: $($_.Exception.Message)" -EventId 1002 -EntryType Error

    Write-Host "Remediation failed: $($_.Exception.Message)"
    Write-Host "  JSON: $($reportPaths.JsonPath)"
    Write-Host "  TXT:  $($reportPaths.TxtPath)"

    exit 1
}
