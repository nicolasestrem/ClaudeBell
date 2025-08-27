@echo off
setlocal enabledelayedexpansion

echo.
echo ===============================================
echo   ClaudeBell Installer for Windows 11/10       
echo ===============================================
echo.

REM Check Windows version compatibility
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
echo Detected Windows version: %VERSION%
echo.

REM Get the directory where this script is located
set "CLAUDE_BELL_DIR=%~dp0"
REM Remove trailing backslash and normalize path
for %%i in ("%CLAUDE_BELL_DIR%.") do set "CLAUDE_BELL_DIR=%%~fi"

echo Installing ClaudeBell from: %CLAUDE_BELL_DIR%
echo.

REM Check for required files
echo Checking installation files...
if not exist "%CLAUDE_BELL_DIR%\scripts\play-sound.bat" (
    echo [ERROR] Missing play-sound.bat script
    goto :installation_failed
)
if not exist "%CLAUDE_BELL_DIR%\sounds" (
    echo [ERROR] Missing sounds directory
    goto :installation_failed
)
echo [OK] Installation files verified
echo.

REM Test sound playback with multiple methods
echo Testing sound playback compatibility...
echo Testing primary method...
call "%CLAUDE_BELL_DIR%\scripts\play-sound.bat" alert 2>nul
set "SOUND_TEST_1=%ERRORLEVEL%"

timeout /t 1 /nobreak >nul

echo Testing secure method...
if exist "%CLAUDE_BELL_DIR%\scripts\play-sound-secure.bat" (
    call "%CLAUDE_BELL_DIR%\scripts\play-sound-secure.bat" alert 2>nul
    set "SOUND_TEST_2=%ERRORLEVEL%"
) else (
    set "SOUND_TEST_2=1"
)

if %SOUND_TEST_1% EQU 0 (
    echo [OK] Primary sound method works
    set "SOUND_METHOD=play-sound.bat"
) else if %SOUND_TEST_2% EQU 0 (
    echo [OK] Secure sound method works
    set "SOUND_METHOD=play-sound-secure.bat"
) else (
    echo [WARN] Sound test inconclusive - proceeding anyway
    set "SOUND_METHOD=play-sound.bat"
)
echo.

REM Check if Claude settings directory exists
set "CLAUDE_SETTINGS_DIR=%APPDATA%\Claude"
if not exist "%CLAUDE_SETTINGS_DIR%" (
    echo Creating Claude settings directory...
    mkdir "%CLAUDE_SETTINGS_DIR%" 2>nul
    if not exist "%CLAUDE_SETTINGS_DIR%" (
        echo [ERROR] Failed to create Claude settings directory
        echo [INFO] You may need to run as administrator
        goto :manual_config
    )
    echo [OK] Claude settings directory created
)

REM Backup existing settings if they exist
set "SETTINGS_FILE=%CLAUDE_SETTINGS_DIR%\settings.json"
if exist "%SETTINGS_FILE%" (
    echo Backing up existing settings...
    copy "%SETTINGS_FILE%" "%SETTINGS_FILE%.backup.%date:~-4,4%%date:~-10,2%%date:~-7,2%" >nul 2>&1
    echo [OK] Existing settings backed up
)

REM Create the working settings.json configuration with normalized paths
echo Creating Claude Code hooks configuration...

REM Use the tested sound method in configuration
set "SOUND_SCRIPT=%CLAUDE_BELL_DIR%\scripts\%SOUND_METHOD%"

echo { > "%SETTINGS_FILE%"
echo   "hooks": { >> "%SETTINGS_FILE%"
echo     "user-prompt-submit": "%SOUND_SCRIPT% gentle", >> "%SETTINGS_FILE%"
echo     "assistant-response-complete": "%SOUND_SCRIPT% success", >> "%SETTINGS_FILE%"
echo     "tool-call-start": "%SOUND_SCRIPT% alert", >> "%SETTINGS_FILE%"
echo     "tool-call-complete": "%SOUND_SCRIPT% gentle" >> "%SETTINGS_FILE%"
echo   } >> "%SETTINGS_FILE%"
echo } >> "%SETTINGS_FILE%"

if exist "%SETTINGS_FILE%" (
    echo [OK] Claude Code hooks configured successfully
    echo Configuration saved to: %SETTINGS_FILE%
    echo Using sound method: %SOUND_METHOD%
) else (
    echo [ERROR] Failed to create configuration file
    goto :manual_config
)
echo.

REM Verify the configuration
echo Verifying configuration...
findstr /C:"hooks" "%SETTINGS_FILE%" >nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] Configuration syntax verified
) else (
    echo [WARN] Configuration may have issues
)
echo.

echo ===============================================
echo        Installation Complete!
echo ===============================================
echo.
echo ClaudeBell is now installed and configured for Windows 11!
echo.
echo Your custom sounds:
echo - Place WAV files in: %CLAUDE_BELL_DIR%\sounds\
echo - Primary sound file: bip.wav
echo - Secondary sound file: notify.wav
echo - Fallback: Windows system sounds
echo.
echo Sound notifications will trigger on:
echo - Permission prompts and errors (most reliable)
echo - User input and tool execution (may vary)
echo.
echo Next steps:
echo 1. Restart Claude Code completely
echo 2. Test with commands that require permissions
echo 3. Adjust volume if needed
echo.
echo Troubleshooting:
echo - Run test-installation.bat to verify setup
echo - Check Windows sound settings if no audio
echo - Ensure your audio device is working
echo.
goto :end

:installation_failed
echo.
echo ===============================================
echo        Installation Failed
echo ===============================================
echo.
echo Please check:
echo 1. All required files are present
echo 2. You have write permissions to %APPDATA%\Claude
echo 3. Run as administrator if needed
echo.
goto :end

:manual_config
echo.
echo ===============================================
echo        Manual Configuration Required
echo ===============================================
echo.
echo Automatic installation failed. Please manually create:
echo %APPDATA%\Claude\settings.json
echo.
echo With this content:
echo.
echo {
echo   "hooks": {
echo     "user-prompt-submit": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat gentle",
echo     "assistant-response-complete": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat success",
echo     "tool-call-start": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat alert",
echo     "tool-call-complete": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat gentle"
echo   }
echo }
echo.

:end
echo Press any key to exit...
pause >nul