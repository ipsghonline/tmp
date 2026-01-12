# Detect-PSTBackup.ps1
# Intune Proactive Remediation - Detection Script
# Purpose: Checks if PST files have been backed up to OneDrive Documents
#
# Exit Codes:
#   0 = Compliant (all PST files backed up or no PST files found)
#   1 = Non-Compliant (PST files exist but not backed up)

$oneDriveDocsPath = [Environment]::GetFolderPath('MyDocuments')
$pstBackupFolder = Join-Path $oneDriveDocsPath "IPS-Migration-PSTBackup"

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
    # No PST files found - compliant
    exit 0
}

# Check if all PST files have been backed up
if (Test-Path $pstBackupFolder) {
    $backedUpFiles = Get-ChildItem -Path $pstBackupFolder -Filter "*.pst" -File -ErrorAction SilentlyContinue

    if ($backedUpFiles.Count -ge $pstFiles.Count) {
        # All PST files appear to be backed up
        exit 0
    }
}

# PST files exist but not backed up
exit 1
