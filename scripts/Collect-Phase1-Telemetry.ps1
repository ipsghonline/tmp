<#
.SYNOPSIS
    Collect Phase 1 telemetry files from local machine

.DESCRIPTION
    Gathers all Phase1-Events-*.json files from the standard telemetry location
    and copies them to a central collection point (file share, removable drive, etc.)

    This script is designed to be run on each user machine after Phase 1 backup
    to collect telemetry data for migration tracking and troubleshooting.

.PARAMETER OutputPath
    Destination path for collected telemetry files (file share, USB drive, local folder)

.PARAMETER RemoveAfterCopy
    Remove telemetry files from local machine after successful copy

.EXAMPLE
    .\Collect-Phase1-Telemetry.ps1 -OutputPath "E:\MigrationTelemetry"
    Copies all telemetry files to E:\MigrationTelemetry

.EXAMPLE
    .\Collect-Phase1-Telemetry.ps1 -OutputPath "\\server\share\telemetry" -RemoveAfterCopy
    Copies files to network share and removes local copies

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

    [switch]$RemoveAfterCopy
)

# ============================================================================
# MAIN
# ============================================================================

$telemetryPath = "$env:USERPROFILE\AppData\Local\IPS-Migration\Telemetry"

Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Phase 1 Telemetry Collection Script" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Check if telemetry directory exists
if (-not (Test-Path $telemetryPath)) {
    Write-Host "⚠ No telemetry directory found at: $telemetryPath" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "This usually means:" -ForegroundColor Gray
    Write-Host "  - Phase1-Backup.ps1 hasn't been run yet" -ForegroundColor Gray
    Write-Host "  - Telemetry was disabled with -TelemetryDisabled" -ForegroundColor Gray
    Write-Host "  - Script failed before telemetry could be saved" -ForegroundColor Gray
    Write-Host ""
    exit 1
}

Write-Host "✓ Found telemetry directory: $telemetryPath" -ForegroundColor Green

# Get all telemetry files
$events = Get-ChildItem -Path $telemetryPath -Filter "Phase1-Events-*.json" -ErrorAction SilentlyContinue

if (-not $events) {
    Write-Host "⚠ No telemetry files found" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Telemetry directory exists but contains no Phase1-Events-*.json files." -ForegroundColor Gray
    Write-Host ""
    exit 1
}

Write-Host "✓ Found $($events.Count) telemetry file(s)" -ForegroundColor Green
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

# Copy files
$successCount = 0
$failCount = 0

Write-Host "Copying telemetry files..." -ForegroundColor Yellow
foreach ($event in $events) {
    $destPath = Join-Path $OutputPath $event.Name

    try {
        Copy-Item -Path $event.FullName -Destination $destPath -Force -ErrorAction Stop
        Write-Host "  ✓ Copied: $($event.Name)" -ForegroundColor Green
        $successCount++

        # Remove if requested
        if ($RemoveAfterCopy) {
            Remove-Item -Path $event.FullName -Force -ErrorAction Stop
            Write-Host "    (removed from local)" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "  ✗ Failed: $($event.Name) - $_" -ForegroundColor Red
        $failCount++
    }
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Collection Summary" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Total Files:       $($events.Count)" -ForegroundColor White
Write-Host "  Copied:            $successCount" -ForegroundColor Green
if ($failCount -gt 0) {
    Write-Host "  Failed:            $failCount" -ForegroundColor Red
}
Write-Host "  Destination:       $OutputPath" -ForegroundColor White
Write-Host ""

if ($successCount -gt 0) {
    Write-Host "✓ Telemetry collection complete." -ForegroundColor Green
    Write-Host ""
    exit 0
} else {
    Write-Host "✗ No files were successfully copied." -ForegroundColor Red
    Write-Host ""
    exit 1
}
