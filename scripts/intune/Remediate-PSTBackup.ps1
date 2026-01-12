# Remediate-PSTBackup.ps1
# Intune Proactive Remediation - Remediation Script
# Purpose: Copies PST files to OneDrive Documents backup folder (< 2GB limit)
#
# Exit Codes:
#   0 = Success (backup created or backed off safely)
#   1 = Failure (unexpected error)

# ======================================================================
# Toast Notification Helper Function
# ======================================================================
function Show-ToastNotification {
    param(
        [string]$Title,
        [string]$Message,
        [int]$DurationSeconds = 10
    )

    try {
        # Method 1: Try BurntToast module (if available)
        if (Get-Module -ListAvailable -Name BurntToast) {
            Import-Module BurntToast -ErrorAction Stop
            New-BurntToastNotification -Text $Title, $Message -Silent
            return $true
        }

        # Method 2: Native Windows.UI.Notifications (Windows 10/11)
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

        $template = @"
<toast>
    <visual>
        <binding template="ToastGeneric">
            <text>$Title</text>
            <text>$Message</text>
        </binding>
    </visual>
</toast>
"@

        $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
        $xml.LoadXml($template)

        $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
        $toast.ExpirationTime = [DateTimeOffset]::Now.AddSeconds($DurationSeconds)

        $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Impact Property Solutions - Migration")
        $notifier.Show($toast)

        return $true
    } catch {
        # Silent fail - warning file will still be created
        Write-Warning "Failed to show toast notification: $_"
        return $false
    }
}

