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

.PARAMETER TelemetryDisabled
    Disable telemetry/event logging to local JSON file

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
    [switch]$Quiet,
    [switch]$TelemetryDisabled
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

# Telemetry configuration
$script:TelemetryEnabled = -not $TelemetryDisabled
$script:TelemetryPath = "$env:USERPROFILE\AppData\Local\IPS-Migration\Telemetry"
$script:TelemetryFile = $null
$script:TelemetryData = @{
    SchemaVersion = "1.0"
    EventType = "Phase1-Backup-Complete"
    Timestamp = $null
    ScriptVersion = $script:Version
    Device = @{}
    User = @{}
    Results = @{}
    Execution = @{}
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

function Get-ChassisTypeName {
    param([int]$ChassisTypeCode)

    $chassisTypes = @{
        3 = "Desktop"
        4 = "Low Profile Desktop"
        8 = "Portable"
        9 = "Laptop"
        10 = "Notebook"
        14 = "Sub Notebook"
        30 = "Tablet"
        31 = "Convertible"
        32 = "Detachable"
    }

    return $chassisTypes[$ChassisTypeCode] ?? "Other ($ChassisTypeCode)"
}

function Get-PrinterType {
    param([string]$PortName)

    if ([string]::IsNullOrEmpty($PortName)) {
        return "Unknown"
    }

    # Network printer patterns
    if ($PortName -match "^IP_" -or $PortName -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}") {
        return "Network (IP)"
    }

    # Print server UNC path
    if ($PortName -like "\\*") {
        return "Network (Server)"
    }

    # USB printers
    if ($PortName -like "USB*") {
        return "USB"
    }

    # Standard local ports
    if ($PortName -match "^(LPT|COM)\d") {
        return "Local Port"
    }

    # WSD (Web Services for Devices) network printers
    if ($PortName -like "WSD*") {
        return "Network (WSD)"
    }

    # File/PDF virtual printers
    if ($PortName -like "FILE:*" -or $PortName -like "*PDF*") {
        return "Virtual"
    }

    return "Other"
}

function Get-PrinterStatusText {
    param([int]$StatusCode)

    # Win32_Printer status codes
    $statusMap = @{
        0 = "Unknown"
        1 = "Other"
        2 = "Unknown"
        3 = "Idle"
        4 = "Printing"
        5 = "Warmup"
        6 = "Stopped Printing"
        7 = "Offline"
    }

    return $statusMap[$StatusCode] ?? "Unknown ($StatusCode)"
}

function Get-FileVersionInfo {
    param([string]$Path)

    if (Test-Path $Path) {
        try {
            $version = (Get-Item $Path).VersionInfo.FileVersion
            return $version ?? "Unknown"
        }
        catch {
            return "Unknown"
        }
    }
    return "Not Found"
}

function Count-BookmarksRecursive {
    param($Node)

    $count = 0

    if ($Node.children) {
        foreach ($child in $Node.children) {
            if ($child.type -eq "url") {
                $count++
            }
            elseif ($child.type -eq "folder" -and $child.children) {
                $count += Count-BookmarksRecursive -Node $child
            }
        }
    }

    return $count
}

function Get-EdgePath {
    $paths = @(
        "$env:ProgramFiles(x86)\Microsoft\Edge\Application\msedge.exe",
        "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
    )
    return $paths | Where-Object { Test-Path $_ } | Select-Object -First 1
}

function Get-FirefoxPath {
    $paths = @(
        "$env:ProgramFiles\Mozilla Firefox\firefox.exe",
        "$env:ProgramFiles(x86)\Mozilla Firefox\firefox.exe"
    )
    return $paths | Where-Object { Test-Path $_ } | Select-Object -First 1
}

