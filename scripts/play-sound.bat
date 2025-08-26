@echo off
setlocal

REM ClaudeBell - Windows Sound Player
REM Plays notification sounds for Claude Code

set "SOUND_TYPE=%~1"
if "%SOUND_TYPE%"=="" set "SOUND_TYPE=default"

set "SCRIPT_DIR=%~dp0"
set "SOUNDS_DIR=%SCRIPT_DIR%..\sounds"

REM Map sound types to files
if "%SOUND_TYPE%"=="alert" (
    set "SOUND_FILE=%SOUNDS_DIR%\alert.wav"
) else if "%SOUND_TYPE%"=="success" (
    set "SOUND_FILE=%SOUNDS_DIR%\success.wav"
) else if "%SOUND_TYPE%"=="error" (
    set "SOUND_FILE=%SOUNDS_DIR%\error.wav"
) else if "%SOUND_TYPE%"=="gentle" (
    set "SOUND_FILE=%SOUNDS_DIR%\gentle-chime.wav"
) else (
    set "SOUND_FILE=%SOUNDS_DIR%\default.wav"
)

REM Check if sound file exists, if not use system sound
if exist "%SOUND_FILE%" (
    powershell -Command "(New-Object System.Media.SoundPlayer '%SOUND_FILE%').PlaySync()"
) else (
    REM Use Windows system notification sound as fallback
    powershell -Command "[System.Media.SystemSounds]::Asterisk.Play()"
)

endlocal