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
call "%CLAUDE_BELL_DIR%\scripts\play-sound.bat" alert
timeout /t 2 /nobreak >nul
echo.

REM Check if Claude settings directory exists
set "CLAUDE_SETTINGS_DIR=%APPDATA%\Claude"
if not exist "%CLAUDE_SETTINGS_DIR%" (
    echo Creating Claude settings directory...
    mkdir "%CLAUDE_SETTINGS_DIR%"
)

REM Create the working settings.json configuration
set "SETTINGS_FILE=%CLAUDE_SETTINGS_DIR%\settings.json"
echo Creating Claude Code hooks configuration...

echo { > "%SETTINGS_FILE%"
echo   "hooks": { >> "%SETTINGS_FILE%"
echo     "UserPromptSubmit": [{ >> "%SETTINGS_FILE%"
echo       "hooks": [{ >> "%SETTINGS_FILE%"
echo         "type": "command", >> "%SETTINGS_FILE%"
echo         "command": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat gentle" >> "%SETTINGS_FILE%"
echo       }] >> "%SETTINGS_FILE%"
echo     }], >> "%SETTINGS_FILE%"
echo     "Stop": [{ >> "%SETTINGS_FILE%"
echo       "hooks": [{ >> "%SETTINGS_FILE%"
echo         "type": "command", >> "%SETTINGS_FILE%"
echo         "command": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat success" >> "%SETTINGS_FILE%"
echo       }] >> "%SETTINGS_FILE%"
echo     }], >> "%SETTINGS_FILE%"
echo     "PreToolUse": [{ >> "%SETTINGS_FILE%"
echo       "hooks": [{ >> "%SETTINGS_FILE%"
echo         "type": "command", >> "%SETTINGS_FILE%"
echo         "command": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat alert" >> "%SETTINGS_FILE%"
echo       }] >> "%SETTINGS_FILE%"
echo     }], >> "%SETTINGS_FILE%"
echo     "PostToolUse": [{ >> "%SETTINGS_FILE%"
echo       "hooks": [{ >> "%SETTINGS_FILE%"
echo         "type": "command", >> "%SETTINGS_FILE%"
echo         "command": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat gentle" >> "%SETTINGS_FILE%"
echo       }] >> "%SETTINGS_FILE%"
echo     }], >> "%SETTINGS_FILE%"
echo     "Notification": [{ >> "%SETTINGS_FILE%"
echo       "hooks": [{ >> "%SETTINGS_FILE%"
echo         "type": "command", >> "%SETTINGS_FILE%"
echo         "command": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat alert" >> "%SETTINGS_FILE%"
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
echo - Primary sound file: bip.wav
echo - Fallback: Windows system sounds
echo.
echo Sound notifications will trigger on:
echo - Permission prompts and errors (most reliable)
echo - User input and tool execution (may vary)
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
echo     "UserPromptSubmit": [{
echo       "hooks": [{
echo         "type": "command",
echo         "command": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat gentle"
echo       }]
echo     }],
echo     "Stop": [{
echo       "hooks": [{
echo         "type": "command",
echo         "command": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat success"
echo       }]
echo     }],
echo     "PreToolUse": [{
echo       "hooks": [{
echo         "type": "command",
echo         "command": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat alert"
echo       }]
echo     }],
echo     "PostToolUse": [{
echo       "hooks": [{
echo         "type": "command",
echo         "command": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat gentle"
echo       }]
echo     }],
echo     "Notification": [{
echo       "hooks": [{
echo         "type": "command",
echo         "command": "%CLAUDE_BELL_DIR%\\scripts\\play-sound.bat alert"
echo       }]
echo     }]
echo   }
echo }
echo.

:end
pause