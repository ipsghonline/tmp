<#
.SYNOPSIS
    Impact Property Solutions - Phase 1 Backup Script
    Automates pre-migration backup tasks for Monday Go-Live (January 19, 2026)

.DESCRIPTION
    This script performs the following Phase 1 backup tasks:
    - Collects system information (computer name, serial, user)
    - Verifies OneDrive status and Known Folder Backup
    - Exports printer configuration
    - Captures WiFi SSID for OOBE reconnection
    - Finds and copies PST files to OneDrive
    - Opens browser bookmark export pages
    - Generates a comprehensive backup report

.PARAMETER SkipPSTCopy
    Skip the automatic PST file copy to OneDrive

.PARAMETER Quiet
    Suppress interactive prompts (auto-confirm PST copy)

.EXAMPLE
    .\Phase1-Backup.ps1
    Runs the full backup script with interactive prompts

.EXAMPLE
    .\Phase1-Backup.ps1 -SkipPSTCopy
    Runs the script but skips PST file copying

.EXAMPLE
    irm https://ipsghonline.github.io/tmp/scripts/Phase1-Backup.ps1 | iex
    Downloads and runs the script directly from the web

.NOTES
    Version:        1.0
    Author:         Impact Property Solutions / Viyu MSD
    Creation Date:  January 2026
    Purpose:        Monday Go-Live Migration Support
#>

#Requires -Version 5.1

[CmdletBinding()]
param(
    [switch]$SkipPSTCopy,
    [switch]$Quiet
)

# ============================================================================
# CONFIGURATION
# ============================================================================

$script:Version = "1.0"
$script:ReportFileName = "Phase1-Backup-Report.txt"
$script:PrinterFileName = "PrinterBackup.txt"
$script:Results = @{
    SystemInfo = $null
    OneDrive = $null
    WiFi = $null
    Printers = @()
    PSTFiles = @()
    OSTFiles = @()
    Browsers = @()
    Errors = @()
}

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

function Write-Banner {
    $banner = @"

    ╔══════════════════════════════════════════════════════════════╗
    ║     IMPACT PROPERTY SOLUTIONS - PHASE 1 BACKUP SCRIPT        ║
    ║                    Monday Go-Live Migration                   ║
    ║                         Version $script:Version                          ║
    ╚══════════════════════════════════════════════════════════════╝

"@
    Write-Host $banner -ForegroundColor Cyan
}

function Write-Section {
    param([string]$Title)
    Write-Host "`n[INFO] $Title" -ForegroundColor Yellow
}

function Write-Success {
    param([string]$Message)
    Write-Host "  ✓ $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "  ⚠ $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "  ✗ $Message" -ForegroundColor Red
    $script:Results.Errors += $Message
}

function Write-Info {
    param([string]$Message)
    Write-Host "  $Message" -ForegroundColor White
}

function Write-Action {
    param([string]$Message)
    Write-Host "`n[ACTION] $Message" -ForegroundColor Magenta
}

function Write-Prompt {
    param([string]$Message)
    Write-Host "`n[PROMPT] " -ForegroundColor Cyan -NoNewline
    Write-Host $Message -NoNewline
}

function Get-OneDriveDocumentsPath {
    # Try to find OneDrive Documents folder
    $possiblePaths = @(
        "$env:OneDrive\Documents",
        "$env:OneDriveCommercial\Documents",
        "$env:OneDriveConsumer\Documents",
        "$env:USERPROFILE\OneDrive\Documents",
        "$env:USERPROFILE\OneDrive - *\Documents"
    )

    foreach ($path in $possiblePaths) {
        $resolved = Resolve-Path -Path $path -ErrorAction SilentlyContinue
        if ($resolved -and (Test-Path $resolved)) {
            return $resolved.Path
        }
    }

    # Fallback to regular Documents
    return [Environment]::GetFolderPath('MyDocuments')
}

# ============================================================================
# MAIN FUNCTIONS
# ============================================================================

