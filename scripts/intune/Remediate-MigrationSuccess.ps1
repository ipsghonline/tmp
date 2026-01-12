<#
.SYNOPSIS
    Remediate migration success and device compliance issues

.DESCRIPTION
    Intune remediation script to address common post-migration issues.

    Remediates by:
    - Forcing OneDrive sync if stuck or not configured
    - Clearing DNS cache to resolve connectivity issues
    - Restarting network adapters if endpoints unreachable
    - Logging missing applications for IT follow-up (cannot install apps)

    NOTE: This script cannot install missing applications. Application deployment
    must be configured in Intune separately. This script will log missing apps
    for IT team follow-up.

    Exit 0 = Remediation successful or partial success
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
#>

#Requires -Version 5.1

$ErrorActionPreference = 'Stop'
$scriptName = "MigrationSuccess"
$supportPath = "C:\Support"

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
Result:         $(if ($Result -eq 'Success') {'✓ SUCCESS'} elseif ($Result -eq 'Partial') {'⚠ PARTIAL'} else {'✗ FAILED'})

────────────────────────────────────────────────────────────
                        DETAILS
────────────────────────────────────────────────────────────
"@

    foreach ($key in $Details.Keys) {
        $value = $Details[$key]
        if ($value -is [array]) {
            $txtReport += "`n$($key.PadRight(25)):"
            foreach ($item in $value) {
                $txtReport += "`n  • $item"
            }
        }
        else {
            $symbol = if ($value -eq $true -or $value -eq "Fixed" -or $value -eq "UpToDate") { "✓" } elseif ($value -eq $false -or $value -eq "NotFixed") { "✗" } else { "-" }
            $txtReport += "`n$($key.PadRight(25)): $symbol $value"
        }
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

function Test-ApplicationInstalled {
    param(
        [string]$AppName,
        [array]$Paths
    )

    foreach ($path in $Paths) {
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

function Repair-OneDriveSync {
    Write-Host "Attempting to repair OneDrive sync..."

    $onedrivePath = "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"

    if (-not (Test-Path $onedrivePath)) {
        return "OneDriveNotFound"
    }

    # Stop OneDrive
    Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3

    # Start OneDrive
    Start-Process -FilePath $onedrivePath -WindowStyle Hidden
    Start-Sleep -Seconds 10

    # Check status
    $regPath = "HKCU:\Software\Microsoft\OneDrive\Accounts\Business1"

    if (Test-Path $regPath) {
        $userFolder = (Get-ItemProperty -Path $regPath -Name "UserFolder" -ErrorAction SilentlyContinue).UserFolder

        if ($userFolder -and (Test-Path $userFolder)) {
            return "Fixed"
        }
    }

    return "NotFixed"
}

function Repair-NetworkConnectivity {
    Write-Host "Attempting to repair network connectivity..."

    try {
        # Clear DNS cache
        Clear-DnsClientCache -ErrorAction Stop
        Write-Host "  DNS cache cleared"

        # Flush ARP cache
        & arp -d 2>&1 | Out-Null
        Write-Host "  ARP cache flushed"

        # Reset Winsock
        & netsh winsock reset 2>&1 | Out-Null
        Write-Host "  Winsock reset"

        # Renew DHCP lease
        & ipconfig /renew 2>&1 | Out-Null
        Write-Host "  DHCP lease renewed"

        return "Fixed"
    }
    catch {
        return "NotFixed"
    }
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

    $allReachable = ($results.Values | Where-Object { $_ -eq $false }).Count -eq 0

    return @{
        AllReachable = $allReachable
        Results = $results
    }
}

# ============================================================================
# MAIN REMEDIATION LOGIC
# ============================================================================

try {
    Initialize-SupportDirectory

    $errors = @()
    $details = @{}
    $remediationsMade = 0

    Write-Host "Starting migration success remediation..."

    # Step 1: Check for missing applications
    Write-Host "`nChecking for missing applications..."
    $missingApps = @()

    foreach ($app in $requiredApps.Keys) {
        $paths = $requiredApps[$app]
        $installed = Test-ApplicationInstalled -AppName $app -Paths $paths

        if (-not $installed) {
            $missingApps += $app
        }
    }

    if ($missingApps.Count -gt 0) {
        $details.MissingApplications = $missingApps
        $errors += "Missing applications detected: $($missingApps -join ', '). These must be deployed via Intune."
        Write-Host "  ⚠ Missing applications: $($missingApps -join ', ')"
    }
    else {
        $details.MissingApplications = @()
        Write-Host "  ✓ All required applications installed"
    }

    # Step 2: Repair OneDrive sync
    Write-Host "`nChecking OneDrive sync..."
    $oneDriveResult = Repair-OneDriveSync
    $details.OneDriveRepair = $oneDriveResult

    if ($oneDriveResult -eq "Fixed") {
        $remediationsMade++
        Write-Host "  ✓ OneDrive sync repaired"
    }
    elseif ($oneDriveResult -eq "NotFixed") {
        $errors += "OneDrive sync could not be repaired automatically"
        Write-Host "  ✗ OneDrive sync could not be repaired"
    }
    elseif ($oneDriveResult -eq "OneDriveNotFound") {
        $errors += "OneDrive not installed"
        Write-Host "  ✗ OneDrive not installed"
    }

    # Step 3: Test connectivity (before repair)
    Write-Host "`nTesting internet connectivity..."
    $connectivityBefore = Test-InternetConnectivity -Endpoints $requiredEndpoints

    if (-not $connectivityBefore.AllReachable) {
        Write-Host "  ⚠ Connectivity issues detected"

        # Attempt network repair
        $networkResult = Repair-NetworkConnectivity
        $details.NetworkRepair = $networkResult

        if ($networkResult -eq "Fixed") {
            $remediationsMade++

            # Test again
            Start-Sleep -Seconds 5
            $connectivityAfter = Test-InternetConnectivity -Endpoints $requiredEndpoints

            if ($connectivityAfter.AllReachable) {
                Write-Host "  ✓ Network connectivity restored"
                $details.ConnectivityStatus = "Restored"
            }
            else {
                $errors += "Network connectivity still has issues after repair"
                Write-Host "  ✗ Connectivity issues persist"
                $details.ConnectivityStatus = "PartiallyRestored"
            }
        }
        else {
            $errors += "Network connectivity could not be repaired"
            Write-Host "  ✗ Network repair failed"
            $details.ConnectivityStatus = "Failed"
        }
    }
    else {
        Write-Host "  ✓ All endpoints reachable"
        $details.ConnectivityStatus = "OK"
    }

    # Determine result
    $details.RemediationsMade = $remediationsMade

    if ($errors.Count -eq 0) {
        $result = "Success"
        $message = "Migration validation successful. All checks passed."
        $eventType = "Information"
        $eventId = 1001
    }
    elseif ($remediationsMade -gt 0 -or $missingApps.Count -gt 0) {
        $result = "Partial"
        $message = "Migration validation partial. $remediationsMade remediation(s) applied. $($errors.Count) issue(s) require IT follow-up."
        $eventType = "Warning"
        $eventId = 1001
    }
    else {
        $result = "Success"
        $message = "Migration validation complete. No remediations needed."
        $eventType = "Information"
        $eventId = 1001
    }

    # Write reports
    $reportPaths = Write-RemediationReport -Result $result -Details $details -Errors $errors

    # Write Event Log
    Write-RemediationEventLog -Message $message -EventId $eventId -EntryType $eventType

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
    Write-RemediationEventLog -Message "Migration validation failed: $($_.Exception.Message)" -EventId 1002 -EntryType Error

    Write-Host "Remediation failed: $($_.Exception.Message)"
    Write-Host "  JSON: $($reportPaths.JsonPath)"
    Write-Host "  TXT:  $($reportPaths.TxtPath)"

    exit 1
}
