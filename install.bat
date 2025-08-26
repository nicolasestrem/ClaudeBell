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

REM Test sound playback
echo Testing sound playback...
call "%CLAUDE_BELL_DIR%\scripts\play-sound.bat" default
echo.

REM Create user environment variables
echo Setting environment variables...
setx CLAUDE_BELL_DIR "%CLAUDE_BELL_DIR%" >nul 2>&1
setx CLAUDE_BELL_EXT "bat" >nul 2>&1

if %ERRORLEVEL% == 0 (
    echo [OK] Environment variables set successfully
) else (
    echo [WARNING] Could not set environment variables automatically
    echo.
    echo Please add these manually to your environment:
    echo CLAUDE_BELL_DIR=%CLAUDE_BELL_DIR%
    echo CLAUDE_BELL_EXT=bat
)
echo.

REM Instructions for Claude Code configuration
echo ===============================================
echo        Next Steps - Configure Claude Code     
echo ===============================================
echo.
echo 1. Run: claude config edit
echo.
echo 2. Add the following hooks configuration:
echo.
echo {
echo   "hooks": {
echo     "Notification": [{
echo       "hooks": [{
echo         "type": "command",
echo         "command": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat alert"
echo       }]
echo     }],
echo     "Stop": [{
echo       "hooks": [{
echo         "type": "command",  
echo         "command": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat success"
echo       }]
echo     }],
echo     "Error": [{
echo       "hooks": [{
echo         "type": "command",
echo         "command": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat error"
echo       }]
echo     }]
echo   }
echo }
echo.
echo 3. Save and close the configuration file
echo.
echo 4. Test by asking Claude Code something that requires permission
echo.
echo ===============================================
echo        Installation Complete!
echo ===============================================
echo.
pause