function Get-SystemInfo {
    Write-Section "Collecting system information..."

    try {
        $computerInfo = Get-CimInstance -ClassName Win32_ComputerSystem
        $biosInfo = Get-CimInstance -ClassName Win32_BIOS
        $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem

        $info = @{
            ComputerName = $env:COMPUTERNAME
            SerialNumber = $biosInfo.SerialNumber
            CurrentUser = $env:USERNAME
            UserPrincipal = whoami /upn 2>$null
            WindowsVersion = "$($osInfo.Caption) ($($osInfo.Version))"
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }

        Write-Info "Computer Name: $($info.ComputerName)"
        Write-Info "Serial Number: $($info.SerialNumber)"
        Write-Info "Current User: $($info.CurrentUser)"
        if ($info.UserPrincipal) {
            Write-Info "UPN: $($info.UserPrincipal)"
        }
        Write-Info "Windows: $($info.WindowsVersion)"

        $script:Results.SystemInfo = $info
        return $info
    }
    catch {
        Write-Error "Failed to collect system info: $_"
        return $null
    }
}

function Get-OneDriveStatus {
    Write-Section "Checking OneDrive status..."

    $status = @{
        Installed = $false
        Running = $false
        SignedIn = $false
        Account = $null
        KnownFolderBackup = $false
        SyncStatus = "Unknown"
    }

    try {
        # Check if OneDrive is installed
        $oneDrivePath = "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"
        $status.Installed = Test-Path $oneDrivePath

        if ($status.Installed) {
            Write-Success "OneDrive installed"
        } else {
            Write-Error "OneDrive NOT installed"
            $script:Results.OneDrive = $status
            return $status
        }

        # Check if OneDrive process is running
        $process = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue
        $status.Running = $null -ne $process

        if ($status.Running) {
            Write-Success "OneDrive running"
        } else {
            Write-Warning "OneDrive not running"
        }

        # Check for OneDrive account (registry)
        $accountsPath = "HKCU:\Software\Microsoft\OneDrive\Accounts"
        if (Test-Path $accountsPath) {
            $accounts = Get-ChildItem $accountsPath -ErrorAction SilentlyContinue
            foreach ($account in $accounts) {
                $userEmail = (Get-ItemProperty -Path $account.PSPath -ErrorAction SilentlyContinue).UserEmail
                if ($userEmail) {
                    $status.SignedIn = $true
                    $status.Account = $userEmail
                    break
                }
            }
        }

        if ($status.SignedIn) {
            Write-Success "Signed in as: $($status.Account)"
        } else {
            Write-Warning "OneDrive not signed in or account not detected"
        }

        # Check Known Folder Backup status
        $kfmPath = "HKCU:\Software\Microsoft\OneDrive\Accounts\Business1"
        if (Test-Path $kfmPath) {
            $kfmDesktop = (Get-ItemProperty -Path $kfmPath -ErrorAction SilentlyContinue).KfmFoldersProtectedNow
            if ($kfmDesktop) {
                $status.KnownFolderBackup = $true
            }
        }

        # Alternative check - see if Desktop/Documents are in OneDrive path
        $desktopPath = [Environment]::GetFolderPath('Desktop')
        $documentsPath = [Environment]::GetFolderPath('MyDocuments')

        if ($desktopPath -like "*OneDrive*" -or $documentsPath -like "*OneDrive*") {
            $status.KnownFolderBackup = $true
        }

        if ($status.KnownFolderBackup) {
            Write-Success "Known Folder Backup: Enabled"
        } else {
            Write-Warning "Known Folder Backup: Not detected (verify manually)"
        }

        # Try to get sync status from icon overlay
        if ($env:OneDrive -and (Test-Path $env:OneDrive)) {
            $status.SyncStatus = "Folder exists - verify green checkmark in system tray"
            Write-Info "Sync Status: Verify green checkmark in OneDrive system tray icon"
        }

        $script:Results.OneDrive = $status
        return $status
    }
    catch {
        Write-Error "Failed to check OneDrive status: $_"
        $script:Results.OneDrive = $status
        return $status
    }
}

function Get-PrinterConfig {
    Write-Section "Exporting printer configuration..."

    try {
        $printers = Get-Printer -ErrorAction SilentlyContinue

        if (-not $printers) {
            Write-Warning "No printers found"
            return @()
        }

        Write-Info "Found $($printers.Count) printer(s):"

        $printerList = @()
        foreach ($printer in $printers) {
            $isDefault = if ($printer.Name -eq (Get-CimInstance -ClassName Win32_Printer | Where-Object { $_.Default }).Name) { " (Default)" } else { "" }
            Write-Info "  - $($printer.Name)$isDefault"

            $printerList += @{
                Name = $printer.Name
                PortName = $printer.PortName
                DriverName = $printer.DriverName
                Shared = $printer.Shared
            }
        }

        # Save to file
        $outputPath = Join-Path (Get-OneDriveDocumentsPath) $script:PrinterFileName
        $printerOutput = $printers | Select-Object Name, PortName, DriverName, Shared | Format-Table -AutoSize | Out-String
        $printerOutput | Out-File -FilePath $outputPath -Encoding UTF8 -Force

        Write-Success "Saved to: $outputPath"

        $script:Results.Printers = $printerList
        return $printerList
    }
    catch {
        Write-Error "Failed to export printers: $_"
        return @()
    }
}

