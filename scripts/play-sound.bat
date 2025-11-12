@echo off
setlocal

REM ClaudeBell - Windows Sound Player
REM Plays notification sounds for Claude Code

set "SOUND_TYPE=%~1"
if "%SOUND_TYPE%"=="" set "SOUND_TYPE=default"
set "SOUND_TYPE=%SOUND_TYPE:~0,32%"
for %%I in ("%SOUND_TYPE%") do set "SOUND_TYPE=%%~I"

set "SCRIPT_DIR=%~dp0"
set "SOUNDS_DIR=%SCRIPT_DIR%..\sounds"

REM Map sound types to appropriate files
if /I "%SOUND_TYPE%"=="alert" (
    set "SOUND_FILE=%SOUNDS_DIR%\alert.wav"
) else if /I "%SOUND_TYPE%"=="success" (
    set "SOUND_FILE=%SOUNDS_DIR%\success.wav"
) else if /I "%SOUND_TYPE%"=="error" (
    set "SOUND_FILE=%SOUNDS_DIR%\error.wav"
) else if /I "%SOUND_TYPE%"=="gentle" (
    set "SOUND_FILE=%SOUNDS_DIR%\gentle-chime.wav"
) else (
    set "SOUND_FILE=%SOUNDS_DIR%\default.wav"
)

REM Determine which sound file can actually be used
set "FALLBACK_FILE=%SOUNDS_DIR%\default.wav"
if not exist "%SOUND_FILE%" set "SOUND_FILE="
if not defined SOUND_FILE if exist "%FALLBACK_FILE%" set "SOUND_FILE=%FALLBACK_FILE%"

if defined SOUND_FILE (
    REM Play asynchronously so Claude Code is not blocked
    powershell -NoProfile -ExecutionPolicy Bypass -Command "try { (New-Object System.Media.SoundPlayer '%SOUND_FILE%').Play() } catch { [System.Media.SystemSounds]::Asterisk.Play() }" >nul 2>&1
) else (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Media.SystemSounds]::Asterisk.Play()" >nul 2>&1
)

endlocal
