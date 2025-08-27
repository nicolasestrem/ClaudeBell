@echo off
setlocal

REM ClaudeBell - Windows 11 Compatible Sound Player
REM Secure version with better error handling and Windows 11 compatibility

set "SOUND_TYPE=%~1"
if "%SOUND_TYPE%"=="" set "SOUND_TYPE=default"

set "SCRIPT_DIR=%~dp0"
set "SOUNDS_DIR=%SCRIPT_DIR%..\sounds"

REM Normalize paths to handle spaces and special characters
for %%i in ("%SOUNDS_DIR%") do set "SOUNDS_DIR=%%~fi"

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

REM Create temp PowerShell script for better compatibility
set "TEMP_PS=%TEMP%\claudebell_%RANDOM%.ps1"

REM Write PowerShell script to temp file
echo # ClaudeBell PowerShell Sound Player > "%TEMP_PS%"
echo try { >> "%TEMP_PS%"
echo     Add-Type -AssemblyName System.Windows.Forms >> "%TEMP_PS%"
echo     $soundFile = '%SOUND_FILE%' >> "%TEMP_PS%"
echo     if (Test-Path $soundFile) { >> "%TEMP_PS%"
echo         $player = New-Object System.Media.SoundPlayer $soundFile >> "%TEMP_PS%"
echo         $player.PlaySync() >> "%TEMP_PS%"
echo         $player.Dispose() >> "%TEMP_PS%"
echo     } else { >> "%TEMP_PS%"
echo         # Try fallback sounds >> "%TEMP_PS%"
echo         $fallbacks = @('%SOUNDS_DIR%\bip.wav', '%SOUNDS_DIR%\notify.wav') >> "%TEMP_PS%"
echo         $played = $false >> "%TEMP_PS%"
echo         foreach ($fallback in $fallbacks) { >> "%TEMP_PS%"
echo             if ((Test-Path $fallback) -and (-not $played)) { >> "%TEMP_PS%"
echo                 $player = New-Object System.Media.SoundPlayer $fallback >> "%TEMP_PS%"
echo                 $player.PlaySync() >> "%TEMP_PS%"
echo                 $player.Dispose() >> "%TEMP_PS%"
echo                 $played = $true >> "%TEMP_PS%"
echo             } >> "%TEMP_PS%"
echo         } >> "%TEMP_PS%"
echo         if (-not $played) { >> "%TEMP_PS%"
echo             [System.Media.SystemSounds]::Asterisk.Play() >> "%TEMP_PS%"
echo         } >> "%TEMP_PS%"
echo     } >> "%TEMP_PS%"
echo } catch { >> "%TEMP_PS%"
echo     try { [System.Media.SystemSounds]::Asterisk.Play() } catch { } >> "%TEMP_PS%"
echo } >> "%TEMP_PS%"

REM Execute PowerShell script
powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%TEMP_PS%" 2>nul

REM Clean up temp file
if exist "%TEMP_PS%" del "%TEMP_PS%" 2>nul

endlocal