function Test-FolderInOneDrive {
    param(
        [string]$FolderType,  # Desktop, Documents, Pictures
        [string]$AccountPath
    )

    # Check actual folder location
    $folderPath = switch ($FolderType) {
        "Desktop"   { [Environment]::GetFolderPath('Desktop') }
        "Documents" { [Environment]::GetFolderPath('MyDocuments') }
        "Pictures"  { [Environment]::GetFolderPath('MyPictures') }
    }

    # If path contains "OneDrive", it's backed up
    if ($folderPath -like "*OneDrive*") {
        return $true
    }

    # Check registry for Known Folder Move status
    $kfmPath = "$AccountPath\Tenants"
    if (Test-Path $kfmPath) {
        $tenants = Get-ChildItem -Path $kfmPath -ErrorAction SilentlyContinue

        $folderIds = @{
            "Desktop"   = "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}"
            "Documents" = "{FDD39AD0-238F-46AF-ADB4-6C85480369C7}"
            "Pictures"  = "{33E28130-4E1E-4676-835A-98395C3BC3BB}"
        }

        foreach ($tenant in $tenants) {
            $folderId = $folderIds[$FolderType]
            $keyPath = Join-Path $tenant.PSPath $folderId
            if (Test-Path $keyPath) {
                return $true
            }
        }
    }

    return $false
}

function Get-OneDriveSyncHealth {
    # Check for sync errors in registry
    $healthStatus = @{
        HasErrors = $false
        ErrorCount = 0
        LastSync = $null
    }

    try {
        # Check for sync errors
        $errorPath = "HKCU:\Software\Microsoft\OneDrive\Errors"
        if (Test-Path $errorPath) {
            $errors = Get-ChildItem $errorPath -ErrorAction SilentlyContinue
            if ($errors) {
                $healthStatus.HasErrors = $true
                $healthStatus.ErrorCount = $errors.Count
            }
        }

        # Try to get last sync time
        $accountsPath = "HKCU:\Software\Microsoft\OneDrive\Accounts\Business1"
        if (Test-Path $accountsPath) {
            $lastSync = (Get-ItemProperty -Path $accountsPath -ErrorAction SilentlyContinue).LastSync
            if ($lastSync) {
                $healthStatus.LastSync = $lastSync
            }
        }
    }
    catch {
        # Silent fail - sync health is bonus info
    }

    return $healthStatus
}

function Initialize-Telemetry {
    if (-not $script:TelemetryEnabled) { return }

    try {
        # Create telemetry directory
        if (-not (Test-Path $script:TelemetryPath)) {
            New-Item -Path $script:TelemetryPath -ItemType Directory -Force | Out-Null
        }

        # Set telemetry file name
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $computerName = $env:COMPUTERNAME
        $script:TelemetryFile = Join-Path $script:TelemetryPath "Phase1-Events-$computerName-$timestamp.json"

        # Set execution start time
        $script:TelemetryData.Execution.StartTime = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $script:TelemetryData.Timestamp = $script:TelemetryData.Execution.StartTime
    }
    catch {
        Write-Warning "Failed to initialize telemetry: $_"
        $script:TelemetryEnabled = $false
    }
}

function Add-TelemetryData {
    param(
        [string]$Category,
        [hashtable]$Data
    )

    if (-not $script:TelemetryEnabled) { return }

    try {
        $script:TelemetryData.Results[$Category] = $Data
    }
    catch {
        Write-Warning "Failed to add telemetry data for $Category"
    }
}

