# Remediate-WiFiBackup.ps1
# Intune Proactive Remediation - Remediation Script
# Purpose: Captures current WiFi SSID and saves to OneDrive Documents
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
        $warningFile = Join-Path $oneDriveDocsPath "IPS-Migration-WARNING-WiFiBackup.txt"
        $warningMessage = @"
Impact Property Solutions - Migration Warning
Script: WiFi Backup
Computer: $env:COMPUTERNAME
Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

WARNING: OneDrive is not running. WiFi backup cannot be synchronized to the cloud.

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

        $telemetryFile = "C:\Support\Remediation-WiFiBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
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

        $telemetryFile = "C:\Support\Remediation-WiFiBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
        $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

        exit 0
    }

    # Check 3: Sufficient disk space (at least 1GB free)
    $drive = (Get-Item $oneDriveDocsPath).PSDrive
    $freeSpace = (Get-PSDrive $drive.Name).Free
    if ($freeSpace -lt 1GB) {
        # BACK OFF: Insufficient disk space
        $warningFile = Join-Path $oneDriveDocsPath "IPS-Migration-WARNING-WiFiBackup.txt"
        $warningMessage = @"
Impact Property Solutions - Migration Warning
Script: WiFi Backup
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

        $telemetryFile = "C:\Support\Remediation-WiFiBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
        $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

        exit 0
    }

    # High-Risk Detection: WiFi-Specific Checks

    # Check 4: Wireless service is available
    $wlanService = Get-Service -Name "WlanSvc" -ErrorAction SilentlyContinue
    if (-not $wlanService -or $wlanService.Status -ne "Running") {
        # BACK OFF: No wireless capability - this is not applicable
        $backupFile = Join-Path $oneDriveDocsPath "IPS-Migration-WiFiSSID.txt"
        $output = @"
Impact Property Solutions - WiFi SSID Backup
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Computer: $env:COMPUTERNAME

Status: Not applicable - No WiFi hardware detected or wireless service not running.
This device may be using Ethernet connection only.
"@
        $output | Out-File -FilePath $backupFile -Encoding UTF8 -Force

        $telemetry = @{
            ComputerName = $env:COMPUTERNAME
            Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
            BackedOff = $true
            Reason = "No WiFi hardware or wireless service not running"
            RiskLevel = "Low"
            ActionRequired = "None - Not applicable"
            Success = $true
        }

        $telemetryFile = "C:\Support\Remediation-WiFiBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
        $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

        exit 0
    }

    # All checks passed - proceed with WiFi SSID capture
    $backupFile = Join-Path $oneDriveDocsPath "IPS-Migration-WiFiSSID.txt"

    $wifiInfo = netsh wlan show interfaces 2>$null

    if ($wifiInfo) {
        $ssidLine = $wifiInfo | Select-String -Pattern "^\s+SSID\s+:\s+(.+)$"
        if ($ssidLine) {
            $ssid = $ssidLine.Matches[0].Groups[1].Value.Trim()

            $output = @"
Impact Property Solutions - WiFi SSID Backup
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Computer: $env:COMPUTERNAME

Current WiFi Network: $ssid

NOTE: This information will help reconnect to your WiFi network after migration.
"@

            $output | Out-File -FilePath $backupFile -Encoding UTF8 -Force

            # Write success telemetry
            $telemetry = @{
                ComputerName = $env:COMPUTERNAME
                Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
                SSID = $ssid
                BackupPath = $backupFile
                Success = $true
            }

            $telemetryFile = "C:\Support\Remediation-WiFiBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
            New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
            $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

            # Also create human-readable report
            $txtReport = "C:\Support\Remediation-WiFiBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
            @"
WiFi Backup Remediation Report
Computer: $env:COMPUTERNAME
Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Status: SUCCESS

WiFi SSID Captured: $ssid
Backup Location: $backupFile

This backup is automatically synchronized to OneDrive and will be available after migration.
"@ | Out-File -FilePath $txtReport -Encoding UTF8

            exit 0
        }
    }

    # Not connected to WiFi - this is not an error, just not applicable
    $output = @"
Impact Property Solutions - WiFi SSID Backup
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Computer: $env:COMPUTERNAME

Status: Not connected to WiFi (Ethernet connection or no network).

NOTE: If you normally use WiFi, please connect to your WiFi network and this script will capture the SSID automatically.
"@

    $output | Out-File -FilePath $backupFile -Encoding UTF8 -Force

    $telemetry = @{
        ComputerName = $env:COMPUTERNAME
        Timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        BackedOff = $true
        Reason = "Not connected to WiFi network"
        RiskLevel = "Low"
        ActionRequired = "Connect to WiFi if applicable"
        Success = $true
    }

    $telemetryFile = "C:\Support\Remediation-WiFiBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
    New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
    $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

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

    $telemetryFile = "C:\Support\Remediation-WiFiBackup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
    New-Item -Path "C:\Support" -ItemType Directory -Force | Out-Null
    $telemetry | ConvertTo-Json | Out-File -FilePath $telemetryFile -Encoding UTF8

    exit 1
}
