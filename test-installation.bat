@echo off
setlocal enabledelayedexpansion

echo.
echo ===============================================
echo        ClaudeBell Installation Test
echo ===============================================
echo.

REM Test 1: Check if script directory exists
echo [TEST 1] Checking ClaudeBell directory structure...
set "CLAUDE_BELL_DIR=%~dp0"
set "CLAUDE_BELL_DIR=%CLAUDE_BELL_DIR:~0,-1%"

if exist "%CLAUDE_BELL_DIR%\scripts\play-sound.bat" (
    echo [PASS] play-sound.bat found
) else (
    echo [FAIL] play-sound.bat not found
    goto :test_failed
)

if exist "%CLAUDE_BELL_DIR%\sounds" (
    echo [PASS] sounds directory found
) else (
    echo [FAIL] sounds directory not found
    goto :test_failed
)

REM Test 2: Check Claude settings
echo.
echo [TEST 2] Checking Claude Code settings...
set "CLAUDE_SETTINGS=%APPDATA%\Claude\settings.json"

if exist "%CLAUDE_SETTINGS%" (
    echo [PASS] Claude settings.json found at %CLAUDE_SETTINGS%
    
    REM Check if hooks are configured
    findstr /C:"user-prompt-submit" "%CLAUDE_SETTINGS%" >nul
    if !ERRORLEVEL! == 0 (
        echo [PASS] Hooks configuration found
    ) else (
        echo [WARN] Hooks not configured - run install.bat
    )
) else (
    echo [FAIL] Claude settings.json not found
    echo [INFO] Run install.bat to create configuration
)

REM Test 3: Test sound playback
echo.
echo [TEST 3] Testing sound playback...
echo Testing alert sound in 3 seconds...
timeout /t 3 /nobreak >nul

call "%CLAUDE_BELL_DIR%\scripts\play-sound.bat" alert
echo Did you hear the sound? (Press any key to continue)
pause >nul

echo.
echo Testing success sound...
call "%CLAUDE_BELL_DIR%\scripts\play-sound.bat" success
echo Did you hear the success sound? (Press any key to continue)
pause >nul

REM Test 4: Check for custom sounds
echo.
echo [TEST 4] Checking for custom sound files...
if exist "%CLAUDE_BELL_DIR%\sounds\bip.wav" (
    echo [PASS] Custom bip.wav found
) else (
    echo [INFO] No custom bip.wav - using system sounds
)

if exist "%CLAUDE_BELL_DIR%\sounds\notify.wav" (
    echo [PASS] Custom notify.wav found
) else (
    echo [INFO] No custom notify.wav - using system sounds
)

REM Test 5: Verify paths in settings
echo.
echo [TEST 5] Verifying hook paths...
if exist "%CLAUDE_SETTINGS%" (
    findstr /C:"%CLAUDE_BELL_DIR%" "%CLAUDE_SETTINGS%" >nul
    if !ERRORLEVEL! == 0 (
        echo [PASS] Correct paths found in settings
    ) else (
        echo [WARN] Paths might be incorrect in settings
        echo [INFO] Expected path: %CLAUDE_BELL_DIR%
    )
) else (
    echo [SKIP] No settings file to check
)

echo.
echo ===============================================
echo        Test Results Summary
echo ===============================================
echo.
echo If all tests passed:
echo 1. Restart Claude Code
echo 2. Try commands that trigger permission prompts
echo 3. You should hear notification sounds
echo.
echo Troubleshooting tips:
echo - Ensure volume is turned up
echo - Check Windows sound settings
echo - Test manual sound with: scripts\play-sound.bat alert
echo.
goto :end

:test_failed
echo.
echo ===============================================
echo        Installation Issues Detected
echo ===============================================
echo.
echo Please run install.bat to fix the installation
echo.

:end
pause