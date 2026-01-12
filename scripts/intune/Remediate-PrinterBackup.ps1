# Remediate-PrinterBackup.ps1
# Intune Proactive Remediation - Remediation Script
# Purpose: Exports all printers to OneDrive Documents for backup
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
        $warningFile = Join-Path $oneDriveDocsPath "IPS-Migration-WARNING-PrinterBackup.txt"
        $warningMessage = @"
Impact Property Solutions - Migration Warning
Script: Printer Backup
Computer: $env:COMPUTERNAME
Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

WARNING: OneDrive is not running. Printer backup cannot be synchronized to the cloud.

ACTION REQUIRED: Please ensure OneDrive is running and signed in, then this script will retry automatically.
"@

        if (Test-Path $oneDriveDocsPath) {
            $warningMessage | Out-File -FilePath $warningFile -Encoding UTF8 -Force
        }

        # Show toast notification
        $toastShown = Show-ToastNotification `
            -Title "Printer Backup: Action Required" `
            -Message "Please start OneDrive and sign in. Your printer configuration will be backed up automatically."

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
                Title = "Printer Backup: Action Required"
                Message = "Please start OneDrive and sign in."
            }
        }

        $telemetryFile = "C:\Support\Remediation-PrinterBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
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

        $telemetryFile = "C:\Support\Remediation-PrinterBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
        $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

        exit 0
    }

    # Check 3: Sufficient disk space (at least 1GB free)
    $drive = (Get-Item $oneDriveDocsPath).PSDrive
    $freeSpace = (Get-PSDrive $drive.Name).Free
    if ($freeSpace -lt 1GB) {
        # BACK OFF: Insufficient disk space
        $warningFile = Join-Path $oneDriveDocsPath "IPS-Migration-WARNING-PrinterBackup.txt"
        $warningMessage = @"
Impact Property Solutions - Migration Warning
Script: Printer Backup
Computer: $env:COMPUTERNAME
Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

WARNING: Insufficient disk space (less than 1GB available).

ACTION REQUIRED: Please free up disk space, then this script will retry automatically.
"@
        $warningMessage | Out-File -FilePath $warningFile -Encoding UTF8 -Force

        # Show toast notification
        $toastShown = Show-ToastNotification `
            -Title "Printer Backup: Low Disk Space" `
            -Message "Free up at least 1GB of disk space. Backup will retry automatically."

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
                Title = "Printer Backup: Low Disk Space"
                Message = "Free up at least 1GB of disk space."
            }
        }

        $telemetryFile = "C:\Support\Remediation-PrinterBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
        $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

        exit 0
    }

    # High-Risk Detection: Printer-Specific Checks

    # Check 4: Print spooler is running
    $spoolerService = Get-Service -Name "Spooler" -ErrorAction SilentlyContinue
    if ($spoolerService.Status -ne "Running") {
        # BACK OFF: Print spooler not running - printer data may be unreliable
        $warningFile = Join-Path $oneDriveDocsPath "IPS-Migration-WARNING-PrinterBackup.txt"
        $warningMessage = @"
Impact Property Solutions - Migration Warning
Script: Printer Backup
Computer: $env:COMPUTERNAME
Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

WARNING: Print spooler service is not running. Printer configuration data may be unreliable.

ACTION REQUIRED: Please start the Print Spooler service, then this script will retry automatically.
"@
        $warningMessage | Out-File -FilePath $warningFile -Encoding UTF8 -Force

        # Show toast notification
        $toastShown = Show-ToastNotification `
            -Title "Printer Backup: Service Issue" `
            -Message "Print Spooler service is stopped. Please contact IT support."

        $telemetry = @{
            ComputerName = $env:COMPUTERNAME
            Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
            BackedOff = $true
            Reason = "Print Spooler service not running"
            RiskLevel = "High"
            ActionRequired = "Start Print Spooler service"
            ToastNotification = @{
                Shown = $toastShown
                Title = "Printer Backup: Service Issue"
                Message = "Print Spooler service is stopped."
            }
        }

        $telemetryFile = "C:\Support\Remediation-PrinterBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
        $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

        exit 0
    }

    # Get printer list
    $printers = Get-CimInstance -ClassName Win32_Printer -ErrorAction Stop

    # Check 5: Excessive printer count (>50 printers)
    if ($printers.Count -gt 50) {
        # BACK OFF: Too many printers - may indicate print server scenario
        $warningFile = Join-Path $oneDriveDocsPath "IPS-Migration-WARNING-PrinterBackup.txt"
        $warningMessage = @"
Impact Property Solutions - Migration Warning
Script: Printer Backup
Computer: $env:COMPUTERNAME
Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

WARNING: Excessive printer count detected ($($printers.Count) printers). This may indicate a print server scenario rather than an end-user device.

ACTION REQUIRED: Please contact IT support for manual printer backup assistance.
"@
        $warningMessage | Out-File -FilePath $warningFile -Encoding UTF8 -Force

        # Show toast notification
        $toastShown = Show-ToastNotification `
            -Title "Printer Backup: Manual Review Needed" `
            -Message "You have more than 50 printers configured. Please contact IT support for manual backup."

        $telemetry = @{
            ComputerName = $env:COMPUTERNAME
            Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
            BackedOff = $true
            Reason = "Excessive printer count (>50)"
            RiskLevel = "High"
            ActionRequired = "Contact IT for manual backup"
            PrinterCount = $printers.Count
            ToastNotification = @{
                Shown = $toastShown
                Title = "Printer Backup: Manual Review Needed"
                Message = "More than 50 printers detected."
            }
        }

        $telemetryFile = "C:\Support\Remediation-PrinterBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
        $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

        exit 0
    }

    # All checks passed - proceed with backup
    $backupFile = Join-Path $oneDriveDocsPath "IPS-Migration-PrinterBackup.txt"

    $output = @"
Impact Property Solutions - Printer Configuration Backup
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Computer: $env:COMPUTERNAME

Printers Found: $($printers.Count)

"@

    foreach ($printer in $printers) {
        $defaultFlag = if ($printer.Default) { " [DEFAULT]" } else { "" }
        $output += "`n- $($printer.Name)$defaultFlag`n"
        $output += "  Port: $($printer.PortName)`n"
        $output += "  Driver: $($printer.DriverName)`n"
        if ($printer.Location) {
            $output += "  Location: $($printer.Location)`n"
        }
        if ($printer.Comment) {
            $output += "  Comment: $($printer.Comment)`n"
        }
    }

    $output | Out-File -FilePath $backupFile -Encoding UTF8 -Force

    # Write success telemetry
    $telemetry = @{
        ComputerName = $env:COMPUTERNAME
        Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        PrinterCount = $printers.Count
        BackupPath = $backupFile
        Success = $true
    }

    $telemetryFile = "C:\Support\Remediation-PrinterBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
    New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
    $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

    # Also create human-readable report
    $txtReport = "C:\Support\Remediation-PrinterBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
    @"
Printer Backup Remediation Report
Computer: $env:COMPUTERNAME
Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Status: SUCCESS

Printers Backed Up: $($printers.Count)
Backup Location: $backupFile

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

    $telemetryFile = "C:\Support\Remediation-PrinterBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
    New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
    $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

    exit 1
}
