param(
    [string[]]
    $ExpectedHooks
)

# ClaudeBell Hook Validation Script
Write-Host "=== ClaudeBell Hook Validator ===" -ForegroundColor Green
Write-Host ""

# Test 1: Check Claude settings
$claudeDir = if ($env:USERPROFILE) { Join-Path $env:USERPROFILE ".claude" } else { $null }
$appDataClaudeDir = if ($env:APPDATA) { Join-Path $env:APPDATA "Claude" } else { $null }

$primarySettingsPath = if ($claudeDir) { Join-Path $claudeDir "settings.json" } else { $null }
$fallbackSettingsPaths = @(
    if ($claudeDir) { Join-Path $claudeDir "settings.local.json" },
    if ($appDataClaudeDir) { Join-Path $appDataClaudeDir "settings.json" },
    if ($appDataClaudeDir) { Join-Path $appDataClaudeDir "claude-settings.json" }
) | Where-Object { $_ }

$settingsPath = $primarySettingsPath
if ($primarySettingsPath) {
    Write-Host "Checking Claude settings (primary): $primarySettingsPath"
} else {
    Write-Host "[WARN] USERPROFILE not set. Skipping primary path lookup." -ForegroundColor Yellow
}

if (-not (Test-Path $settingsPath)) {
    $settingsPath = $null
    foreach ($candidate in $fallbackSettingsPaths) {
        Write-Host "[INFO] Searching fallback: $candidate" -ForegroundColor Cyan
        if (Test-Path $candidate) {
            $settingsPath = $candidate
            Write-Host "[INFO] Using fallback settings file: $settingsPath" -ForegroundColor Cyan
            break
        }
    }
}

if ($settingsPath -and (Test-Path $settingsPath)) {
    Write-Host "[PASS] Settings file found at: $settingsPath" -ForegroundColor Green

    $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue

    if (-not $settings) {
        Write-Host "[FAIL] Unable to parse settings file. Check for JSON errors." -ForegroundColor Red
    }
    elseif ($settings.hooks) {
        Write-Host "[PASS] Hooks section found" -ForegroundColor Green

        $detectedHooks = @()
        if ($settings.hooks -is [System.Management.Automation.PSObject]) {
            $detectedHooks = $settings.hooks.PSObject.Properties.Name | Sort-Object -Unique
        }

        $hooksToValidate = if ($ExpectedHooks -and $ExpectedHooks.Count -gt 0) {
            $ExpectedHooks
        } else {
            $detectedHooks
        }

        if (-not $hooksToValidate -or $hooksToValidate.Count -eq 0) {
            Write-Host "[WARN] No hook keys detected in settings.json" -ForegroundColor Yellow
        } else {
            Write-Host "Validating hooks: $($hooksToValidate -join ', ')"
        }

        foreach ($hook in $hooksToValidate) {
            $hookProperty = $settings.hooks.PSObject.Properties[$hook]
            $hookConfig = if ($hookProperty) { $hookProperty.Value } else { $null }
            if ($hookConfig) {
                Write-Host "[PASS] Hook '$hook' configured" -ForegroundColor Green
            } else {
                Write-Host "[WARN] Hook '$hook' missing" -ForegroundColor Yellow
            }
        }

        if ($hooksToValidate -notcontains 'Notification') {
            Write-Host "[WARN] Notification hook not detected. Permission prompts may be silent." -ForegroundColor Yellow
        }
    } else {
        Write-Host "[FAIL] No hooks configuration found" -ForegroundColor Red
    }
} else {
    Write-Host "[FAIL] Claude settings file not found in any known location" -ForegroundColor Red
    Write-Host "Run install.bat to create it" -ForegroundColor Yellow
}

Write-Host ""

# Test 2: Check sound script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$soundScriptDir = Join-Path $scriptDir "scripts"
$soundScript = Join-Path $soundScriptDir "play-sound.bat"

Write-Host "Checking sound script at: $soundScript"
if (Test-Path $soundScript) {
    Write-Host "[PASS] Sound script exists" -ForegroundColor Green
    
    # Test sound playback
    Write-Host "Testing sound playback..." -ForegroundColor Yellow
    & $soundScript "alert"
    
    Start-Sleep -Seconds 1
    Write-Host "Did you hear a sound? This validates the audio system works." -ForegroundColor Cyan
} else {
    Write-Host "[FAIL] Sound script not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Validation Complete ===" -ForegroundColor Green
Write-Host "If all tests passed, ClaudeBell should work with Claude Code hooks."
