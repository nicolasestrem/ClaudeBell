# ClaudeBell Hook Validation Script
Write-Host "=== ClaudeBell Hook Validator ===" -ForegroundColor Green
Write-Host ""

# Test 1: Check Claude settings
$settingsPath = "$env:APPDATA\Claude\settings.json"
Write-Host "Checking Claude settings at: $settingsPath"

if (Test-Path $settingsPath) {
    Write-Host "[PASS] Settings file exists" -ForegroundColor Green
    
    $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
    
    if ($settings.hooks) {
        Write-Host "[PASS] Hooks section found" -ForegroundColor Green
        
        $expectedHooks = @('user-prompt-submit', 'assistant-response-complete', 'tool-call-start', 'tool-call-complete')
        foreach ($hook in $expectedHooks) {
            if ($settings.hooks.$hook) {
                Write-Host "[PASS] Hook '$hook' configured" -ForegroundColor Green
            } else {
                Write-Host "[WARN] Hook '$hook' missing" -ForegroundColor Yellow
            }
        }
    } else {
        Write-Host "[FAIL] No hooks configuration found" -ForegroundColor Red
    }
} else {
    Write-Host "[FAIL] Claude settings file not found" -ForegroundColor Red
    Write-Host "Run install.bat to create it" -ForegroundColor Yellow
}

Write-Host ""

# Test 2: Check sound script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$soundScript = Join-Path $scriptDir "scripts\play-sound.bat"

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