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
    powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "& { try { Add-Type -AssemblyName System.Windows.Forms; $player = New-Object System.Media.SoundPlayer '%SOUND_FILE%'; $player.PlaySync(); $player.Dispose() } catch { try { [System.Media.SystemSounds]::Asterisk.Play() } catch { } } }" 2>nul
) else (
    REM Try alternative sound files if the mapped one doesn't exist
    if exist "%SOUNDS_DIR%\bip.wav" (
        powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "& { try { Add-Type -AssemblyName System.Windows.Forms; $player = New-Object System.Media.SoundPlayer '%SOUNDS_DIR%\bip.wav'; $player.PlaySync(); $player.Dispose() } catch { try { [System.Media.SystemSounds]::Asterisk.Play() } catch { } } }" 2>nul
    ) else if exist "%SOUNDS_DIR%\notify.wav" (
        powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "& { try { Add-Type -AssemblyName System.Windows.Forms; $player = New-Object System.Media.SoundPlayer '%SOUNDS_DIR%\notify.wav'; $player.PlaySync(); $player.Dispose() } catch { try { [System.Media.SystemSounds]::Asterisk.Play() } catch { } } }" 2>nul
    ) else (
        REM Use Windows system notification sound as fallback
        powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "& { try { [System.Media.SystemSounds]::Asterisk.Play() } catch { } }" 2>nul
    )
)

endlocal