# ======================================================================
# High-Risk Detection: Check OneDrive Health
# ======================================================================
try {
    # Check 1: OneDrive is running
    $oneDriveProcess = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue
    if (-not $oneDriveProcess) {
        # BACK OFF: OneDrive not running - backups won't sync
        $oneDriveDocsPath = [Environment]::GetFolderPath('MyDocuments')
        $warningFile = Join-Path $oneDriveDocsPath "IPS-Migration-WARNING-PSTBackup.txt"
        $warningMessage = @"
Impact Property Solutions - Migration Warning
Script: PST Backup
Computer: $env:COMPUTERNAME
Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

WARNING: OneDrive is not running. PST backup cannot be synchronized to the cloud.

ACTION REQUIRED: Please ensure OneDrive is running and signed in, then this script will retry automatically.
"@

        if (Test-Path $oneDriveDocsPath) {
            $warningMessage | Out-File -FilePath $warningFile -Encoding UTF8 -Force
        }

        # Show toast notification
        $toastShown = Show-ToastNotification `
            -Title "Outlook Data Backup: Action Required" `
            -Message "Please start OneDrive and sign in. Your Outlook data files will be backed up automatically."

        # Write telemetry
        $telemetry = @{
            ComputerName = $env:COMPUTERNAME
            Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
            BackedOff = $true
            Reason = "OneDrive process not running"
            RiskLevel = "High"
            ActionRequired = "Start OneDrive and sign in"
            ToastNotification = @{
                Shown = $toastShown
                Title = "Outlook Data Backup: Action Required"
                Message = "Please start OneDrive and sign in."
            }
        }

        $telemetryFile = "C:\Support\Remediation-PSTBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
        $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

        # Exit compliant to prevent retry loops
        exit 0
    }

    # Check 2: OneDrive Documents folder exists and is accessible
    $oneDriveDocsPath = [Environment]::GetFolderPath('MyDocuments')
    if (-not (Test-Path $oneDriveDocsPath)) {
        # BACK OFF: Documents folder doesn't exist or not accessible
        $telemetry = @{
            ComputerName = $env:COMPUTERNAME
            Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
            BackedOff = $true
            Reason = "OneDrive Documents folder not accessible"
            RiskLevel = "High"
            ActionRequired = "Verify OneDrive is properly configured"
        }

        $telemetryFile = "C:\Support\Remediation-PSTBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
        $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

        exit 0
    }

    # Check 3: Sufficient disk space (at least 1GB free)
    $drive = (Get-Item $oneDriveDocsPath).PSDrive
    $freeSpace = (Get-PSDrive $drive.Name).Free
    if ($freeSpace -lt 1GB) {
        # BACK OFF: Insufficient disk space
        $warningFile = Join-Path $oneDriveDocsPath "IPS-Migration-WARNING-PSTBackup.txt"
        $warningMessage = @"
Impact Property Solutions - Migration Warning
Script: PST Backup
Computer: $env:COMPUTERNAME
Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

WARNING: Insufficient disk space (less than 1GB available).

ACTION REQUIRED: Please free up disk space, then this script will retry automatically.
"@
        $warningMessage | Out-File -FilePath $warningFile -Encoding UTF8 -Force

        # Show toast notification
        $toastShown = Show-ToastNotification `
            -Title "Outlook Data Backup: Low Disk Space" `
            -Message "Free up disk space. Backup will retry automatically."

        $telemetry = @{
            ComputerName = $env:COMPUTERNAME
            Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
            BackedOff = $true
            Reason = "Insufficient disk space (< 1GB)"
            RiskLevel = "High"
            ActionRequired = "Free up disk space"
            FreeSpaceMB = [math]::Round($freeSpace / 1MB, 0)
            ToastNotification = @{
                Shown = $toastShown
                Title = "Outlook Data Backup: Low Disk Space"
                Message = "Free up disk space."
            }
        }

        $telemetryFile = "C:\Support\Remediation-PSTBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
        $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

        exit 0
    }

    # High-Risk Detection: PST-Specific Checks

    # Check 4: Outlook is NOT running (avoid locked files)
    $outlookProcess = Get-Process -Name "OUTLOOK" -ErrorAction SilentlyContinue
    if ($outlookProcess) {
        # BACK OFF: Outlook is running - PST files may be locked
        $warningFile = Join-Path $oneDriveDocsPath "IPS-Migration-WARNING-PSTBackup.txt"
        $warningMessage = @"
Impact Property Solutions - Migration Warning
Script: PST Backup
Computer: $env:COMPUTERNAME
Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

WARNING: Outlook is currently running. PST files may be locked and cannot be safely copied.

ACTION REQUIRED: Please close Outlook, then this script will retry automatically.
"@
        $warningMessage | Out-File -FilePath $warningFile -Encoding UTF8 -Force

        # Show toast notification
        $toastShown = Show-ToastNotification `
            -Title "Outlook Data Backup: Close Outlook" `
            -Message "Please close Outlook completely. Your PST files will be backed up automatically once closed."

        $telemetry = @{
            ComputerName = $env:COMPUTERNAME
            Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
            BackedOff = $true
            Reason = "Outlook is running - PST files may be locked"
            RiskLevel = "High"
            ActionRequired = "Close Outlook and retry"
            ToastNotification = @{
                Shown = $toastShown
                Title = "Outlook Data Backup: Close Outlook"
                Message = "Please close Outlook completely."
            }
        }

        $telemetryFile = "C:\Support\Remediation-PSTBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
        $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

        exit 0
    }

    # Create backup folder
    $pstBackupFolder = Join-Path $oneDriveDocsPath "IPS-Migration-PSTBackup"
    New-Item -Path $pstBackupFolder -ItemType Directory -Force | Out-Null

    # Search for PST files
    $pstFiles = @()
    $searchPaths = @(
        "$env:LOCALAPPDATA\Microsoft\Outlook",
        "$env:APPDATA\Local\Microsoft\Outlook",
        "$env:USERPROFILE\Documents",
        "$env:USERPROFILE\Desktop"
    )

    foreach ($path in $searchPaths) {
        if (Test-Path $path) {
            $pstFiles += Get-ChildItem -Path $path -Filter "*.pst" -File -Recurse -ErrorAction SilentlyContinue
        }
    }

    if ($pstFiles.Count -eq 0) {
        # No PST files found
        $telemetry = @{
            ComputerName = $env:COMPUTERNAME
            Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
            PSTCount = 0
            Message = "No PST files found"
            Success = $true
        }

        $telemetryFile = "C:\Support\Remediation-PSTBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
        $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

        # Create summary file
        $summaryFile = Join-Path $pstBackupFolder "BackupSummary.txt"
        @"
Impact Property Solutions - PST File Backup Summary
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Computer: $env:COMPUTERNAME

Status: No PST files found on this device.
"@ | Out-File -FilePath $summaryFile -Encoding UTF8 -Force

        exit 0
    }

    # Check 5: Total PST size doesn't exceed 80% of available space
    $totalPSTSize = ($pstFiles | Measure-Object -Property Length -Sum).Sum
    $availableSpace = $freeSpace
    if ($totalPSTSize -gt ($availableSpace * 0.8)) {
        # BACK OFF: PST files would consume >80% of available space
        $warningFile = Join-Path $oneDriveDocsPath "IPS-Migration-WARNING-PSTBackup.txt"
        $totalPSTSizeGB = [math]::Round($totalPSTSize / 1GB, 2)
        $availableSpaceGB = [math]::Round($availableSpace / 1GB, 2)
        $warningMessage = @"
Impact Property Solutions - Migration Warning
Script: PST Backup
Computer: $env:COMPUTERNAME
Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

WARNING: Total PST file size ($totalPSTSizeGB GB) exceeds 80% of available disk space ($availableSpaceGB GB).

ACTION REQUIRED: Please contact IT support for assistance with PST backup. Your PST files may need to be archived or migrated separately.
"@
        $warningMessage | Out-File -FilePath $warningFile -Encoding UTF8 -Force

        # Show toast notification
        $toastShown = Show-ToastNotification `
            -Title "Outlook Data Backup: Manual Assistance Required" `
            -Message "Your Outlook data files are very large. Please contact IT support for manual backup assistance."

        $telemetry = @{
            ComputerName = $env:COMPUTERNAME
            Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
            BackedOff = $true
            Reason = "Total PST size exceeds 80% of available space"
            RiskLevel = "High"
            ActionRequired = "Contact IT for manual PST backup"
            TotalPSTSizeGB = $totalPSTSizeGB
            AvailableSpaceGB = $availableSpaceGB
            ToastNotification = @{
                Shown = $toastShown
                Title = "Outlook Data Backup: Manual Assistance Required"
                Message = "Your Outlook data files are very large."
            }
        }

        $telemetryFile = "C:\Support\Remediation-PSTBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
        $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

        exit 0
    }

    # Copy PST files (with size check and lock detection)
    $copiedFiles = @()
    $skippedFiles = @()
    $maxSize = 2GB

    foreach ($pst in $pstFiles) {
        # Check for network-located PST files (UNC paths)
        if ($pst.FullName -like "\\*") {
            $skippedFiles += @{
                Name = $pst.Name
                Path = $pst.FullName
                SizeMB = [math]::Round($pst.Length / 1MB, 0)
                Reason = "Network-located PST file (UNC path) - skipped for performance"
            }
            continue
        }

        # Check file size
        if ($pst.Length -gt $maxSize) {
            $skippedFiles += @{
                Name = $pst.Name
                Path = $pst.FullName
                SizeMB = [math]::Round($pst.Length / 1MB, 0)
                Reason = "File exceeds 2GB OneDrive limit"
            }
            continue
        }

        # Check if file is locked
        $isLocked = $false
        try {
            $fileStream = [System.IO.File]::Open($pst.FullName, 'Open', 'Read', 'None')
            $fileStream.Close()
        }
        catch {
            $isLocked = $true
            $skippedFiles += @{
                Name = $pst.Name
                Path = $pst.FullName
                SizeMB = [math]::Round($pst.Length / 1MB, 0)
                Reason = "File is locked - cannot copy safely"
            }
            continue
        }

        # File is safe to copy
        $destPath = Join-Path $pstBackupFolder $pst.Name

        try {
            Copy-Item -Path $pst.FullName -Destination $destPath -Force -ErrorAction Stop
            $copiedFiles += @{
                Name = $pst.Name
                Path = $pst.FullName
                SizeMB = [math]::Round($pst.Length / 1MB, 0)
                BackupPath = $destPath
            }
        }
        catch {
            $skippedFiles += @{
                Name = $pst.Name
                Path = $pst.FullName
                SizeMB = [math]::Round($pst.Length / 1MB, 0)
                Reason = "Copy failed: $($_.Exception.Message)"
            }
        }
    }

    # Create summary report
    $summaryFile = Join-Path $pstBackupFolder "BackupSummary.txt"
    $summary = @"
Impact Property Solutions - PST File Backup Summary
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Computer: $env:COMPUTERNAME

Total PST Files Found: $($pstFiles.Count)
Successfully Copied: $($copiedFiles.Count)
Skipped: $($skippedFiles.Count)

"@

    if ($copiedFiles.Count -gt 0) {
        $summary += "Copied Files:`n"
        foreach ($file in $copiedFiles) {
            $summary += "- $($file.Name) ($($file.SizeMB) MB)`n"
        }
    }

    if ($skippedFiles.Count -gt 0) {
        $summary += "`nSkipped Files:`n"
        foreach ($file in $skippedFiles) {
            $summary += "- $($file.Name) ($($file.SizeMB) MB) - $($file.Reason)`n"
        }
    }

    $summary += @"

NOTE: This backup is automatically synchronized to OneDrive and will be available after migration.
Files larger than 2GB must be handled separately - please contact IT support.
"@

    $summary | Out-File -FilePath $summaryFile -Encoding UTF8 -Force

    # Write telemetry
    $telemetry = @{
        ComputerName = $env:COMPUTERNAME
        Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        TotalPSTFiles = $pstFiles.Count
        CopiedCount = $copiedFiles.Count
        SkippedCount = $skippedFiles.Count
        CopiedFiles = $copiedFiles
        SkippedFiles = $skippedFiles
        BackupPath = $pstBackupFolder
        Success = $true
    }

    $telemetryFile = "C:\Support\Remediation-PSTBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
    New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
    $telemetry | ConvertTo-Json -Depth 5 | Out-File -FilePath $telemetryFile -Encoding UTF8

    # Also create human-readable report
    $txtReport = "C:\Support\Remediation-PSTBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
    @"
PST Backup Remediation Report
Computer: $env:COMPUTERNAME
Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Status: SUCCESS

Total PST Files: $($pstFiles.Count)
Successfully Copied: $($copiedFiles.Count)
Skipped: $($skippedFiles.Count)

Backup Location: $pstBackupFolder

This backup is automatically synchronized to OneDrive and will be available after migration.
"@ | Out-File -FilePath $txtReport -Encoding UTF8

    exit 0
}
catch {
    # Write error telemetry
    $telemetry = @{
        ComputerName = $env:COMPUTERNAME
        Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        Error = $_.Exception.Message
        Success = $false
    }

    $telemetryFile = "C:\Support\Remediation-PSTBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
    New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
    $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

    exit 1
}