function Get-WiFiSSID {
    Write-Section "Capturing WiFi network..."

    try {
        $wifiInfo = netsh wlan show interfaces 2>$null

        if ($wifiInfo) {
            $ssidLine = $wifiInfo | Select-String -Pattern "^\s+SSID\s+:\s+(.+)$"
            if ($ssidLine) {
                $ssid = $ssidLine.Matches[0].Groups[1].Value.Trim()
                Write-Info "Current SSID: $ssid"
                $script:Results.WiFi = $ssid
                return $ssid
            }
        }

        # Check if on Ethernet instead
        $ethernetAdapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.MediaType -eq '802.3' }
        if ($ethernetAdapter) {
            Write-Info "Connected via Ethernet (no WiFi SSID)"
            $script:Results.WiFi = "ETHERNET"
            return "ETHERNET"
        }

        Write-Warning "No WiFi connection detected"
        $script:Results.WiFi = "NOT CONNECTED"
        return $null
    }
    catch {
        Write-Error "Failed to get WiFi SSID: $_"
        return $null
    }
}

function Get-OutlookDataFiles {
    Write-Section "Scanning for Outlook data files..."

    $outlookPath = "$env:LOCALAPPDATA\Microsoft\Outlook"

    if (-not (Test-Path $outlookPath)) {
        Write-Info "Outlook data folder not found (Outlook may not be installed)"
        return @{ OST = @(); PST = @() }
    }

    Write-Info "Location: $outlookPath"

    try {
        # Find OST files
        $ostFiles = Get-ChildItem -Path $outlookPath -Filter "*.ost" -ErrorAction SilentlyContinue
        $pstFiles = Get-ChildItem -Path $outlookPath -Filter "*.pst" -ErrorAction SilentlyContinue

        # Also check Documents folder for PST files
        $documentsPath = [Environment]::GetFolderPath('MyDocuments')
        $pstInDocs = Get-ChildItem -Path $documentsPath -Filter "*.pst" -Recurse -ErrorAction SilentlyContinue
        if ($pstInDocs) {
            $pstFiles = @($pstFiles) + @($pstInDocs) | Where-Object { $_ }
        }

        # Report OST files
        if ($ostFiles) {
            $ostTotal = ($ostFiles | Measure-Object -Property Length -Sum).Sum / 1GB
            Write-Info "OST Files: $($ostFiles.Count) ($([math]::Round($ostTotal, 2)) GB) - Will recreate after migration"
            foreach ($file in $ostFiles) {
                $script:Results.OSTFiles += @{
                    Name = $file.Name
                    Size = $file.Length
                    Path = $file.FullName
                }
            }
        } else {
            Write-Info "OST Files: None found"
        }

        # Report PST files
        if ($pstFiles) {
            $pstTotal = ($pstFiles | Measure-Object -Property Length -Sum).Sum / 1MB
            Write-Info "PST Files: $($pstFiles.Count) ($([math]::Round($pstTotal, 0)) MB total)"
            foreach ($file in $pstFiles) {
                $sizeMB = [math]::Round($file.Length / 1MB, 0)
                Write-Info "  - $($file.Name) ($sizeMB MB)"
                $script:Results.PSTFiles += @{
                    Name = $file.Name
                    Size = $file.Length
                    Path = $file.FullName
                }
            }
        } else {
            Write-Info "PST Files: None found"
        }

        return @{ OST = $ostFiles; PST = $pstFiles }
    }
    catch {
        Write-Error "Failed to scan Outlook files: $_"
        return @{ OST = @(); PST = @() }
    }
}

