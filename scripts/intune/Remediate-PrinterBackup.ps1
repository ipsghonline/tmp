# Remediate-PrinterBackup.ps1
# Intune Proactive Remediation - Remediation Script
# Purpose: Exports all printers to OneDrive Documents for backup
#
# Exit Codes:
#   0 = Success (backup created or backed off safely)
#   1 = Failure (unexpected error)

# High-Risk Detection: Check OneDrive Health
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

        # Write telemetry
        $telemetry = @{
            ComputerName = $env:COMPUTERNAME
            Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
            BackedOff = $true
            Reason = "OneDrive process not running"
            RiskLevel = "High"
            ActionRequired = "Start OneDrive and sign in"
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

        $telemetry = @{
            ComputerName = $env:COMPUTERNAME
            Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
            BackedOff = $true
            Reason = "Insufficient disk space (< 1GB)"
            RiskLevel = "High"
            ActionRequired = "Free up disk space"
            FreeSpaceMB = [math]::Round($freeSpace / 1MB, 0)
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

        $telemetry = @{
            ComputerName = $env:COMPUTERNAME
            Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
            BackedOff = $true
            Reason = "Print Spooler service not running"
            RiskLevel = "High"
            ActionRequired = "Start Print Spooler service"
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

        $telemetry = @{
            ComputerName = $env:COMPUTERNAME
            Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
            BackedOff = $true
            Reason = "Excessive printer count (>50)"
            RiskLevel = "High"
            ActionRequired = "Contact IT for manual backup"
            PrinterCount = $printers.Count
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
