@echo off
setlocal

REM ClaudeBell - Windows Sound Player
REM Plays notification sounds for Claude Code

set "SOUND_TYPE=%~1"
if "%SOUND_TYPE%"=="" set "SOUND_TYPE=default"

set "SCRIPT_DIR=%~dp0"
set "SOUNDS_DIR=%SCRIPT_DIR%..\sounds"

REM Try bip.wav first, then notify.wav, then system sound
set "SOUND_FILE=%SOUNDS_DIR%\bip.wav"

if exist "%SOUND_FILE%" (
    powershell -Command "(New-Object System.Media.SoundPlayer '%SOUND_FILE%').PlaySync()"
) else (
    set "SOUND_FILE=%SOUNDS_DIR%\notify.wav"
    if exist "%SOUND_FILE%" (
        powershell -Command "(New-Object System.Media.SoundPlayer '%SOUND_FILE%').PlaySync()"
    ) else (
        REM Use Windows system notification sound as fallback
        powershell -Command "[System.Media.SystemSounds]::Asterisk.Play()"
    )
)

endlocal