function Copy-PSTFilesToOneDrive {
    param([array]$PSTFiles)

    if (-not $PSTFiles -or $PSTFiles.Count -eq 0) {
        return $false
    }

    if ($SkipPSTCopy) {
        Write-Warning "PST copy skipped (SkipPSTCopy flag set)"
        return $false
    }

    $destPath = Get-OneDriveDocumentsPath

    if (-not $Quiet) {
        Write-Prompt "Copy $($PSTFiles.Count) PST file(s) to OneDrive Documents? (Y/N): "
        $response = Read-Host
        if ($response -notmatch '^[Yy]') {
            Write-Warning "PST copy skipped by user"
            return $false
        }
    }

    $copied = 0
    foreach ($file in $PSTFiles) {
        try {
            $destFile = Join-Path $destPath $file.Name
            Copy-Item -Path $file.FullName -Destination $destFile -Force
            Write-Success "Copied: $($file.Name)"
            $copied++
        }
        catch {
            Write-Error "Failed to copy $($file.Name): $_"
        }
    }

    return $copied -gt 0
}

function Get-InstalledBrowsers {
    Write-Section "Detecting browsers..."

    $browsers = @()

    # Chrome
    $chromePath = "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
    if (Test-Path $chromePath) {
        $browsers += @{ Name = "Google Chrome"; Path = $chromePath; BookmarkUrl = "chrome://bookmarks" }
        Write-Success "Google Chrome - Installed"
    }

    # Edge
    $edgePath = "$env:ProgramFiles(x86)\Microsoft\Edge\Application\msedge.exe"
    if (-not (Test-Path $edgePath)) {
        $edgePath = "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
    }
    if (Test-Path $edgePath) {
        $browsers += @{ Name = "Microsoft Edge"; Path = $edgePath; BookmarkUrl = "edge://favorites" }
        Write-Success "Microsoft Edge - Installed"
    }

    # Firefox
    $firefoxPath = "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
    if (-not (Test-Path $firefoxPath)) {
        $firefoxPath = "$env:ProgramFiles(x86)\Mozilla Firefox\firefox.exe"
    }
    if (Test-Path $firefoxPath) {
        $browsers += @{ Name = "Mozilla Firefox"; Path = $firefoxPath; BookmarkUrl = "about:preferences" }
        Write-Success "Mozilla Firefox - Installed"
    }

    if ($browsers.Count -eq 0) {
        Write-Warning "No supported browsers detected"
    }

    $script:Results.Browsers = $browsers
    return $browsers
}

function Open-BrowserExportPages {
    param([array]$Browsers)

    if (-not $Browsers -or $Browsers.Count -eq 0) {
        return
    }

    foreach ($browser in $Browsers) {
        try {
            Write-Info "Opening $($browser.Name) bookmarks page..."
            Start-Process -FilePath $browser.Path -ArgumentList $browser.BookmarkUrl -ErrorAction SilentlyContinue
            Start-Sleep -Milliseconds 500
        }
        catch {
            Write-Warning "Could not open $($browser.Name): $_"
        }
    }

    Write-Action "Please export bookmarks and passwords from each browser window."
    Write-Info "  Chrome: Menu (⋮) → Bookmarks → Bookmark Manager → ⋮ → Export"
    Write-Info "  Edge: Menu (···) → Favorites → ⋮ → Export favorites"
    Write-Info "  Passwords: Settings → Passwords → ⋮ → Export passwords"
}

function Show-iOSReminder {
    Write-Host "`n[REMINDER] " -ForegroundColor Cyan -NoNewline
    Write-Host "iOS Device Backup" -ForegroundColor White
    Write-Host "  If user has iPhone/iPad:" -ForegroundColor Gray
    Write-Host "  1. Connect device via USB cable" -ForegroundColor Gray
    Write-Host "  2. Open Apple Devices app (install from Microsoft Store if needed)" -ForegroundColor Gray
    Write-Host "  3. Verify recent backup exists (within 24-48 hours)" -ForegroundColor Gray
    Write-Host "  4. If no backup, click 'Back Up Now'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Apple Devices App: " -ForegroundColor Gray -NoNewline
    Write-Host "https://apps.microsoft.com/detail/9np83lwlpz9k" -ForegroundColor Blue
}

