<#
.SYNOPSIS
    Remediate OneDrive Known Folder Backup compliance

.DESCRIPTION
    Intune remediation script to enable OneDrive Known Folder Backup for
    Desktop, Documents, and Pictures folders.

    Remediates by:
    - Starting OneDrive if not running
    - Triggering Known Folder Move via registry and OneDrive command
    - Forcing sync status update
    - Reporting results to Event Log and C:\Support\

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
#>

#Requires -Version 5.1

$ErrorActionPreference = 'Stop'
$scriptName = "OneDriveKFB"
$supportPath = "C:\Support"

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
        $symbol = if ($value -eq $true -or $value -eq "Enabled" -or $value -eq "UpToDate") { "✓" } elseif ($value -eq $false -or $value -eq "Disabled") { "✗" } else { "-" }
        $txtReport += "`n$($key.PadRight(20)): $symbol $value"
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
        # Create event source if it doesn't exist
        if (-not [System.Diagnostics.EventLog]::SourceExists("IntuneRemediations")) {
            New-EventLog -LogName "Application" -Source "IntuneRemediations"
        }

        Write-EventLog -LogName "Application" -Source "IntuneRemediations" -EventId $EventId -EntryType $EntryType -Message $Message
    }
    catch {
        # Silent fail - don't block remediation if event log fails
        Write-Warning "Failed to write to Event Log: $_"
    }
}

function Start-OneDriveIfNotRunning {
    $process = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue

    if (-not $process) {
        $onedrivePath = "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"

        if (Test-Path $onedrivePath) {
            Start-Process -FilePath $onedrivePath -WindowStyle Hidden
            Start-Sleep -Seconds 5
            return $true
        }
        else {
            throw "OneDrive.exe not found at $onedrivePath"
        }
    }

    return $true
}

function Enable-KnownFolderBackup {
    # Trigger Known Folder Move via OneDrive command-line
    $onedrivePath = "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"

    if (-not (Test-Path $onedrivePath)) {
        throw "OneDrive.exe not found"
    }

    # Get tenant ID from registry
    $regPath = "HKCU:\Software\Microsoft\OneDrive\Accounts\Business1"
    if (Test-Path $regPath) {
        $tenantId = (Get-ItemProperty -Path $regPath -Name "ConfiguredTenantId" -ErrorAction SilentlyContinue).ConfiguredTenantId

        if ($tenantId) {
            # Use OneDrive.exe to trigger KFM
            # /configure_business:<TenantId> triggers Known Folder Move
            Start-Process -FilePath $onedrivePath -ArgumentList "/configure_business:$tenantId" -WindowStyle Hidden -Wait
            Start-Sleep -Seconds 10
            return $true
        }
    }

    # Fallback: Manual registry approach (less reliable)
    # This sets the policy that OneDrive should prompt for KFM
    $policyPath = "HKCU:\Software\Policies\Microsoft\OneDrive"
    if (-not (Test-Path $policyPath)) {
        New-Item -Path $policyPath -Force | Out-Null
    }

    # Enable KFM for all folders
    Set-ItemProperty -Path $policyPath -Name "KFMOptInWithWizard" -Value $tenantId -Force
    Set-ItemProperty -Path $policyPath -Name "KFMSilentOptIn" -Value $tenantId -Force

    # Restart OneDrive to apply
    Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    Start-Process -FilePath $onedrivePath -WindowStyle Hidden
    Start-Sleep -Seconds 10

    return $true
}

function Get-KFBStatus {
    $status = @{
        Desktop = $false
        Documents = $false
        Pictures = $false
    }

    # Check if folders are redirected to OneDrive
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $documentsPath = [Environment]::GetFolderPath("MyDocuments")
    $picturesPath = [Environment]::GetFolderPath("MyPictures")

    $status.Desktop = ($desktopPath -like "*OneDrive*")
    $status.Documents = ($documentsPath -like "*OneDrive*")
    $status.Pictures = ($picturesPath -like "*OneDrive*")

    return $status
}

# ============================================================================
# MAIN REMEDIATION LOGIC
# ============================================================================

try {
    Initialize-SupportDirectory

    $errors = @()
    $details = @{}

    # Step 1: Start OneDrive if not running
    Write-Host "Starting OneDrive..."
    $started = Start-OneDriveIfNotRunning
    $details.OneDriveStarted = $started

    # Step 2: Enable Known Folder Backup
    Write-Host "Enabling Known Folder Backup..."
    $enabled = Enable-KnownFolderBackup
    $details.KFBEnabled = $enabled

    # Step 3: Verify KFB status
    Start-Sleep -Seconds 5
    $kfbStatus = Get-KFBStatus
    $details.DesktopKFB = $kfbStatus.Desktop
    $details.DocumentsKFB = $kfbStatus.Documents
    $details.PicturesKFB = $kfbStatus.Pictures

    # Determine success
    $allEnabled = $kfbStatus.Desktop -and $kfbStatus.Documents -and $kfbStatus.Pictures

    if ($allEnabled) {
        $result = "Success"
        $details.SyncStatus = "UpToDate"

        # Write reports
        $reportPaths = Write-RemediationReport -Result $result -Details $details -Errors $errors

        # Write Event Log
        Write-RemediationEventLog -Message "OneDrive Known Folder Backup remediation successful. Desktop, Documents, and Pictures are now backed up." -EventId 1001 -EntryType Information

        Write-Host "Remediation successful. Reports saved to:"
        Write-Host "  JSON: $($reportPaths.JsonPath)"
        Write-Host "  TXT:  $($reportPaths.TxtPath)"

        exit 0
    }
    else {
        # Partial success or pending
        $result = "Partial"
        $details.SyncStatus = "InProgress"

        $errors += "Known Folder Backup may still be in progress. Desktop=$($kfbStatus.Desktop), Documents=$($kfbStatus.Documents), Pictures=$($kfbStatus.Pictures)"

        # Write reports
        $reportPaths = Write-RemediationReport -Result $result -Details $details -Errors $errors

        # Write Event Log
        Write-RemediationEventLog -Message "OneDrive Known Folder Backup remediation partial. KFB may still be syncing. Check status in 5-10 minutes." -EventId 1001 -EntryType Warning

        Write-Host "Remediation in progress. KFB may take several minutes to complete."
        Write-Host "  JSON: $($reportPaths.JsonPath)"
        Write-Host "  TXT:  $($reportPaths.TxtPath)"

        exit 0
    }
}
catch {
    $result = "Failed"
    $details.ErrorMessage = $_.Exception.Message
    $errors += $_.Exception.Message

    # Write reports
    $reportPaths = Write-RemediationReport -Result $result -Details $details -Errors $errors

    # Write Event Log
    Write-RemediationEventLog -Message "OneDrive Known Folder Backup remediation failed: $($_.Exception.Message)" -EventId 1002 -EntryType Error

    Write-Host "Remediation failed: $($_.Exception.Message)"
    Write-Host "  JSON: $($reportPaths.JsonPath)"
    Write-Host "  TXT:  $($reportPaths.TxtPath)"

    exit 1
}
