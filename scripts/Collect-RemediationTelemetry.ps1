<#
.SYNOPSIS
    Collect Intune remediation telemetry files from local machine

.DESCRIPTION
    Gathers all Remediation-*.json files from C:\Support\ directory
    and copies them to a central collection point (file share, removable drive, etc.)

    This script is designed to be run on each device after remediation scripts have
    executed to collect telemetry data for migration tracking and troubleshooting.

.PARAMETER OutputPath
    Destination path for collected telemetry files (file share, USB drive, local folder)

.PARAMETER RemoveAfterCopy
    Remove telemetry files from local machine after successful copy

.PARAMETER IncludeTxtFiles
    Also collect human-readable .txt report files alongside JSON files

.EXAMPLE
    .\Collect-RemediationTelemetry.ps1 -OutputPath "E:\RemediationTelemetry"
    Copies all remediation JSON files to E:\RemediationTelemetry

.EXAMPLE
    .\Collect-RemediationTelemetry.ps1 -OutputPath "\\server\share\telemetry" -RemoveAfterCopy
    Copies files to network share and removes local copies

.EXAMPLE
    .\Collect-RemediationTelemetry.ps1 -OutputPath "E:\Telemetry" -IncludeTxtFiles
    Copies both JSON and TXT files to E:\Telemetry

.NOTES
    Version:        1.0
    Author:         Impact Property Solutions / Viyu MSD
    Creation Date:  January 2026
    Purpose:        Monday Go-Live Migration Support
#>

#Requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$OutputPath,

    [switch]$RemoveAfterCopy,

    [switch]$IncludeTxtFiles
)

# ============================================================================
# MAIN
# ============================================================================

$supportPath = "C:\Support"

Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Remediation Telemetry Collection Script" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Check if support directory exists
if (-not (Test-Path $supportPath)) {
    Write-Host "⚠ No C:\Support directory found" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "This usually means:" -ForegroundColor Gray
    Write-Host "  - Remediation scripts haven't been run yet" -ForegroundColor Gray
    Write-Host "  - No remediation actions were needed" -ForegroundColor Gray
    Write-Host "  - Scripts failed before creating reports" -ForegroundColor Gray
    Write-Host ""
    exit 1
}

Write-Host "✓ Found C:\Support directory" -ForegroundColor Green

# Get all remediation JSON files
$jsonFiles = Get-ChildItem -Path $supportPath -Filter "Remediation-*.json" -ErrorAction SilentlyContinue

if (-not $jsonFiles) {
    Write-Host "⚠ No remediation JSON files found" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "C:\Support exists but contains no Remediation-*.json files." -ForegroundColor Gray
    Write-Host ""
    exit 1
}

Write-Host "✓ Found $($jsonFiles.Count) JSON file(s)" -ForegroundColor Green

# Get TXT files if requested
$txtFiles = @()
if ($IncludeTxtFiles) {
    $txtFiles = Get-ChildItem -Path $supportPath -Filter "Remediation-*.txt" -ErrorAction SilentlyContinue
    if ($txtFiles) {
        Write-Host "✓ Found $($txtFiles.Count) TXT file(s)" -ForegroundColor Green
    }
}

Write-Host ""

# Ensure output directory exists
if (-not (Test-Path $OutputPath)) {
    try {
        New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null
        Write-Host "✓ Created output directory: $OutputPath" -ForegroundColor Green
    }
    catch {
        Write-Host "✗ Failed to create output directory: $_" -ForegroundColor Red
        exit 1
    }
}

# Combine all files to copy
$allFiles = $jsonFiles
if ($IncludeTxtFiles -and $txtFiles) {
    $allFiles = $jsonFiles + $txtFiles
}

# Copy files
$successCount = 0
$failCount = 0

Write-Host "Copying telemetry files..." -ForegroundColor Yellow
foreach ($file in $allFiles) {
    $destPath = Join-Path $OutputPath $file.Name

    try {
        Copy-Item -Path $file.FullName -Destination $destPath -Force -ErrorAction Stop
        Write-Host "  ✓ Copied: $($file.Name)" -ForegroundColor Green
        $successCount++

        # Remove if requested
        if ($RemoveAfterCopy) {
            Remove-Item -Path $file.FullName -Force -ErrorAction Stop
            Write-Host "    (removed from local)" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "  ✗ Failed: $($file.Name) - $_" -ForegroundColor Red
        $failCount++
    }
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Collection Summary" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Total Files:       $($allFiles.Count)" -ForegroundColor White
Write-Host "  Copied:            $successCount" -ForegroundColor Green
if ($failCount -gt 0) {
    Write-Host "  Failed:            $failCount" -ForegroundColor Red
}
Write-Host "  Destination:       $OutputPath" -ForegroundColor White
Write-Host ""

if ($successCount -gt 0) {
    Write-Host "✓ Remediation telemetry collection complete." -ForegroundColor Green
    Write-Host ""
    exit 0
} else {
    Write-Host "✗ No files were successfully copied." -ForegroundColor Red
    Write-Host ""
    exit 1
}