function New-BackupReport {
    Write-Section "Generating backup report..."

    $reportPath = Join-Path (Get-OneDriveDocumentsPath) $script:ReportFileName

    $report = @"
════════════════════════════════════════════════════════════════
         IMPACT PROPERTY SOLUTIONS - PHASE 1 BACKUP REPORT
                    Monday Go-Live Migration
════════════════════════════════════════════════════════════════

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Script Version: $script:Version

────────────────────────────────────────────────────────────────
                        SYSTEM INFORMATION
────────────────────────────────────────────────────────────────
Computer Name:  $($script:Results.SystemInfo.ComputerName)
Serial Number:  $($script:Results.SystemInfo.SerialNumber)
Current User:   $($script:Results.SystemInfo.CurrentUser)
$(if ($script:Results.SystemInfo.UserPrincipal) { "UPN:            $($script:Results.SystemInfo.UserPrincipal)" })
Windows:        $($script:Results.SystemInfo.WindowsVersion)

────────────────────────────────────────────────────────────────
                         ONEDRIVE STATUS
────────────────────────────────────────────────────────────────
Installed:              $(if ($script:Results.OneDrive.Installed) { "Yes" } else { "NO" })
Running:                $(if ($script:Results.OneDrive.Running) { "Yes" } else { "No" })
Signed In:              $(if ($script:Results.OneDrive.SignedIn) { "Yes - $($script:Results.OneDrive.Account)" } else { "Not detected" })
Known Folder Backup:    $(if ($script:Results.OneDrive.KnownFolderBackup) { "Enabled" } else { "Not detected - VERIFY MANUALLY" })

────────────────────────────────────────────────────────────────
                         WIFI NETWORK
────────────────────────────────────────────────────────────────
Current SSID:   $($script:Results.WiFi)

────────────────────────────────────────────────────────────────
                      PRINTER CONFIGURATION
────────────────────────────────────────────────────────────────
$(if ($script:Results.Printers.Count -gt 0) {
    $script:Results.Printers | ForEach-Object { "  - $($_.Name) [$($_.PortName)]" } | Out-String
} else {
    "  No printers found"
})

────────────────────────────────────────────────────────────────
                      OUTLOOK DATA FILES
────────────────────────────────────────────────────────────────
OST Files (will recreate automatically):
$(if ($script:Results.OSTFiles.Count -gt 0) {
    $script:Results.OSTFiles | ForEach-Object { "  - $($_.Name) ($([math]::Round($_.Size / 1MB, 0)) MB)" } | Out-String
} else {
    "  None found"
})

PST Files (personal archives):
$(if ($script:Results.PSTFiles.Count -gt 0) {
    $script:Results.PSTFiles | ForEach-Object { "  - $($_.Name) ($([math]::Round($_.Size / 1MB, 0)) MB) - $($_.Path)" } | Out-String
} else {
    "  None found"
})

────────────────────────────────────────────────────────────────
                      INSTALLED BROWSERS
────────────────────────────────────────────────────────────────
$(if ($script:Results.Browsers.Count -gt 0) {
    $script:Results.Browsers | ForEach-Object { "  - $($_.Name)" } | Out-String
} else {
    "  None detected"
})

════════════════════════════════════════════════════════════════
                    PHASE 1 CHECKLIST SUMMARY
════════════════════════════════════════════════════════════════
[$(if ($script:Results.SystemInfo) { "✓" } else { " " })] System information collected
[$(if ($script:Results.OneDrive.SignedIn) { "✓" } else { " " })] OneDrive signed in
[$(if ($script:Results.OneDrive.KnownFolderBackup) { "✓" } else { " " })] Known Folder Backup enabled
[ ] OneDrive sync complete (verify green checkmark)
[$(if ($script:Results.Printers.Count -gt 0) { "✓" } else { "-" })] Printers exported ($($script:Results.Printers.Count) found)
[$(if ($script:Results.WiFi -and $script:Results.WiFi -ne "NOT CONNECTED") { "✓" } else { " " })] WiFi SSID recorded
[$(if ($script:Results.PSTFiles.Count -eq 0 -or $script:Results.PSTFiles.Count -gt 0) { "✓" } else { " " })] PST files checked ($($script:Results.PSTFiles.Count) found)
[ ] Browser bookmarks exported (manual)
[ ] Browser passwords exported (manual)
[ ] iOS backup verified (manual - if applicable)

$(if ($script:Results.Errors.Count -gt 0) {
"────────────────────────────────────────────────────────────────
                           ERRORS
────────────────────────────────────────────────────────────────"
    $script:Results.Errors | ForEach-Object { "  - $_" } | Out-String
})
════════════════════════════════════════════════════════════════
"@

    try {
        $report | Out-File -FilePath $reportPath -Encoding UTF8 -Force
        Write-Success "Report saved to: $reportPath"
        return $reportPath
    }
    catch {
        Write-Error "Failed to save report: $_"
        # Try desktop as fallback
        $fallbackPath = Join-Path ([Environment]::GetFolderPath('Desktop')) $script:ReportFileName
        try {
            $report | Out-File -FilePath $fallbackPath -Encoding UTF8 -Force
            Write-Warning "Report saved to fallback location: $fallbackPath"
            return $fallbackPath
        }
        catch {
            Write-Error "Failed to save report to fallback location"
            return $null
        }
    }
}

