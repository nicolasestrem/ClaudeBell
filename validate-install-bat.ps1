# PowerShell validation script to verify install.bat integrity
# This script checks that install.bat contains proper batch commands
# and not corrupted content like process lists

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$InstallBat = Join-Path $ScriptDir "install.bat"

Write-Host "======================================"
Write-Host "  install.bat Integrity Validator"
Write-Host "======================================"
Write-Host ""

# Check if file exists
if (-not (Test-Path $InstallBat)) {
    Write-Host "[ERROR] install.bat not found at: $InstallBat" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] File exists: $InstallBat" -ForegroundColor Green

# Read file content
$Content = Get-Content $InstallBat -Raw

# Check for essential batch commands
$RequiredPatterns = @(
    "@echo off",
    "setlocal",
    "CLAUDE_BELL_DIR",
    "CLAUDE_SETTINGS_DIR",
    "powershell",
    "ClaudeBell"
)

Write-Host ""
Write-Host "Checking for required batch commands..."
$AllFound = $true
foreach ($pattern in $RequiredPatterns) {
    if ($Content -match [regex]::Escape($pattern)) {
        Write-Host "[OK] Found: $pattern" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Missing required pattern: $pattern" -ForegroundColor Red
        $AllFound = $false
    }
}

if (-not $AllFound) {
    exit 1
}

# Check for signs of corruption (process list output)
$CorruptionPatterns = @(
    "^\d+ \?",           # Process list format: "1234 ?"
    "^Image Name",       # tasklist header
    "^PID:",             # Process ID format
    "Session Name:"      # tasklist column
)

Write-Host ""
Write-Host "Checking for signs of corruption..."
$CorruptionFound = $false
foreach ($pattern in $CorruptionPatterns) {
    $Lines = Get-Content $InstallBat
    foreach ($line in $Lines) {
        # Skip echo and REM lines
        if ($line -notmatch "^echo" -and $line -notmatch "^REM" -and $line -match $pattern) {
            Write-Host "[WARNING] Suspicious pattern found: $pattern" -ForegroundColor Yellow
            $CorruptionFound = $true
        }
    }
}

if (-not $CorruptionFound) {
    Write-Host "[OK] No corruption patterns detected" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Potential corruption detected in install.bat" -ForegroundColor Red
    exit 1
}

# Check line count (should be around 160-170 lines)
$LineCount = (Get-Content $InstallBat).Count
if ($LineCount -lt 100 -or $LineCount -gt 200) {
    Write-Host ""
    Write-Host "[WARNING] Unexpected line count: $LineCount (expected 100-200)" -ForegroundColor Yellow
    Write-Host "          This might indicate corruption or significant changes"
} else {
    Write-Host ""
    Write-Host "[OK] Line count is reasonable: $LineCount lines" -ForegroundColor Green
}

# Check for proper batch file structure
Write-Host ""
Write-Host "Checking batch file structure..."
if ($Content -match "@echo off") {
    Write-Host "[OK] Proper batch file header found" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Missing '@echo off' header" -ForegroundColor Red
    exit 1
}

if ($Content -match ":end" -or $Content -match "goto :eof") {
    Write-Host "[OK] Proper batch file termination found" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Missing proper termination labels" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "======================================"
Write-Host "  Validation PASSED"
Write-Host "======================================"
Write-Host ""
Write-Host "install.bat appears to be valid and uncorrupted."
Write-Host ""

exit 0
