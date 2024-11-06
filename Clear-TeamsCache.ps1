# Stop Microsoft Teams
Get-Process Teams -ErrorAction SilentlyContinue | Stop-Process -Force

# Define Teams cache location
$TeamsCachePath = "$env:APPDATA\Microsoft\Teams"

# List of directories within Teams cache that you may want to clear
$foldersToClear = @(
    "\Application Cache\Cache",
    "\Blob_storage",
    "\Cache",
    "\databases",
    "\GPUCache",
    "\IndexedDB",
    "\Local Storage",
    "\tmp"
)

# Remove cache folders
foreach ($folder in $foldersToClear) {
    $fullPath = "$TeamsCachePath$folder"
    if (Test-Path $fullPath) {
        Remove-Item -Path $fullPath -Recurse -Force
    }
}

# Optionally, restart Microsoft Teams
Start-Process "$env:LOCALAPPDATA\Microsoft\Teams\Update.exe" --processStart "Teams.exe"