function Show-Summary {
    Write-Host "`n════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "                    PHASE 1 CHECKLIST SUMMARY" -ForegroundColor Cyan
    Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan

    $checkmark = "[✓]"
    $empty = "[ ]"
    $dash = "[-]"

    # System info
    if ($script:Results.SystemInfo) {
        Write-Host "$checkmark System information collected" -ForegroundColor Green
    } else {
        Write-Host "$empty System information collected" -ForegroundColor Red
    }

    # OneDrive
    if ($script:Results.OneDrive.SignedIn) {
        Write-Host "$checkmark OneDrive signed in" -ForegroundColor Green
    } else {
        Write-Host "$empty OneDrive signed in" -ForegroundColor Yellow
    }

    if ($script:Results.OneDrive.KnownFolderBackup) {
        Write-Host "$checkmark Known Folder Backup enabled" -ForegroundColor Green
    } else {
        Write-Host "$empty Known Folder Backup enabled (verify manually)" -ForegroundColor Yellow
    }

    Write-Host "$empty OneDrive sync complete (verify green checkmark)" -ForegroundColor Yellow

    # Printers
    if ($script:Results.Printers.Count -gt 0) {
        Write-Host "$checkmark Printers exported ($($script:Results.Printers.Count) printers)" -ForegroundColor Green
    } else {
        Write-Host "$dash Printers exported (none found)" -ForegroundColor Gray
    }

    # WiFi
    if ($script:Results.WiFi -and $script:Results.WiFi -ne "NOT CONNECTED") {
        Write-Host "$checkmark WiFi SSID recorded: $($script:Results.WiFi)" -ForegroundColor Green
    } else {
        Write-Host "$empty WiFi SSID recorded" -ForegroundColor Yellow
    }

    # PST files
    if ($script:Results.PSTFiles.Count -gt 0) {
        Write-Host "$checkmark PST files found ($($script:Results.PSTFiles.Count) files)" -ForegroundColor Green
    } else {
        Write-Host "$checkmark No PST files (none to backup)" -ForegroundColor Green
    }

    # Manual items
    Write-Host "$empty Browser bookmarks exported (manual)" -ForegroundColor Yellow
    Write-Host "$empty Browser passwords exported (manual)" -ForegroundColor Yellow
    Write-Host "$empty iOS backup verified (manual)" -ForegroundColor Yellow

    Write-Host "════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

try {
    Write-Banner

    # Step 1: System Information
    Get-SystemInfo | Out-Null

    # Step 2: OneDrive Status
    Get-OneDriveStatus | Out-Null

    # Step 3: WiFi SSID
    Get-WiFiSSID | Out-Null

    # Step 4: Printer Configuration
    Get-PrinterConfig | Out-Null

    # Step 5: Outlook Data Files
    $outlookFiles = Get-OutlookDataFiles

    # Step 6: Copy PST Files
    if ($outlookFiles.PST -and $outlookFiles.PST.Count -gt 0) {
        Copy-PSTFilesToOneDrive -PSTFiles $outlookFiles.PST | Out-Null
    }

    # Step 7: Browser Detection & Export
    $browsers = Get-InstalledBrowsers
    Open-BrowserExportPages -Browsers $browsers

    # Step 8: iOS Reminder
    Show-iOSReminder

    # Step 9: Generate Report
    $reportPath = New-BackupReport

    # Step 10: Show Summary
    Show-Summary

    if ($reportPath) {
        Write-Host "Report saved to: " -NoNewline
        Write-Host $reportPath -ForegroundColor Cyan
    }

    Write-Host "`nPhase 1 backup script complete. Please verify all manual items before proceeding.`n" -ForegroundColor Green
}
catch {
    Write-Host "`n[FATAL ERROR] Script failed: $_" -ForegroundColor Red
    Write-Host "Please report this error to your supervisor.`n" -ForegroundColor Red
    exit 1
}