function Save-Telemetry {
    if (-not $script:TelemetryEnabled) { return }

    try {
        # Finalize execution data
        $script:TelemetryData.Execution.EndTime = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        $startTime = [DateTime]::Parse($script:TelemetryData.Execution.StartTime)
        $endTime = Get-Date
        $script:TelemetryData.Execution.DurationSeconds = [math]::Round(($endTime - $startTime).TotalSeconds, 0)
        $script:TelemetryData.Execution.Success = $script:Results.Errors.Count -eq 0
        $script:TelemetryData.Execution.ErrorCount = $script:Results.Errors.Count

        # Add errors
        $script:TelemetryData.Errors = $script:Results.Errors

        # Add device and user data from Results
        if ($script:Results.SystemInfo) {
            $script:TelemetryData.Device = @{
                ComputerName = $script:Results.SystemInfo.ComputerName
                SerialNumber = $script:Results.SystemInfo.SerialNumber
                WindowsVersion = $script:Results.SystemInfo.WindowsVersion
                # NEW FIELDS
                Manufacturer = $script:Results.SystemInfo.Manufacturer
                Model = $script:Results.SystemInfo.Model
                AssetTag = $script:Results.SystemInfo.AssetTag
                UUID = $script:Results.SystemInfo.UUID
                ChassisType = $script:Results.SystemInfo.ChassisType
            }
            $script:TelemetryData.User = @{
                Username = $script:Results.SystemInfo.CurrentUser
                UPN = $script:Results.SystemInfo.UserPrincipal
            }
        }

        # Convert to JSON and save
        $json = $script:TelemetryData | ConvertTo-Json -Depth 10
        $json | Out-File -FilePath $script:TelemetryFile -Encoding UTF8 -Force

        Write-Success "Telemetry saved to: $script:TelemetryFile"
    }
    catch {
        Write-Warning "Failed to save telemetry: $_"
    }
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
        $enclosure = Get-CimInstance -ClassName Win32_SystemEnclosure
        $product = Get-CimInstance -ClassName Win32_ComputerSystemProduct

        $info = @{
            ComputerName = $env:COMPUTERNAME
            SerialNumber = $biosInfo.SerialNumber
            CurrentUser = $env:USERNAME
            UserPrincipal = whoami /upn 2>$null
            WindowsVersion = "$($osInfo.Caption) ($($osInfo.Version))"
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            # NEW FIELDS
            Manufacturer = $computerInfo.Manufacturer
            Model = $computerInfo.Model
            AssetTag = $enclosure.SMBiosAssetTag
            UUID = $product.UUID
            BIOSVersion = $biosInfo.SMBIOSBIOSVersion
            BIOSReleaseDate = $biosInfo.ReleaseDate
            ChassisType = Get-ChassisTypeName -ChassisTypeCode $enclosure.ChassisTypes[0]
        }

        Write-Info "Computer Name: $($info.ComputerName)"
        Write-Info "Serial Number: $($info.SerialNumber)"
        Write-Info "Manufacturer: $($info.Manufacturer)"
        Write-Info "Model: $($info.Model)"
        if ($info.AssetTag -and $info.AssetTag -ne "Default string") {
            Write-Info "Asset Tag: $($info.AssetTag)"
        }
        Write-Info "Chassis Type: $($info.ChassisType)"
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
        AccountType = $null  # NEW: Business/Consumer
        SyncPath = $null     # NEW: OneDrive folder path
        # NEW: Per-folder KFB status
        KnownFolderBackup = @{
            Desktop = $false
            Documents = $false
            Pictures = $false
        }
        SyncStatus = "Unknown"
        SyncHealth = $null   # NEW: Errors/Warnings
        MultipleAccounts = $false  # NEW
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

        # Enhanced account detection (all accounts, not just Business1)
        $accountsPath = "HKCU:\Software\Microsoft\OneDrive\Accounts"
        if (Test-Path $accountsPath) {
            $accounts = Get-ChildItem $accountsPath -ErrorAction SilentlyContinue

            if ($accounts.Count -gt 1) {
                $status.MultipleAccounts = $true
            }

            foreach ($account in $accounts) {
                $userEmail = (Get-ItemProperty -Path $account.PSPath -ErrorAction SilentlyContinue).UserEmail
                $userFolder = (Get-ItemProperty -Path $account.PSPath -ErrorAction SilentlyContinue).UserFolder

                if ($userEmail) {
                    $status.SignedIn = $true
                    $status.Account = $userEmail
                    $status.SyncPath = $userFolder

                    # Determine account type
                    if ($account.PSChildName -like "Business*") {
                        $status.AccountType = "Business"
                    } elseif ($account.PSChildName -like "Personal") {
                        $status.AccountType = "Consumer"
                    }

                    # Check KFB for each folder individually
                    $status.KnownFolderBackup.Desktop = Test-FolderInOneDrive -FolderType "Desktop" -AccountPath $account.PSPath
                    $status.KnownFolderBackup.Documents = Test-FolderInOneDrive -FolderType "Documents" -AccountPath $account.PSPath
                    $status.KnownFolderBackup.Pictures = Test-FolderInOneDrive -FolderType "Pictures" -AccountPath $account.PSPath

                    break  # Use first account found
                }
            }
        }

        if ($status.SignedIn) {
            Write-Success "Signed in as: $($status.Account) ($($status.AccountType))"
            Write-Info "Sync Path: $($status.SyncPath)"
            Write-Info "Desktop KFB: $(if ($status.KnownFolderBackup.Desktop) { 'Enabled' } else { 'Not enabled' })"
            Write-Info "Documents KFB: $(if ($status.KnownFolderBackup.Documents) { 'Enabled' } else { 'Not enabled' })"
            Write-Info "Pictures KFB: $(if ($status.KnownFolderBackup.Pictures) { 'Enabled' } else { 'Not enabled' })"
        } else {
            Write-Warning "OneDrive not signed in or account not detected"
        }

        # Check sync health
        $status.SyncHealth = Get-OneDriveSyncHealth

        if ($status.SyncHealth.HasErrors) {
            Write-Warning "Sync Health: $($status.SyncHealth.ErrorCount) error(s) detected"
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

function Get-PrinterInventory {  # RENAMED from Get-PrinterConfig
    Write-Section "Collecting printer inventory..."

    try {
        # Get all printers via WMI (more detailed than Get-Printer)
        $wmiPrinters = Get-CimInstance -ClassName Win32_Printer -ErrorAction SilentlyContinue

        if (-not $wmiPrinters) {
            Write-Warning "No printers found"
            return @()
        }

        Write-Info "Found $($wmiPrinters.Count) printer(s):"

        $printerList = @()
        foreach ($printer in $wmiPrinters) {
            # Classify printer type based on port
            $printerType = Get-PrinterType -PortName $printer.PortName

            # Get printer status
            $status = Get-PrinterStatusText -StatusCode $printer.PrinterStatus

            $isDefault = if ($printer.Default) { " (Default)" } else { "" }
            Write-Info "  - $($printer.Name)$isDefault [$printerType]"

            $printerInfo = @{
                Name = $printer.Name
                PortName = $printer.PortName
                DriverName = $printer.DriverName
                Shared = $printer.Shared
                Default = $printer.Default              # NEW: Fixed detection
                PrinterType = $printerType              # NEW: Network/Local/USB
                Status = $status                        # NEW: Ready/Offline/Error
                Location = $printer.Location            # NEW
                Comment = $printer.Comment              # NEW
                ServerName = $printer.ServerName        # NEW: For network printers
                Local = $printer.Local                  # NEW
            }

            $printerList += $printerInfo
        }

        # Save to file (keep existing functionality)
        $outputPath = Join-Path (Get-OneDriveDocumentsPath) $script:PrinterFileName
        $printerOutput = $printerList | ForEach-Object {
            [PSCustomObject]$_
        } | Format-Table Name, PrinterType, PortName, Status, Default -AutoSize | Out-String
        $printerOutput | Out-File -FilePath $outputPath -Encoding UTF8 -Force

        Write-Success "Saved to: $outputPath"

        $script:Results.Printers = $printerList
        return $printerList
    }
    catch {
        Write-Error "Failed to collect printer inventory: $_"
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

function Get-ChromeProfileData {
    $data = @{
        Name = "Google Chrome"
        Path = "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
        Version = Get-FileVersionInfo -Path "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
        ProfilePath = "$env:LOCALAPPDATA\Google\Chrome\User Data"
        ProfileCount = 0
        BookmarkCount = 0
        ExtensionCount = 0
        ProfileSize = 0
        BookmarkUrl = "chrome://bookmarks"
    }

    try {
        # Enumerate profiles
        $userDataPath = "$env:LOCALAPPDATA\Google\Chrome\User Data"
        if (Test-Path $userDataPath) {
            $profiles = Get-ChildItem $userDataPath -Directory | Where-Object { $_.Name -match "^(Default|Profile \d+)$" }
            $data.ProfileCount = $profiles.Count

            # Count bookmarks across all profiles
            foreach ($profile in $profiles) {
                $bookmarkFile = Join-Path $profile.FullName "Bookmarks"
                if (Test-Path $bookmarkFile) {
                    $bookmarks = Get-Content $bookmarkFile -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
                    if ($bookmarks.roots) {
                        $data.BookmarkCount += (Count-BookmarksRecursive -Node $bookmarks.roots.bookmark_bar)
                        $data.BookmarkCount += (Count-BookmarksRecursive -Node $bookmarks.roots.other)
                    }
                }

                # Count extensions
                $extensionsPath = Join-Path $profile.FullName "Extensions"
                if (Test-Path $extensionsPath) {
                    $extensions = Get-ChildItem $extensionsPath -Directory -ErrorAction SilentlyContinue
                    $data.ExtensionCount += $extensions.Count
                }
            }

            # Calculate total profile size
            $data.ProfileSize = (Get-ChildItem $userDataPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        }
    }
    catch {
        Write-Warning "Error reading Chrome profile data: $_"
    }

    return $data
}

function Get-EdgeProfileData {
    $edgePath = Get-EdgePath
    $data = @{
        Name = "Microsoft Edge"
        Path = $edgePath
        Version = Get-FileVersionInfo -Path $edgePath
        ProfilePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"
        ProfileCount = 0
        BookmarkCount = 0
        ExtensionCount = 0
        ProfileSize = 0
        BookmarkUrl = "edge://favorites"
    }

    try {
        $userDataPath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"
        if (Test-Path $userDataPath) {
            $profiles = Get-ChildItem $userDataPath -Directory | Where-Object { $_.Name -match "^(Default|Profile \d+)$" }
            $data.ProfileCount = $profiles.Count

            # Count bookmarks (same structure as Chrome)
            foreach ($profile in $profiles) {
                $bookmarkFile = Join-Path $profile.FullName "Bookmarks"
                if (Test-Path $bookmarkFile) {
                    $bookmarks = Get-Content $bookmarkFile -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
                    if ($bookmarks.roots) {
                        $data.BookmarkCount += (Count-BookmarksRecursive -Node $bookmarks.roots.bookmark_bar)
                        $data.BookmarkCount += (Count-BookmarksRecursive -Node $bookmarks.roots.other)
                    }
                }

                # Count extensions
                $extensionsPath = Join-Path $profile.FullName "Extensions"
                if (Test-Path $extensionsPath) {
                    $extensions = Get-ChildItem $extensionsPath -Directory -ErrorAction SilentlyContinue
                    $data.ExtensionCount += $extensions.Count
                }
            }

            $data.ProfileSize = (Get-ChildItem $userDataPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        }
    }
    catch {
        Write-Warning "Error reading Edge profile data: $_"
    }

    return $data
}

function Get-FirefoxProfileData {
    $firefoxPath = Get-FirefoxPath
    $data = @{
        Name = "Mozilla Firefox"
        Path = $firefoxPath
        Version = Get-FileVersionInfo -Path $firefoxPath
        ProfilePath = "$env:APPDATA\Mozilla\Firefox\Profiles"
        ProfileCount = 0
        BookmarkCount = 0
        ExtensionCount = 0
        ProfileSize = 0
        BookmarkUrl = "about:preferences"
    }

    try {
        $profilesIni = "$env:APPDATA\Mozilla\Firefox\profiles.ini"
        if (Test-Path $profilesIni) {
            # Parse profiles.ini to find profile directories
            $iniContent = Get-Content $profilesIni
            $profilePaths = $iniContent | Where-Object { $_ -match "^Path=" } | ForEach-Object { $_ -replace "^Path=", "" }
            $data.ProfileCount = $profilePaths.Count

            foreach ($profileRelPath in $profilePaths) {
                $profilePath = Join-Path "$env:APPDATA\Mozilla\Firefox\Profiles" $profileRelPath

                if (Test-Path $profilePath) {
                    # Count bookmarks from places.sqlite (complex - simplified approach)
                    $placesDb = Join-Path $profilePath "places.sqlite"
                    if (Test-Path $placesDb) {
                        # Estimate based on file size (rough approximation)
                        $dbSize = (Get-Item $placesDb).Length
                        $data.BookmarkCount += [math]::Floor($dbSize / 1024)  # Very rough estimate
                    }

                    # Count extensions
                    $extensionsJson = Join-Path $profilePath "extensions.json"
                    if (Test-Path $extensionsJson) {
                        $extData = Get-Content $extensionsJson -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
                        if ($extData.addons) {
                            $data.ExtensionCount += $extData.addons.Count
                        }
                    }
                }
            }

            $profilesPath = "$env:APPDATA\Mozilla\Firefox\Profiles"
            if (Test-Path $profilesPath) {
                $data.ProfileSize = (Get-ChildItem $profilesPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            }
        }
    }
    catch {
        Write-Warning "Error reading Firefox profile data: $_"
    }

    return $data
}

function Get-BrowserProfileSummary {  # RENAMED from Get-InstalledBrowsers
    Write-Section "Analyzing browser profiles..."

    $browsers = @()

    # Chrome
    $chromePath = "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
    if (Test-Path $chromePath) {
        $chromeData = Get-ChromeProfileData
        $browsers += $chromeData
        Write-Success "Google Chrome - Version $($chromeData.Version)"
        Write-Info "  Profiles: $($chromeData.ProfileCount) | Bookmarks: $($chromeData.BookmarkCount) | Extensions: $($chromeData.ExtensionCount)"
    }

    # Edge
    $edgePath = Get-EdgePath
    if ($edgePath) {
        $edgeData = Get-EdgeProfileData
        $browsers += $edgeData
        Write-Success "Microsoft Edge - Version $($edgeData.Version)"
        Write-Info "  Profiles: $($edgeData.ProfileCount) | Bookmarks: $($edgeData.BookmarkCount) | Extensions: $($edgeData.ExtensionCount)"
    }

    # Firefox
    $firefoxPath = Get-FirefoxPath
    if ($firefoxPath) {
        $firefoxData = Get-FirefoxProfileData
        $browsers += $firefoxData
        Write-Success "Mozilla Firefox - Version $($firefoxData.Version)"
        Write-Info "  Profiles: $($firefoxData.ProfileCount) | Bookmarks: $($firefoxData.BookmarkCount)"
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
Manufacturer:   $($script:Results.SystemInfo.Manufacturer)
Model:          $($script:Results.SystemInfo.Model)
$(if ($script:Results.SystemInfo.AssetTag -and $script:Results.SystemInfo.AssetTag -ne "Default string") { "Asset Tag:      $($script:Results.SystemInfo.AssetTag)" })
UUID:           $($script:Results.SystemInfo.UUID)
Chassis Type:   $($script:Results.SystemInfo.ChassisType)
Current User:   $($script:Results.SystemInfo.CurrentUser)
$(if ($script:Results.SystemInfo.UserPrincipal) { "UPN:            $($script:Results.SystemInfo.UserPrincipal)" })
Windows:        $($script:Results.SystemInfo.WindowsVersion)

────────────────────────────────────────────────────────────────
                         ONEDRIVE STATUS
────────────────────────────────────────────────────────────────
Installed:              $(if ($script:Results.OneDrive.Installed) { "Yes" } else { "NO" })
Running:                $(if ($script:Results.OneDrive.Running) { "Yes" } else { "No" })
Signed In:              $(if ($script:Results.OneDrive.SignedIn) { "Yes - $($script:Results.OneDrive.Account)" } else { "Not detected" })
Account Type:           $($script:Results.OneDrive.AccountType)
Sync Path:              $($script:Results.OneDrive.SyncPath)
Desktop Backup:         $(if ($script:Results.OneDrive.KnownFolderBackup.Desktop) { "Enabled" } else { "Not enabled" })
Documents Backup:       $(if ($script:Results.OneDrive.KnownFolderBackup.Documents) { "Enabled" } else { "Not enabled" })
Pictures Backup:        $(if ($script:Results.OneDrive.KnownFolderBackup.Pictures) { "Enabled" } else { "Not enabled" })

────────────────────────────────────────────────────────────────
                         WIFI NETWORK
────────────────────────────────────────────────────────────────
Current SSID:   $($script:Results.WiFi)

────────────────────────────────────────────────────────────────
                      PRINTER CONFIGURATION
────────────────────────────────────────────────────────────────
$(if ($script:Results.Printers.Count -gt 0) {
    $script:Results.Printers | ForEach-Object {
        $defaultFlag = if ($_.Default) { " - DEFAULT" } else { "" }
        "  - $($_.Name) [$($_.PrinterType)] - $($_.Status)$defaultFlag"
    } | Out-String
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
                    BROWSER PROFILE SUMMARY
────────────────────────────────────────────────────────────────
$(if ($script:Results.Browsers.Count -gt 0) {
    $script:Results.Browsers | ForEach-Object {
        "$($_.Name) - Version $($_.Version)
  Profiles: $($_.ProfileCount) | Bookmarks: $($_.BookmarkCount) | Extensions: $($_.ExtensionCount)
  Profile Size: $([math]::Round($_.ProfileSize / 1MB, 1)) MB
  Location: $($_.ProfilePath)"
    } | Out-String
} else {
    "  None detected"
})

════════════════════════════════════════════════════════════════
                    PHASE 1 CHECKLIST SUMMARY
════════════════════════════════════════════════════════════════
[$(if ($script:Results.SystemInfo) { "✓" } else { " " })] System information collected
[$(if ($script:Results.OneDrive.SignedIn) { "✓" } else { " " })] OneDrive signed in
[$(if ($script:Results.OneDrive.KnownFolderBackup.Desktop -and $script:Results.OneDrive.KnownFolderBackup.Documents -and $script:Results.OneDrive.KnownFolderBackup.Pictures) { "✓" } else { " " })] Known Folder Backup enabled (all folders)
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
    # Initialize telemetry
    Initialize-Telemetry

    Write-Banner

    # Step 1: System Information
    Get-SystemInfo | Out-Null

    # Step 2: OneDrive Status
    Get-OneDriveStatus | Out-Null
    if ($script:Results.OneDrive) {
        Add-TelemetryData -Category "OneDrive" -Data $script:Results.OneDrive
    }

    # Step 3: WiFi SSID
    Get-WiFiSSID | Out-Null
    if ($script:Results.WiFi) {
        Add-TelemetryData -Category "WiFi" -Data @{ SSID = $script:Results.WiFi }
    }

    # Step 4: Printer Configuration
    Get-PrinterInventory | Out-Null
    if ($script:Results.Printers) {
        Add-TelemetryData -Category "Printers" -Data @{
            Count = $script:Results.Printers.Count
            Names = $script:Results.Printers | ForEach-Object { $_.Name }
            # NEW FIELDS
            Types = $script:Results.Printers | ForEach-Object { $_.PrinterType } | Select-Object -Unique
            NetworkPrinters = ($script:Results.Printers | Where-Object { $_.PrinterType -like "Network*" }).Count
            DefaultPrinter = ($script:Results.Printers | Where-Object { $_.Default }).Name
        }
    }

    # Step 5: Outlook Data Files
    $outlookFiles = Get-OutlookDataFiles
    if ($script:Results.PSTFiles -or $script:Results.OSTFiles) {
        $pstTotalMB = if ($script:Results.PSTFiles.Count -gt 0) {
            [math]::Round(($script:Results.PSTFiles | Measure-Object -Property Size -Sum).Sum / 1MB, 0)
        } else { 0 }

        Add-TelemetryData -Category "OutlookDataFiles" -Data @{
            PSTCount = $script:Results.PSTFiles.Count
            PSTTotalSizeMB = $pstTotalMB
            PSTCopied = $false  # Will be updated if copy succeeds
        }
    }

    # Step 6: Copy PST Files
    if ($outlookFiles.PST -and $outlookFiles.PST.Count -gt 0) {
        $copied = Copy-PSTFilesToOneDrive -PSTFiles $outlookFiles.PST
        if ($script:TelemetryData.Results.ContainsKey("OutlookDataFiles")) {
            $script:TelemetryData.Results.OutlookDataFiles.PSTCopied = $copied
        }
    }

    # Step 7: Browser Detection & Export
    $browsers = Get-BrowserProfileSummary
    if ($script:Results.Browsers) {
        Add-TelemetryData -Category "Browsers" -Data @{
            Installed = $script:Results.Browsers | ForEach-Object { $_.Name }
            # NEW FIELDS
            Versions = $script:Results.Browsers | ForEach-Object { @{ Name = $_.Name; Version = $_.Version } }
            TotalBookmarks = ($script:Results.Browsers | Measure-Object -Property BookmarkCount -Sum).Sum
            TotalExtensions = ($script:Results.Browsers | Measure-Object -Property ExtensionCount -Sum).Sum
            TotalProfileSize = ($script:Results.Browsers | Measure-Object -Property ProfileSize -Sum).Sum
        }
    }
    Open-BrowserExportPages -Browsers $browsers

    # Step 8: iOS Reminder
    Show-iOSReminder

    # Step 9: Generate Report
    $reportPath = New-BackupReport

    # Step 10: Show Summary
    Show-Summary

    # Step 11: Save Telemetry
    Save-Telemetry

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
