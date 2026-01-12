# Detect-WiFiBackup.ps1
# Intune Proactive Remediation - Detection Script
# Purpose: Checks if WiFi SSID backup file exists in OneDrive Documents
#
# Exit Codes:
#   0 = Compliant (backup exists and is recent)
#   1 = Non-Compliant (no backup or backup is stale)

$oneDriveDocsPath = [Environment]::GetFolderPath('MyDocuments')
$backupFile = Join-Path $oneDriveDocsPath "IPS-Migration-WiFiSSID.txt"

if (Test-Path $backupFile) {
    $fileAge = (Get-Date) - (Get-Item $backupFile).LastWriteTime
    if ($fileAge.Days -lt 7) {
        # Backup is recent
        exit 0
    }
}

# No backup or stale backup
exit 1
