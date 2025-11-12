@echo off
setlocal enabledelayedexpansion

echo.
echo ===============================================
echo        ClaudeBell Installer for Windows       
echo ===============================================
echo.

REM Get the directory where this script is located
set "CLAUDE_BELL_DIR=%~dp0"
REM Remove trailing backslash
set "CLAUDE_BELL_DIR=%CLAUDE_BELL_DIR:~0,-1%"

echo Installing ClaudeBell from: %CLAUDE_BELL_DIR%
echo.

REM Test sound playback using PowerShell system sounds
echo Testing Windows system sounds...
powershell -c "[System.Media.SystemSounds]::Exclamation.Play()"
powershell -Command "Start-Sleep -Seconds 1"
powershell -c "[System.Media.SystemSounds]::Asterisk.Play()"
powershell -Command "Start-Sleep -Seconds 1"
powershell -c "[System.Media.SystemSounds]::Hand.Play()"
echo.

REM Check if Claude settings directory exists
set "CLAUDE_SETTINGS_DIR=%USERPROFILE%\.claude"
if not exist "%CLAUDE_SETTINGS_DIR%" (
    echo Creating Claude settings directory...
    mkdir "%CLAUDE_SETTINGS_DIR%"
)

REM Check for existing configurations and warn user
echo.
echo ===============================================
echo        Configuration Conflict Check        
echo ===============================================
echo.
set "CONFIG_CONFLICTS=0"

REM Check main global config
if exist "%USERPROFILE%\.claude\settings.json" (
    echo [WARNING] Found existing config: %USERPROFILE%\.claude\settings.json
    set /a CONFIG_CONFLICTS+=1
)

REM Check other potential config locations
if exist "%USERPROFILE%\.claude\settings.local.json" (
    echo [WARNING] Found existing config: %USERPROFILE%\.claude\settings.local.json
    set /a CONFIG_CONFLICTS+=1
)

if exist "%APPDATA%\Claude\claude-settings.json" (
    echo [WARNING] Found existing config: %APPDATA%\Claude\claude-settings.json
    set /a CONFIG_CONFLICTS+=1
)

if exist "config\claude-settings.json" (
    echo [WARNING] Found existing config: config\claude-settings.json
    set /a CONFIG_CONFLICTS+=1
)

if %CONFIG_CONFLICTS% GTR 0 (
    echo.
    echo [CRITICAL] Found %CONFIG_CONFLICTS% existing configuration file(s)!
    echo.
    echo Multiple config files can cause hook conflicts and excessive notifications.
    echo This installer will create: %APPDATA%\Claude\settings.json
    echo.
    echo RECOMMENDATION: Clean up conflicting configs after installation.
    echo See CLAUDE.md for the full troubleshooting guide.
    echo.
    pause
    echo.
)

REM Create the working settings.json configuration
set "SETTINGS_FILE=%CLAUDE_SETTINGS_DIR%\settings.json"
echo Creating minimal Claude Code hooks configuration...

echo { > "%SETTINGS_FILE%"
echo   "hooks": { >> "%SETTINGS_FILE%"
echo     "Notification": [{ >> "%SETTINGS_FILE%"
echo       "hooks": [{ >> "%SETTINGS_FILE%"
echo         "type": "command", >> "%SETTINGS_FILE%"
echo         "command": "powershell.exe -c \"[System.Media.SystemSounds]::Exclamation.Play()\"" >> "%SETTINGS_FILE%"
echo       }] >> "%SETTINGS_FILE%"
echo     }] >> "%SETTINGS_FILE%"
echo   } >> "%SETTINGS_FILE%"
echo } >> "%SETTINGS_FILE%"

if exist "%SETTINGS_FILE%" (
    echo [OK] Claude Code hooks configured successfully
    echo Configuration saved to: %SETTINGS_FILE%
) else (
    echo [ERROR] Failed to create configuration file
    goto :manual_config
)
echo.

echo ===============================================
echo        Installation Complete!
echo ===============================================
echo.
echo ClaudeBell is now installed and configured!
echo.
echo Your custom sounds:
echo - Place WAV files in: %CLAUDE_BELL_DIR%\sounds\
echo - Optional files in sounds\ (alert.wav, success.wav, error.wav, gentle-chime.wav, default.wav)
echo - Missing files automatically fall back to Windows system sounds
echo.
echo Sound notifications will trigger on:
echo - Permission prompts and errors ONLY (minimal configuration)
echo.
echo ===============================================
echo        Post-Installation Notes
echo ===============================================
echo.
echo If you experience excessive notifications:
echo 1. Check ~/.claude/settings.json (main global config)
echo 2. Remove hooks from other config files 
echo 3. See CLAUDE.md troubleshooting section
echo.
echo Configuration priority (highest to lowest):
echo 1. %USERPROFILE%\.claude\settings.json
echo 2. %USERPROFILE%\.claude\settings.local.json  
echo 3. %APPDATA%\Claude\settings.json (this installer)
echo 4. %APPDATA%\Claude\claude-settings.json
echo 5. Project-specific configs
echo.
echo Restart Claude Code to activate the hooks.
echo.
goto :end

:manual_config
echo.
echo ===============================================
echo        Manual Configuration Required
echo ===============================================
echo.
echo Please manually create: %APPDATA%\Claude\settings.json
echo.
echo With this content:
echo.
echo {
echo   "hooks": {
echo     "Notification": [{
echo       "hooks": [{
echo         "type": "command",
echo         "command": "powershell.exe -c \"[System.Media.SystemSounds]::Exclamation.Play()\""
echo       }]
echo     }]
echo   }
echo }
echo.

:end
pause