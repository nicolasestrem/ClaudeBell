@echo off
setlocal

REM ClaudeBell - Windows Sound Player
REM Plays notification sounds for Claude Code

set "SOUND_TYPE=%~1"
if "%SOUND_TYPE%"=="" set "SOUND_TYPE=default"

set "SCRIPT_DIR=%~dp0"
set "SOUNDS_DIR=%SCRIPT_DIR%..\sounds"

REM Map sound types to appropriate files
if "%SOUND_TYPE%"=="alert" (
    set "SOUND_FILE=%SOUNDS_DIR%\bip.wav"
) else if "%SOUND_TYPE%"=="success" (
    set "SOUND_FILE=%SOUNDS_DIR%\notify.wav"
) else if "%SOUND_TYPE%"=="gentle" (
    set "SOUND_FILE=%SOUNDS_DIR%\notify.wav"
) else (
    set "SOUND_FILE=%SOUNDS_DIR%\bip.wav"
)

REM Try to play the mapped sound file
if exist "%SOUND_FILE%" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "try { (New-Object System.Media.SoundPlayer '%SOUND_FILE%').PlaySync() } catch { [System.Media.SystemSounds]::Asterisk.Play() }"
) else (
    REM Try alternative sound files if the mapped one doesn't exist
    if exist "%SOUNDS_DIR%\bip.wav" (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "try { (New-Object System.Media.SoundPlayer '%SOUNDS_DIR%\bip.wav').PlaySync() } catch { [System.Media.SystemSounds]::Asterisk.Play() }"
    ) else if exist "%SOUNDS_DIR%\notify.wav" (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "try { (New-Object System.Media.SoundPlayer '%SOUNDS_DIR%\notify.wav').PlaySync() } catch { [System.Media.SystemSounds]::Asterisk.Play() }"
    ) else (
        REM Use Windows system notification sound as fallback
        powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Media.SystemSounds]::Asterisk.Play()"
    )
)

endlocal