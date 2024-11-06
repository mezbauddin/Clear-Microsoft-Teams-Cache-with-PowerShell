# Microsoft 365 Cache Cleaner

## Overview

**Microsoft 365 Cache Cleaner** is a PowerShell script that allows users to clear cache for commonly used Microsoft 365 applications. Cache files can sometimes cause performance issues, login errors, or unexpected behavior in applications. This script helps refresh these applications by clearing out old cache files. It stops the application, clears specified cache directories, and optionally restarts the application.

## Why Use It?

Clearing the cache can resolve issues such as:
- Lag or slow performance
- Login problems
- Unexpected app behavior (e.g., missing or outdated data)

If you’re experiencing any of these issues with your Microsoft 365 apps, running this script can provide a quick and easy fix without reinstalling the application.

## Supported Applications

The script supports cache clearing for the following Microsoft 365 applications:
1. Microsoft Teams
2. OneDrive
3. Outlook
4. Microsoft Edge
5. Microsoft Word
6. Microsoft Excel
7. Microsoft OneNote

## How to Use

1. **Download the script**: [Microsoft365CacheCleaner.ps1](link-to-script)
2. **Run the script**: Open PowerShell as an administrator and run the script.
3. **Select an application**: You’ll be prompted to select an application from the list.
4. **Cache Clearing**: The script will stop the application, clear cache files, and restart the application.

> **Note**: Ensure any unsaved work is saved before running the script, as it will stop the selected application.

## Script Details

### Parameters

- **appName**: The name of the application.
- **processName**: The process name used to stop the application.
- **cachePath**: The cache directory for the application.
- **executablePath**: The path to the application’s executable file.
- **arguments**: Arguments required to start the application (if any).

## Author

**Mezba Uddin**

## Version

- **1.0**
- **Last Updated**: 2024-11-06

---

### Full Script: Microsoft365CacheCleaner.ps1

```powershell
<#
.SCRIPT NAME
    Microsoft 365 Cache Cleaner

.SYNOPSIS
    PowerShell script to clear cache for selected Microsoft 365 applications.

.DESCRIPTION
    This script allows users to clear cache for commonly used Microsoft 365 applications.
    Cache files can sometimes cause performance issues, login errors, or unexpected
    behavior in applications. Running this script helps refresh these applications 
    by clearing out old cache files. It stops the application, clears specified cache 
    directories, and optionally restarts the application.

.AUTHOR
    Mezba Uddin

.VERSION
    1.0

.LASTUPDATED
    2024-11-06

.NOTES
    - No additional modules are required for this script.
    - Make sure to save any work in the application before running the script, as it
      will stop the application.
    - This script is especially useful if you're experiencing lag, login issues, 
      or unexpected behavior in Microsoft 365 apps.

#>

# Define a function to clear cache for the selected application
function Clear-Cache {
    param (
        [string]$appName,
        [string]$processName,
        [string]$cachePath,
        [string]$executablePath,
        [string[]]$arguments = @()
    )

    # Stop the application if it's running
    Write-Host "Stopping $appName..."
    Get-Process $processName -ErrorAction SilentlyContinue | Stop-Process -Force

    # Define cache folders to delete (customize for each app as needed)
    $foldersToClear = @(
        "\Cache",
        "\GPUCache",
        "\Temporary Files",
        "\IndexedDB",
        "\Local Storage"
    )

    # Clear cache files
    foreach ($folder in $foldersToClear) {
        $fullPath = "$cachePath$folder"
        if (Test-Path $fullPath) {
            Write-Host "Clearing cache at $fullPath..."
            Remove-Item -Path $fullPath -Recurse -Force
        } else {
            Write-Host "$fullPath not found."
        }
    }

    # Restart the application if an executable path is provided
    if ($executablePath) {
        Write-Host "Restarting $appName..."
        if ($arguments -and $arguments.Count -gt 0) {
            Start-Process -FilePath $executablePath -ArgumentList $arguments
        } else {
            Start-Process -FilePath $executablePath
        }
    }

    Write-Host "$appName cache cleared successfully."
}

# Define options for Microsoft 365 applications in the desired order
$appOptions = @{
    "1" = @{ Name = "Microsoft Teams"; ProcessName = "Teams"; CachePath = "$env:APPDATA\Microsoft\Teams"; ExecutablePath = "$env:LOCALAPPDATA\Microsoft\Teams\Update.exe"; Arguments = @("--processStart", "Teams.exe") }
    "2" = @{ Name = "OneDrive"; ProcessName = "OneDrive"; CachePath = "$env:LOCALAPPDATA\Microsoft\OneDrive"; ExecutablePath = "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"; Arguments = @() }
    "3" = @{ Name = "Outlook"; ProcessName = "OUTLOOK"; CachePath = "$env:LOCALAPPDATA\Microsoft\Outlook"; ExecutablePath = "outlook.exe"; Arguments = @() }
    "4" = @{ Name = "Microsoft Edge"; ProcessName = "msedge"; CachePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default"; ExecutablePath = "msedge.exe"; Arguments = @() }
    "5" = @{ Name = "Microsoft Word"; ProcessName = "WINWORD"; CachePath = "$env:LOCALAPPDATA\Microsoft\Office\Word"; ExecutablePath = "winword.exe"; Arguments = @() }
    "6" = @{ Name = "Microsoft Excel"; ProcessName = "EXCEL"; CachePath = "$env:LOCALAPPDATA\Microsoft\Office\Excel"; ExecutablePath = "excel.exe"; Arguments = @() }
    "7" = @{ Name = "Microsoft OneNote"; ProcessName = "ONENOTE"; CachePath = "$env:LOCALAPPDATA\Microsoft\OneNote"; ExecutablePath = "onenote.exe"; Arguments = @() }
}

# Display options for user selection in correct order
Write-Host "Select a Microsoft 365 application to clear its cache:"
foreach ($key in $appOptions.Keys) {
    Write-Host "$key. $($appOptions[$key].Name)"
}

# Get user selection
$selection = Read-Host "Enter the number of your choice"

if ($appOptions.ContainsKey($selection)) {
    $app = $appOptions[$selection]
    Clear-Cache -appName $app.Name -processName $app.ProcessName -cachePath $app.CachePath -executablePath $app.ExecutablePath -arguments $app.Arguments
} else {
    Write-Host "Invalid selection. Please run the script again and select a valid option."
}
