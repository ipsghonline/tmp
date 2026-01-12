<#
.SYNOPSIS
    Detect OneDrive Known Folder Backup compliance

.DESCRIPTION
    Intune detection script to verify OneDrive is installed, signed in, and
    Known Folder Backup is enabled for Desktop, Documents, and Pictures.

    Exit 0 = Compliant (no remediation needed)
    Exit 1 = Non-compliant (remediation required)

.NOTES
    Version:        1.0
    Author:         Impact Property Solutions / Viyu MSD
    Creation Date:  January 2026
    Purpose:        Monday Go-Live Post-Migration Validation

    Intune Configuration:
    - Run this script using the logged-on credentials: Yes
    - Enforce script signature check: No
    - Run script in 64-bit PowerShell: Yes
#>

#Requires -Version 5.1

$ErrorActionPreference = 'SilentlyContinue'

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

function Test-OneDriveInstalled {
    $onedrivePath = "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"
    return (Test-Path $onedrivePath)
}

function Test-OneDriveRunning {
    $process = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue
    return ($null -ne $process)
}

function Get-OneDriveAccount {
    # Check for Business1 account (primary O365 account)
    $regPath = "HKCU:\Software\Microsoft\OneDrive\Accounts\Business1"

    if (Test-Path $regPath) {
        $userEmail = (Get-ItemProperty -Path $regPath -Name "UserEmail" -ErrorAction SilentlyContinue).UserEmail
        return $userEmail
    }

    return $null
}

function Test-KnownFolderBackup {
    param(
        [string]$FolderName  # "Desktop", "Documents", or "Pictures"
    )

    # Known Folder IDs
    $folderIds = @{
        "Desktop"   = "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}"
        "Documents" = "{FDD39AD0-238F-46AF-ADB4-6C85480369C7}"
        "Pictures"  = "{33E28130-4E1E-4676-835A-98395C3BC3BB}"
    }

    $folderId = $folderIds[$FolderName]
    if (-not $folderId) {
        return $false
    }

    # Check if folder is protected (backed up to OneDrive)
    $regPath = "HKCU:\Software\Microsoft\OneDrive\Accounts\Business1\ScopeIdToMountPointPathCache"

    if (-not (Test-Path $regPath)) {
        return $false
    }

    # Alternative check: Verify folder redirection to OneDrive path
    $shell = New-Object -ComObject Shell.Application
    $folder = $shell.Namespace(0).Self.Path

    # Check registry for KFM (Known Folder Move) status
    $kfmPath = "HKCU:\Software\Microsoft\OneDrive\Accounts\Business1\Tenants"

    if (Test-Path $kfmPath) {
        $tenants = Get-ChildItem -Path $kfmPath -ErrorAction SilentlyContinue

        foreach ($tenant in $tenants) {
            $folderPath = Join-Path $tenant.PSPath $folderId
            if (Test-Path $folderPath) {
                return $true
            }
        }
    }

    # Fallback: Check if special folder points to OneDrive
    $specialFolders = @{
        "Desktop"   = [Environment]::GetFolderPath("Desktop")
        "Documents" = [Environment]::GetFolderPath("MyDocuments")
        "Pictures"  = [Environment]::GetFolderPath("MyPictures")
    }

    $folderPath = $specialFolders[$FolderName]
    return ($folderPath -like "*OneDrive*")
}

function Get-OneDriveSyncStatus {
    # Check OneDrive sync state via registry
    $regPath = "HKCU:\Software\Microsoft\OneDrive\Accounts\Business1"

    if (-not (Test-Path $regPath)) {
        return "NotConfigured"
    }

    # UserFolder indicates OneDrive is set up
    $userFolder = (Get-ItemProperty -Path $regPath -Name "UserFolder" -ErrorAction SilentlyContinue).UserFolder

    if ($userFolder) {
        return "UpToDate"
    }

    return "NotConfigured"
}

# ============================================================================
# MAIN DETECTION LOGIC
# ============================================================================

$compliant = $true
$reasons = @()

# Check 1: OneDrive installed
if (-not (Test-OneDriveInstalled)) {
    $compliant = $false
    $reasons += "OneDrive not installed"
}

# Check 2: OneDrive running
if (-not (Test-OneDriveRunning)) {
    $compliant = $false
    $reasons += "OneDrive not running"
}

# Check 3: OneDrive signed in
$account = Get-OneDriveAccount
if (-not $account) {
    $compliant = $false
    $reasons += "OneDrive not signed in"
}

# Check 4: Known Folder Backup for Desktop, Documents, Pictures
$desktopKFB = Test-KnownFolderBackup -FolderName "Desktop"
$documentsKFB = Test-KnownFolderBackup -FolderName "Documents"
$picturesKFB = Test-KnownFolderBackup -FolderName "Pictures"

if (-not $desktopKFB) {
    $compliant = $false
    $reasons += "Desktop not backed up to OneDrive"
}

if (-not $documentsKFB) {
    $compliant = $false
    $reasons += "Documents not backed up to OneDrive"
}

if (-not $picturesKFB) {
    $compliant = $false
    $reasons += "Pictures not backed up to OneDrive"
}

# Check 5: OneDrive sync status
$syncStatus = Get-OneDriveSyncStatus
if ($syncStatus -ne "UpToDate") {
    $compliant = $false
    $reasons += "OneDrive sync not configured"
}

# ============================================================================
# OUTPUT AND EXIT
# ============================================================================

if ($compliant) {
    Write-Host "Compliant: OneDrive Known Folder Backup enabled for all folders"
    exit 0
} else {
    Write-Host "Non-compliant: $($reasons -join '; ')"
    exit 1
}
